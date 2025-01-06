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
  // Add the Set here to track swapped profiles
  Set<int> swappedProfiles = {};

  @override
  void initState() {
    super.initState();
    fetchProfiles();
    fetchUserId(); // Fetch user ID on initialization
    fetchUserId().then((_) => fetchSwappedProfiles()); // Fetch swapped profiles after user ID
  }

  Future<void> fetchUserId() async {
    final user =
        context.read<UserProvider>().user; // Get the user from Provider

    if (user == null) return;

    try {
      // Query the `users` table for the user with the corresponding email
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('email', user.email as Object)
          .single(); // `.single()` fetches a single row

      if (response != null && response['id'] is int) {
        setState(() {
          _userId = response['id']; // Store the fetched ID
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
        profiles = List<Map<String, dynamic>>.from(response);
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
            decoration: InputDecoration(
              hintText: "Search Profiles",
              prefixIcon: Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                              userId: profile['id'], // Pass the user's ID
                              name: profile['name'] ?? 'Unknown',
                              ratings: profile['ratings']?.toString() ?? 'N/A',
                              profileImageUrl: profile['profile_picture'] ??
                                  'https://via.placeholder.com/150',
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

  // Widget buildSuggestedCard({
  //   required int userId,
  //   required String name,
  //   required String ratings,
  //   required String profileImageUrl,
  // }) {
  //   return GestureDetector(
  //     onTap: () {
  //       navigateToUserProfile(userId);
  //     },
  //     child: Card(
  //       color: Colors.black.withOpacity(0.5),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Row(
  //           children: [
  //             CircleAvatar(
  //               backgroundImage: NetworkImage(profileImageUrl),
  //               radius: 30,
  //             ),
  //             SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     name,
  //                     style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white),
  //                   ),
  //                   Text(
  //                     'Ratings: $ratings',
  //                     style: TextStyle(color: Color(0xE1DADAFF)),
  //                   ),
  //                   SizedBox(height: 8), // Space between text and buttons
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed:  () async {
  //                            await handleSwap(userId); // Call the function to handle swapping
  //     },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Color(0xFF679186),
  //                         ),
  //                         child: Text("Swap"),
  //                       ),
  //                       SizedBox(width: 8), // Space between buttons
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           // Add remove logic here
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.green,
  //                         ),
  //                         child: Text("Message"),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }



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
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Ratings: $ratings',
                      style: TextStyle(color: Color(0xE1DADAFF)),
                    ),
                    SizedBox(height: 8), // Space between text and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (isSwapped) {
                              await handleUnswap(userId); // Call Unswap
                            } else {
                              await handleSwap(userId); // Call Swap
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSwapped
                                ? Color(0xFFFDA89C) // Unswap Button Color
                                : Color(0xFF679186), // Swap Button Color
                          ),
                          child: Text(isSwapped ? "Unswap" : "Swap"),
                        ),
                        SizedBox(width: 8), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            // Add message logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text("Message"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                  ) // Show a loading indicator while fetching
                : UserProfile(
                    loggedInUserId: _userId!,
                    profileUserId: userId,
                  ),
      ),
    );
  }

  // Future<void> handleSwap(int profileId) async {
  //   try {
  //     final user = context.read<UserProvider>().user;
  //
  //     if (user == null) {
  //       print('No logged-in user found.');
  //       return;
  //     }
  //
  //     if (_userId == null) {
  //       print('Logged-in User ID is not set');
  //       return;
  //     }
  //
  //
  //     // Fetch current request_sent value
  //     final response = await supabase
  //         .from('users')
  //         .select('request_sent')
  //         .eq('id', _userId as Object)
  //         .single();
  //
  //     if (response == null || response['request_sent'] == null) {
  //       print('Error fetching request_sent: Response or request_sent is null');
  //       return;
  //     }
  //
  //     List<dynamic> requestSent = response['request_sent'];
  //     requestSent.add({'id': profileId});
  //
  //     // Update and request the updated value to be returned
  //     final updateResponse = await supabase
  //         .from('users')
  //         .update({'request_sent': requestSent})
  //         .eq('id', _userId as Object)
  //         .select(); // Explicitly request updated data
  //
  //     if (updateResponse == null || updateResponse.isEmpty) {
  //       print('Error updating request_sent: Update response is null or empty');
  //       return;
  //     }
  //
  //     print('Profile added to request_sent: $profileId');
  //     print('Updated Response: $updateResponse'); // Debugging
  //
  //     // Fetch the current `request_received` value for the target profile
  //     final response2 = await supabase
  //         .from('users')
  //         .select('request_received')
  //         .eq('id', profileId) // Target profile ID
  //         .single();
  //
  //     if (response2 == null || response2['request_received'] == null) {
  //       print('Error fetching request_received: Response or request_received is null');
  //       return;
  //     }
  //
  //     // Parse the current `request_received` JSON list
  //     List<dynamic> requestReceived = response2['request_received'];
  //
  //     // Check if the logged-in user ID already exists in the list
  //     bool userExists = requestReceived.any((entry) => entry['id'] == _userId);
  //
  //     if (userExists) {
  //       print('User already in request_received list');
  //       return;
  //     }
  //
  //     // Add the logged-in user's ID as a new JSON object to the list
  //     requestReceived.add({'id': _userId});
  //
  //     // Update the `request_received` column for the target user
  //     final updateResponse2 = await supabase
  //         .from('users')
  //         .update({'request_received': requestReceived})
  //         .eq('id', profileId) // Target profile ID
  //         .select(); // Request updated data
  //
  //     if (updateResponse2 == null || updateResponse2.isEmpty) {
  //       print('Error updating request_received: Update response is null or empty');
  //       return;
  //     }
  //
  //     print('Logged-in User ID added to request_received for profile ID: $profileId');
  //     print('Updated Response: $updateResponse2'); // Debugging
  //
  //
  //
  //
  //
  //   } catch (error) {
  //     print('Error handling swap: $error');
  //   }
  // }

  Future<void> handleSwap(int profileId) async {
    try {
      final user = context.read<UserProvider>().user;

      if (user == null || _userId == null) {
        print('User not logged in or ID not set.');
        return;
      }

      // Fetch current request_sent value
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

      // Fetch current request_received for the target profile
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
        swappedProfiles.add(profileId); // Mark profile as swapped
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

      // Fetch current request_sent value
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
     // requestReceived.add({'id': _userId});
     // requestReceived.add({'id': _userId});
      requestReceived.removeWhere((entry) => entry['id'] == _userId);

      await supabase
          .from('users')
          .update({'request_received': requestReceived})
          .eq('id', profileId);

      // Remove from swappedProfiles set
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













// Future<void> handleSwap(int profileId) async {
//   try {
//     final user = context.read<UserProvider>().user;
//
//     if (user == null) {
//       print('No logged-in user found.');
//       return;
//     }
//
//     if (_userId == null) {
//       print('User ID is not set');
//       return;
//     }
//
//     // Fetch current request_sent value
//     final response = await supabase
//         .from('users')
//         .select('request_sent')
//         .eq('id', _userId as Object)
//         .single();
//
//     if (response == null || response['request_sent'] == null) {
//       print('Error fetching request_sent: Response or request_sent is null');
//       return;
//     }
//
//     List<dynamic> requestSent = response['request_sent'];
//     requestSent.add({'id': profileId});
//
//     // Update and request the updated value to be returned
//     final updateResponse = await supabase
//         .from('users')
//         .update({'request_sent': requestSent})
//         .eq('id', _userId as Object)
//         .select(); // Explicitly request updated data
//
//     if (updateResponse == null || updateResponse.isEmpty) {
//       print('Error updating request_sent: Update response is null or empty');
//       return;
//     }
//
//     print('Profile added to request_sent: $profileId');
//     print('Updated Response: $updateResponse'); // Debugging
//
//   } catch (error) {
//     print('Error handling swap: $error');
//   }
// }


//list diye korse
// Future<void> handleSwap(int profileId) async {
//   try {
//     final user = context.read<UserProvider>().user;
//
//     if (user == null) {
//       print('No logged-in user found.');
//       return;
//     }
//
//     if (_userId == null) {
//       print('Logged-in User ID is not set');
//       return;
//     }
//
//     // Fetch the current `request_received` value for the target profile
//     final response = await supabase
//         .from('users')
//         .select('request_received')
//         .eq('id', profileId) // Target profile ID
//         .single();
//
//     if (response == null || response['request_received'] == null) {
//       print('Error fetching request_received: Response or request_received is null');
//       return;
//     }
//
//     // Add the logged-in user's ID to the target user's request_received list
//     List<dynamic> requestReceived = response['request_received'];
//     if (!requestReceived.contains(_userId)) {
//       requestReceived.add(_userId);
//     } else {
//       print('User already in request_received list');
//       return;
//     }
//
//     // Update the `request_received` column for the target user
//     final updateResponse = await supabase
//         .from('users')
//         .update({'request_received': requestReceived})
//         .eq('id', profileId) // Target profile ID
//         .select(); // Request updated data
//
//     if (updateResponse == null || updateResponse.isEmpty) {
//       print('Error updating request_received: Update response is null or empty');
//       return;
//     }
//
//     print('Logged-in User ID added to request_received for profile ID: $profileId');
//     print('Updated Response: $updateResponse'); // Debugging
//
//   } catch (error) {
//     print('Error handling swap: $error');
//   }
// }