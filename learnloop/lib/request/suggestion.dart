import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../UserProvider.dart';
import '../person/UserProfile.dart';

class SuggestedForYouTab extends StatefulWidget {
  @override
  _SuggestedForYouTabState createState() => _SuggestedForYouTabState();
}

class _SuggestedForYouTabState extends State<SuggestedForYouTab> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> profiles = [];
  bool isLoading = true;
  int? _userId;
  Set<int> swappedProfiles = {};
  String profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";//"assets/moha.jpg";

  @override
  void initState() {
    super.initState();

    fetchUserId();
    fetchUserId().then((_) => fetchProfiles());
    fetchUserId().then((_) => fetchSwappedProfiles());
  }

  Future<void> fetchUserId() async {
    final user =
        context.read<UserProvider>().user;

    if (user == null) return;

    try {
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

  Future<void> fetchProfiles() async {
    try {
      final response = await supabase.from('users').select();

      setState(() {
        profiles = List<Map<String, dynamic>>.from(response)
            .where((profile) => profile['id'] != _userId)
            .toList();
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching profiles: $error');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> fetchSwappedProfiles() async {
    try {
      if (_userId == null) {
        print('User ID is not set');
        return;
      }

      final response = await supabase
          .from('users')
          .select('request_sent')
          .eq('id', _userId!)
          .single();

      if (response == null || response['request_sent'] == null) {
        print('Error fetching swapped profiles: Response or request_sent is null');
        return;
      }

      List<dynamic> requestSent = response['request_sent'];
      setState(() {
        swappedProfiles = requestSent.map<int>((entry) => entry['id'] as int).toSet();
      });

      print('Fetched swapped profiles: $swappedProfiles');
    } catch (error) {
      print('Error fetching swapped profiles: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => filterProfiles(value),
            cursorColor: Colors.green,
            decoration: InputDecoration(
              labelText: "Search Profiles",
              labelStyle: const TextStyle(
                color: Colors.green,
              ),

              prefixIcon: Icon(Icons.search, color: Colors.green),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
            ),

          ),
        ),
        Expanded(
          child: Container(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Column(
                          children: [
                            buildSuggestedCard(
                              userId: profile['id'],
                              name: profile['name'] ?? 'Unknown',
                              ratings: profile['rating']?.toString() ?? 'N/A',
                                profileImageUrl : (profile['profile_picture'] != null && profile['profile_picture'].isNotEmpty)
                                    ? profile['profile_picture']
                                    : profilePicture,

                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    )),
        ),
      ],
    );
  }

  void filterProfiles(String query) {
    setState(() {
      profiles = profiles
          .where((profile) =>
              profile['name']?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  Widget buildSuggestedCard({
    required int userId,
    required String name,
    required String ratings,
    required String profileImageUrl,
  }) {
    bool isSwapped = swappedProfiles.contains(userId);

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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 30,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isSwapped) {
                                await handleUnswap(userId);
                              } else {
                                await handleSwap(userId);
                              }
                            },
                            icon: Icon(
                              isSwapped ? Icons.cancel_outlined : Icons.swap_horiz,
                              color: isSwapped ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Ratings: $ratings',
                        style: TextStyle(color: Color(0xE1DADAFF)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Future<void> handleSwap(int profileId) async {
    try {
      final user = context.read<UserProvider>().user;

      if (user == null || _userId == null) {
        print('User not logged in or ID not set.');
        return;
      }

      final response = await supabase
          .from('users')
          .select('request_sent')
          .eq('id', _userId!)
          .single();

      List<dynamic> requestSent = response['request_sent'] ?? [];
      requestSent.add({'id': profileId,'status': 'pending'});

      await supabase
          .from('users')
          .update({'request_sent': requestSent})
          .eq('id', _userId!);

      final response2 = await supabase
          .from('users')
          .select('request_received')
          .eq('id', profileId)
          .single();

      List<dynamic> requestReceived = response2['request_received'] ?? [];
      requestReceived.add({'id': _userId, 'status': 'pending'});

      await supabase
          .from('users')
          .update({'request_received': requestReceived})
          .eq('id', profileId);

      setState(() {
        swappedProfiles.add(profileId);
      });

      print('Profile swapped successfully');
    } catch (error) {
      print('Error handling swap: $error');
    }
  }


  Future<void> handleUnswap(int profileId) async {
    try {
      if (_userId == null) {
        print('User ID is not set');
        return;
      }

      final response = await supabase
          .from('users')
          .select('request_sent')
          .eq('id', _userId!)
          .single();

      List<dynamic> requestSent = response['request_sent'] ?? [];
      requestSent.removeWhere((entry) => entry['id'] == profileId);

      await supabase
          .from('users')
          .update({'request_sent': requestSent})
          .eq('id', _userId!);

      final response2 = await supabase
          .from('users')
          .select('request_received')
          .eq('id', profileId)
          .single();

      List<dynamic> requestReceived = response2['request_received'] ?? [];
      requestReceived.removeWhere((entry) => entry['id'] == _userId);

      await supabase
          .from('users')
          .update({'request_received': requestReceived})
          .eq('id', profileId);

      setState(() {
        swappedProfiles.remove(profileId);
      });

      print('Profile unswapped successfully');
    } catch (error) {
      print('Error handling unswap: $error');
    }
  }

}

extension on PostgrestFilterBuilder<PostgrestList> {
  execute() {}
}













