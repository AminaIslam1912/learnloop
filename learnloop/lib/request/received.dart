import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../UserProvider.dart';
import '../person/UserProfile.dart';

class ReceivedRequestsTab extends StatefulWidget {
  @override
  _ReceivedRequestsTabState createState() => _ReceivedRequestsTabState();
}

class _ReceivedRequestsTabState extends State<ReceivedRequestsTab> {
  List<Map<String, dynamic>> receivedProfiles = [];
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
      await fetchReceivedRequests();
    } else {
      print('User ID not found. Skipping fetchReceivedRequests.');
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

  Future<void> fetchReceivedRequests() async {
    try {
      if (_userId == null) {
        print('User ID is null. Cannot fetch received requests.');
        return;
      }

      final requestReceivedResponse = await Supabase.instance.client
          .from('users')
          .select('request_received')
          .eq('id', _userId!)
          .single();

      final requestReceivedJson = requestReceivedResponse['request_received'] as List<dynamic>?;

      if (requestReceivedJson == null || requestReceivedJson.isEmpty) {
        print('No received requests found.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> profiles = [];

      for (var i in requestReceivedJson) {
        final id = i['id'];
        final status=i['status'];

        if (id is int) {
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
            'status':status,
          });
        } else {
          print('Invalid ID in request_received: $id');
        }
      }

      setState(() {
        receivedProfiles = profiles;
        isLoading = false;
      });

      print('Fetched Profiles: $receivedProfiles');
    } catch (error) {
      print('Error fetching received requests: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: receivedProfiles.length,
        itemBuilder: (context, index) {
          final profile = receivedProfiles[index];
          final userId = profile['id'];
          if (userId == null) {
            return SizedBox.shrink();
          }
          return buildReceivedCard(
            userId: userId,
            name: profile['name'] ?? 'Unknown',
            role: profile['role'] ?? 'Unknown',
            stats: {},
            ratings: profile['ratings']?.toString() ?? 'N/A',
            profileImageUrl : (profile['profile_picture'] != null && profile['profile_picture'].isNotEmpty)
                ? profile['profile_picture']
                : profilePicture,
            actionButtons: ["Accept", "Decline"],
            status:profile['status'],
          );
        },
      ),
    );
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

  Widget buildReceivedCard({
    required int userId,
    required String name,
    required String role,
    required Map<String, String> stats,
    required List<String> actionButtons,
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          color: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl),
                      radius: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
                          Row(
                            children: [
                              // Accept IconButton
                              IconButton(
                                onPressed: () async {
                                  await handleAcceptAction(userId);
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 20),
                              // Decline IconButton
                              IconButton(
                                onPressed: () async {
                                  await handleDeclineAction(userId);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> handleAcceptAction(int friendId) async {
    try {
      if (_userId == null) {
        print('User ID is null. Cannot accept request.');
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('friends')
          .eq('id', _userId!)
          .single();

      List<dynamic> currentFriends = response['friends'] ?? [];

      if (currentFriends.any((friend) => friend['id'] == friendId)) {
        print('Friend already exists in the list.');
        return;
      }

      currentFriends.add({'id': friendId});

      await Supabase.instance.client
          .from('users')
          .update({'friends': currentFriends})
          .eq('id', _userId!);

      print('Friend added to the current user\'s list successfully.');

      final friendResponse = await Supabase.instance.client
          .from('users')
          .select('friends')
          .eq('id', friendId)
          .single();

      List<dynamic> friendFriends = friendResponse['friends'] ?? [];

      if (!friendFriends.any((friend) => friend['id'] == _userId)) {
        friendFriends.add({'id': _userId!});
        await Supabase.instance.client
            .from('users')
            .update({'friends': friendFriends})
            .eq('id', friendId);

        final requestReceivedResponse = await Supabase.instance.client
            .from('users')
            .select('request_received')
            .eq('id', _userId!)
            .single();

        List<dynamic> requestReceived =
            requestReceivedResponse['request_received'] ?? [];
        requestReceived.removeWhere((entry) => entry['id'] == friendId);

        requestReceived = requestReceived.map((entry) {
          if (entry['id'] == _userId) {
            entry['status'] = 'accepted';
          }
          return entry;
        }).toList();

        await Supabase.instance.client
            .from('users')
            .update({'request_received': requestReceived})
            .eq('id', _userId!);



        final requestSentResponse = await Supabase.instance.client
            .from('users')
            .select('request_sent')
            .eq('id', friendId)
            .single();

        List<dynamic> requestSent = requestSentResponse['request_sent'] ?? [];
        requestSent = requestSent.map((entry) {
          if (entry['id'] == _userId) {
            entry['status'] = 'accepted';
          }
          return entry;
        }).toList();

        await Supabase.instance.client
            .from('users')
            .update({'request_sent': requestSent})
            .eq('id', friendId);

        print('Logged-in user added to the friend\'s list successfully.');
      } else {
        print('Logged-in user already exists in the friend\'s list.');
      }

      setState(() {
        receivedProfiles.removeWhere((profile) => profile['id'] == friendId);
      });
    } catch (error) {
      print('Error accepting request: $error');
    }
  }

  Future<void> handleDeclineAction(int friendId) async {
    try {
      if (_userId == null) {
        print('User ID is null. Cannot decline request.');
        return;
      }

      final requestReceivedResponse = await Supabase.instance.client
          .from('users')
          .select('request_received')
          .eq('id', _userId!)
          .single();

      List<dynamic> requestReceived =
          requestReceivedResponse['request_received'] ?? [];
      requestReceived.removeWhere((entry) => entry['id'] == friendId);
      requestReceived = requestReceived.map((entry) {
        if (entry['id'] == friendId) {
          entry['status'] = 'declined';
        }
        return entry;
      }).toList();

      await Supabase.instance.client
          .from('users')
          .update({'request_received': requestReceived})
          .eq('id', _userId!);

      final requestSentResponse = await Supabase.instance.client
          .from('users')
          .select('request_sent')
          .eq('id', friendId)
          .single();

      List<dynamic> requestSent = requestSentResponse['request_sent'] ?? [];
      requestSent = requestSent.map((entry) {
        if (entry['id'] == _userId) {
          entry['status'] = 'declined';
        }
        return entry;
      }).toList();

      await Supabase.instance.client
          .from('users')
          .update({'request_sent': requestSent})
          .eq('id', friendId);

      setState(() {
        receivedProfiles.removeWhere((profile) => profile['id'] == friendId);
      });

      print('Friend request declined.');
    } catch (error) {
      print('Error declining request: $error');
    }
  }

}



