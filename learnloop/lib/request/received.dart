//
//
// import 'package:flutter/material.dart';
//
// class ReceivedRequestsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           buildReceivedCard(
//             name: "Farzana",
//             role: "Musician",
//             experience: "5 years",
//             stats: {"likes": "3k+", "followers": "65+"},
//             actionButtons: ["Accept", "Delete"],
//           ),
//           SizedBox(height: 16),
//           buildReceivedCard(
//             name: "Mrittika",
//             role: "Designer",
//             experience: "4 years",
//             stats: {"likes": "258", "followers": "23"},
//             actionButtons: ["Accept", "Delete"],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildReceivedCard({
//     required String name,
//     required String role,
//     required String experience,
//     required Map<String, String> stats,
//     required List<String> actionButtons,
//   }) {
//     return Card(
//       color: Colors.black.withOpacity(0.5), // Transparent color
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   // backgroundImage: NetworkImage("https://via.placeholder.com/150"),
//                   backgroundImage: AssetImage('assets/PICforREGISTRATION.jpg'),
//                   radius: 30,
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                       Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
//                       Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
//                       Row(
//                         children: [
//                           Icon(Icons.favorite, size: 16, color: Colors.red),
//                           SizedBox(width: 4),
//                           Text(stats['likes']!, style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: actionButtons.map((btn) {
//                 return Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: btn == "Delete" ? Color(0xFFFDA89C) : Color(0xFF679186),
//                       foregroundColor: btn == "Delete" ? Colors.black : Colors.white,
//                     ),
//                     child: Text(btn),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../UserProvider.dart';
// import 'package:provider/provider.dart';
//
// class ReceivedRequestsTab extends StatefulWidget {
//   @override
//   _ReceivedRequestsTabState createState() => _ReceivedRequestsTabState();
// }
//
// class _ReceivedRequestsTabState extends State<ReceivedRequestsTab> {
//   List<Map<String, dynamic>> receivedProfiles = [];
//   bool isLoading = true;
//   int? _userId;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchReceivedRequests(); // Fetch profiles when the widget initializes
//   }
//
//   Future<void> fetchReceivedRequests() async {
//     try {
//       final user = context.read<UserProvider>().user; // Get the user from Provider
//
//       if (user == null) {
//         print('No logged-in user found.');
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       // Fetch the `request_received` column for the logged-in user
//       final requestReceivedResponse = await Supabase.instance.client
//           .from('users')
//           .select('request_received')
//           .eq('email', user.email as Object)
//           .single();
//
//       final requestReceivedJson = requestReceivedResponse['request_received'] as List<dynamic>?;
//
//       if (requestReceivedJson == null || requestReceivedJson.isEmpty) {
//         print('No received requests found.');
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       // Filter out null or invalid IDs
//       final validRequests = requestReceivedJson.where((item) => item['id'] != null).toList();
//
//       print('Valid request_received: $validRequests');
//
//
//       // Initialize an empty list for profiles
//       List<Map<String, dynamic>> profiles = [];
//
//       // Loop through each valid ID
//       for (var i in validRequests) {
//         final id = i['id'] ;
//
//
//         // Fetch user details for the current ID
//         final userResponse = await Supabase.instance.client
//             .from('users')
//             .select('name, profile_picture, rating') // Select the required fields
//             .eq('id', id)
//             .single();
//
//         // Add the fetched details to the profiles list
//         profiles.add({
//         //  'id': userResponse['id'],
//           'name': userResponse['name'],
//           'profile_picture': userResponse['profile_picture'],
//           'rating': userResponse['rating'] ?? 'N/A',
//         });
//       }
//
//       // Update the state with the fetched profiles
//       setState(() {
//         receivedProfiles = profiles;
//         isLoading = false;
//       });
//
//       print('Fetched Profiles: $receivedProfiles');
//     } catch (error) {
//       print('Error fetching received requests: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : receivedProfiles.isEmpty
//           ? Center(child: Text('No requests received', style: TextStyle(color: Colors.white)))
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: receivedProfiles.length,
//         itemBuilder: (context, index) {
//           final profile = receivedProfiles[index];
//           final actions = <String>['Accept', 'Delete'];
//           return Column(
//             children: [
//
//               buildReceivedCard(
//                 name: profile['name'] ?? 'Unknown',
//                 role: profile['occupation'] ?? 'Unknown',
//               //  experience: profile['experience'] ?? 'Unknown',
//               //  stats: {"likes": profile['likes']?.toString() ?? '0'},
//               //  actionButtons: actions,
//                 profileId: profile['id'],
//                 profileImageUrl:  profile['profile_picture'] ??
//                     'https://via.placeholder.com/150',
//               ),
//               SizedBox(height: 16),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildReceivedCard({
//     required String name,
//     required String role,
//     //required String experience,
//    // required Map<String, String> stats,
//      //required List<String> actionButtons,
//    required int profileId,
//     required String profileImageUrl,
//
//   }) {
//     return Card(
//       color: Colors.black.withOpacity(0.5), // Transparent color
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(profileImageUrl),
//                   radius: 30,
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                       Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
//                     //  Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
//                       Row(
//                         children: [
//                           Icon(Icons.favorite, size: 16, color: Colors.red),
//                           SizedBox(width: 4),
//                         //  Text(stats['likes']!, style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: actionButtons.map((btn) {
//                 return Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                     //  handleActionButton(profileId, btn);
//                       if (btn == "Accept" || btn == "Delete") {
//                         handleActionButton(profileId, btn);
//                       } else {
//                         print('Unknown action: $btn');
//                       }
//
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: btn == "Delete" ? Color(0xFFFDA89C) : Color(0xFF679186),
//                       foregroundColor: btn == "Delete" ? Colors.black : Colors.white,
//                     ),
//                     child: Text(btn),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void handleActionButton(int? profileId, String action) async {
//     try {
//       // if (profileId == null) {
//       //   print('Error: profileId is null.');
//       //   return;
//       // }
//
//       final validProfileId = profileId ?? -1;
//
//       if (validProfileId == -1) {
//         print('Error: Invalid profile ID.');
//         return;
//       }
//
//       if (action == "Accept") {
//         print('Accepted request from user ID: $profileId');
//         // Add logic to accept the friend request
//       } else if (action == "Delete") {
//         print('Deleted request from user ID: $profileId');
//         // Remove the request from `request_received`
//         receivedProfiles.removeWhere((profile) => profile['id'] == profileId);
//
//         // Update the database
//         final updatedRequestReceived = receivedProfiles
//             .map((profile) => {'id': profile['id']})
//             .toList(); // Rebuild the JSON structure
//
//         await Supabase.instance.client
//             .from('users')
//             .update({'request_received': updatedRequestReceived})
//             .eq('id', _userId as Object);
//
//         setState(() {
//           receivedProfiles = receivedProfiles;
//         });
//       }
//     } catch (error) {
//       print('Error handling action $action for user ID $profileId: $error');
//     }
//   }
//
// }






// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../UserProvider.dart';
// import '../person/UserProfile.dart';
//
// class ReceivedRequestsTab extends StatefulWidget {
//   @override
//   _ReceivedRequestsTabState createState() => _ReceivedRequestsTabState();
// }
//
// class _ReceivedRequestsTabState extends State<ReceivedRequestsTab> {
//   List<Map<String, dynamic>> receivedProfiles = [];
//   bool isLoading = true;
//   int? _userId;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndRequests();
//   }
//
//   Future<void> fetchUserIdAndRequests() async {
//     await fetchUserId();
//     if (_userId != null) {
//       await fetchReceivedRequests();
//     } else {
//       print('User ID not found. Skipping fetchReceivedRequests.');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchUserId() async {
//     try {
//       final user = context.read<UserProvider>().user;
//
//       if (user == null) {
//         print('No logged-in user found.');
//         return;
//       }
//
//       final response = await Supabase.instance.client
//           .from('users')
//           .select('id')
//           .eq('email', user.email as Object)
//           .single();
//
//       if (response != null && response['id'] is int) {
//         setState(() {
//           _userId = response['id'];
//         });
//         print('Fetched User ID: $_userId');
//       } else {
//         print('No user found with email ${user.email}');
//       }
//     } catch (error) {
//       print('Error fetching user ID: $error');
//     }
//   }
//
//   Future<void> fetchReceivedRequests() async {
//     try {
//       if (_userId == null) {
//         print('User ID is null. Cannot fetch received requests.');
//         return;
//       }
//
//       final requestReceivedResponse = await Supabase.instance.client
//           .from('users')
//           .select('request_received')
//           .eq('id', _userId!)
//           .single();
//
//       final requestReceivedJson = requestReceivedResponse['request_received'] as List<dynamic>?;
//
//       if (requestReceivedJson == null || requestReceivedJson.isEmpty) {
//         print('No received requests found.');
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       List<Map<String, dynamic>> profiles = [];
//
//       for (var i in requestReceivedJson) {
//         final id = i['id'];
//
//         final userResponse = await Supabase.instance.client
//             .from('users')
//             .select('name, profile_picture, rating') // Customize fields as needed
//             .eq('id', id)
//             .single();
//
//         profiles.add({
//           'id':userResponse['id'],
//           'name': userResponse['name'],
//           'profile_picture': userResponse['profile_picture'],
//           'ratings': userResponse['rating'] ?? 'N/A',
//         });
//       }
//
//       setState(() {
//         receivedProfiles = profiles;
//         isLoading = false;
//       });
//
//       print('Fetched Profiles: $receivedProfiles');
//     } catch (error) {
//       print('Error fetching received requests: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: receivedProfiles.length,
//         itemBuilder: (context, index) {
//           final profile = receivedProfiles[index];
//           return buildReceivedCard(
//               userId: profile['id'],
//               name: profile['name'] ?? 'Unknown',
//               role: profile['occupation'] ?? 'Unknown',
//               // experience: profile['experience'] ?? 'Unknown',
//               stats: {
//                 // "likes": profile['likes']?.toString() ?? '0',
//                 // "followers": profile['followers']?.toString() ?? '0',
//               },
//               // backImageUrl: profile['profile_picture'] ?? 'assets/default_avatar.png',
//               ratings: profile['ratings']?.toString() ?? 'N/A',
//               profileImageUrl: profile['profile_picture'] ??
//                   'https://via.placeholder.com/150',
//               actionButtons: ["Accept", "Delete"],
//
//           );
//         }
//       ),
//     );
//   }
//
//
//   void navigateToUserProfile(int userId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//         // UserProfile(
//         //   loggedInUserId: _userId!, // Replace with appropriate logged-in user ID
//         //   profileUserId: userId,
//         // ),
//         _userId == null
//             ? const Center(
//           child: CircularProgressIndicator(),
//         ) // Show a loading indicator while fetching
//             : UserProfile(
//           loggedInUserId: _userId!,
//           profileUserId: userId,
//         ),
//       ),
//     );
//   }
//
//   Widget buildReceivedCard({
//     required int userId,
//
//     required String name,
//     required String role,
//   //  required String experience,
//     required Map<String, String> stats,
//     required List<String> actionButtons,
//     required String profileImageUrl,
//     required String ratings,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         navigateToUserProfile(userId);
//       },
//       child: Card(
//         color: Colors.black.withOpacity(0.5),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(profileImageUrl),
//                     radius: 30,
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                         Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
//                       //  Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: actionButtons.map((btn) {
//                   return Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle button actions
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: btn == "Delete" ? Color(0xFFFDA89C) : Color(0xFF679186),
//                         foregroundColor: btn == "Delete" ? Colors.black : Colors.white,
//                       ),
//                       child: Text(btn),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//



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

        if (id is int) {
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('id, name, profile_picture, rating') // Ensure `id` is selected
              .eq('id', id)
              .single();

          profiles.add({
            'id': userResponse['id'], // Ensure `id` is added
            'name': userResponse['name'],
            'profile_picture': userResponse['profile_picture'],
            'ratings': userResponse['rating'] ?? 'N/A',
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
        padding: EdgeInsets.all(16),
        itemCount: receivedProfiles.length,
        itemBuilder: (context, index) {
          final profile = receivedProfiles[index];
          final userId = profile['id'];
          if (userId == null) {
            return SizedBox.shrink(); // Skip cards without valid `id`
          }
          return buildReceivedCard(
            userId: userId,
            name: profile['name'] ?? 'Unknown',
            role: profile['role'] ?? 'Unknown',
            stats: {},
            ratings: profile['ratings']?.toString() ?? 'N/A',
            profileImageUrl: profile['profile_picture'] ??
                'https://via.placeholder.com/150',
            actionButtons: ["Accept", "Delete"],
          );
        },
      ),
    );
  }

  // void navigateToUserProfile(int userId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => UserProfile(
  //         loggedInUserId: _userId!,
  //         profileUserId: userId,
  //       ),
  //     ),
  //   );



  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        // UserProfile(
        //   loggedInUserId: _userId!, // Replace with appropriate logged-in user ID
        //   profileUserId: userId,
        // ),
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

  Widget buildReceivedCard({
    required int userId,
    required String name,
    required String role,
    required Map<String, String> stats,
    required List<String> actionButtons,
    required String profileImageUrl,
    required String ratings,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: actionButtons.map((btn) {
                  return Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button actions
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btn == "Delete"
                            ? Color(0xFFFDA89C)
                            : Color(0xFF679186),
                        foregroundColor:
                        btn == "Delete" ? Colors.black : Colors.white,
                      ),
                      child: Text(btn),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



