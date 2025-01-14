import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../UserProvider.dart';
import '../person/UserProfile.dart';

class Swapped extends StatefulWidget {
  @override
  _SwappedState createState() => _SwappedState();
}

class _SwappedState extends State<Swapped> {
  List<Map<String, dynamic>> friendsProfiles = [];
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    fetchUserIdAndFriends();
  }

  Future<void> fetchUserIdAndFriends() async {
    await fetchUserId();
    if (_userId != null) {
      await fetchFriends();
    } else {
      print('User ID not found. Skipping fetchFriends.');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserId() async {
    try {
      final user = context.read<UserProvider>().user;

      if (user == null) {
        print('No logged-in user found.');
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('email', user.email as Object)
          .single();

      if (response != null && response['id'] is int) {
        setState(() {
          _userId = response['id'];
        });
        print('Fetched User ID: $_userId');
      } else {
        print('No user found with email ${user.email}');
      }
    } catch (error) {
      print('Error fetching user ID: $error');
    }
  }

  Future<void> fetchFriends() async {
    try {
      if (_userId == null) {
        print('User ID is null. Cannot fetch friends.');
        return;
      }

      final friendsResponse = await Supabase.instance.client
          .from('users')
          .select('friends')
          .eq('id', _userId!)
          .single();

      final friendsJson = friendsResponse['friends'] as List<dynamic>?;

      if (friendsJson == null || friendsJson.isEmpty) {
        print('No friends found.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> profiles = [];

      for (var friend in friendsJson) {
        final id = friend['id'];

        final userResponse = await Supabase.instance.client
            .from('users')
            .select('id, name, profile_picture, occupation')
            .eq('id', id)
            .single();

        profiles.add({
          'id': userResponse['id'],
          'name': userResponse['name'],
          'profile_picture': userResponse['profile_picture'],
          'occupation': userResponse['occupation'] ?? '',
        });
      }

      setState(() {
        friendsProfiles = profiles;
        isLoading = false;
      });

      print('Fetched Friends: $friendsProfiles');
    } catch (error) {
      print('Error fetching friends: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserProfile(
              loggedInUserId: _userId!,
              profileUserId: userId,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swapped Friends'),
      ),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: friendsProfiles.length,
          itemBuilder: (context, index) {
            final profile = friendsProfiles[index];
            final userId = profile['id'];
            if (userId == null) {
              return SizedBox.shrink(); // Skip invalid profiles
            }
            return buildFriendCard(
              userId: userId,
              name: profile['name'] ?? 'Unknown',
              occupation: profile['occupation'] ?? 'Unknown',
              profileImageUrl: profile['profile_picture'] ??
                  'https://via.placeholder.com/150',
            );
          },
        ),
      ),
    );
  }

  Widget buildFriendCard({
    required int userId,
    required String name,
    required String occupation,
    required String profileImageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        navigateToUserProfile(userId);
      },
      child: Card(
        color: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 30,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(occupation, style: TextStyle(color: Color(0xE1DADAFF))),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Message button pressed for user ID: $userId');
                  // Navigate to chat or message functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF679186),
                  foregroundColor: Colors.white,
                ),
                child: Text('Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
