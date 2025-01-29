import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../UserProvider.dart';
import '../person/UserProfile.dart';

class SentRequestsTab extends StatefulWidget {
  @override
  _SentRequestsTabState createState() => _SentRequestsTabState();
}

class _SentRequestsTabState extends State<SentRequestsTab> {
  List<Map<String, dynamic>> sentProfiles = [];
  bool isLoading = true;
  int? _userId;
  String profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";//"assets/moha.jpg";


  @override
  void initState() {
    super.initState();
    fetchUserIdAndRequests();
  }

  Future<void> fetchUserIdAndRequests() async {
    await fetchUserId();
    if (_userId != null) {
      await fetchSentRequests();
    } else {
      print('User ID not found. Skipping fetchSentRequests.');
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

  Future<void> fetchSentRequests() async {
    try {
      if (_userId == null) {
        print('User ID is null. Cannot fetch sent requests.');
        return;
      }

      final requestSentResponse = await Supabase.instance.client
          .from('users')
          .select('request_sent')
          .eq('id', _userId!)
          .single();

      final requestSentJson = requestSentResponse['request_sent'] as List<dynamic>?;

      if (requestSentJson == null || requestSentJson.isEmpty) {
        print('No sent requests found.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isLoading = false;
          });
        });
        return;
      }

      List<Map<String, dynamic>> profiles = [];
      for (var i in requestSentJson) {
        final id = i['id'];
        final status = i['status'];

        if(id is int){
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('id, name, profile_picture, rating')
              .eq('id', id)
              .single();

          profiles.add({
            'id': userResponse['id'],
            'name': userResponse['name'],
            'profile_picture': userResponse['profile_picture'],
            'ratings': userResponse['rating'] ?? 'N/A',
            'status': status,
          });
        } else {
          print('Invalid ID in request_sent: $id');
        }



      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          sentProfiles = profiles;
          isLoading = false;
        });
      });

      print('Fetched Profiles: $sentProfiles');
    } catch (error) {
      print('Error fetching sent requests: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }



  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        _userId == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : UserProfile(
          loggedInUserId: _userId!,
          profileUserId: userId,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sentProfiles.length,
        itemBuilder: (context, index) {
          final profile = sentProfiles[index];
          final userId = profile['id'];
          if (userId == null) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all( 8.0),
            child: buildSentCard(
              userId: userId,
              name: profile['name'] ?? 'Unknown',

              stats: {},
              ratings: profile['rating']?.toString() ?? 'N/A',
                profileImageUrl : (profile['profile_picture'] != null && profile['profile_picture'].isNotEmpty)
                    ? profile['profile_picture']
                    : profilePicture,
              status: profile['status']
            ),
          );
        },
      ),
    );
  }

  Widget buildSentCard({
    required int userId,
    required String name,
   // required String role,
    required Map<String, String> stats,
    required String profileImageUrl,
    required String ratings,
    required String status,
  }) {
    return GestureDetector(
      onTap: () {
        navigateToUserProfile(userId);
      },
    child: Container(
    decoration: BoxDecoration(
    border: Border.all(color: Colors.green, width: 2),
    borderRadius: BorderRadius.circular(16),
    ),
      child: Card(
        color: Colors.white.withOpacity(0.2),
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
                   // Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
                    SizedBox(height: 8),
                    Text("Status: $status",
                        style: TextStyle(
                            color: status == "declined"
                                ? Colors.red
                                : Colors.green)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
















