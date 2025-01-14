//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SentRequestsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/background_app.png'), // Background image
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           buildSentCard(
//               name: "Robbie Harrison",
//               role: "Musician",
//               experience: "5 years",
//               stats: {"likes": "3k+", "followers": "65+"},
//               //  imageUrl: "https://via.placeholder.com/150", // Replace with actual image
//               backImage:"assets/PICforREGISTRATION.jpg"
//           ),
//           SizedBox(height: 16),
//           buildSentCard(
//               name: "James Smith",
//               role: "Musician",
//               experience: "5 years",
//               stats: {"likes": "5k+", "followers": "60+"},
//               //imageUrl: "https://via.placeholder.com/150", // Replace with actual image
//               backImage:"assets/PICforREGISTRATION.jpg"
//
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSentCard({
//     required String name,
//     required String role,
//     required String experience,
//     required Map<String, String> stats,
//     // required String imageUrl,
//     required String backImage
//   }) {
//     return Card(
//       color: Colors.black.withOpacity(0.5), // Transparent color
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage(backImage),
//               radius: 30,
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                   Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
//                   Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
//                   Row(
//                     children: [
//                       Icon(Icons.favorite, size: 16, color: Colors.red),
//                       SizedBox(width: 4),
//                       Text(stats['likes']!, style: TextStyle(color: Colors.white)),
//                       SizedBox(width: 16),
//                       Icon(Icons.flash_on, size: 16, color: Colors.white),
//                       SizedBox(width: 4),
//                       Text(stats['followers']!, style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 // Handle menu selection
//               },
//               itemBuilder: (BuildContext context) {
//                 // return ['Seen', 'Accepted', 'Declined']
//                 //     .map((choice) => PopupMenuItem<String>(
//                 //   value: choice,
//                 //   child: Text(choice),
//                 // ))
//                 //     .toList();
//                 return [
//                   PopupMenuItem<String>(
//                     value: 'Seen',
//                     child: Text('Seen'),
//                   ),
//                   PopupMenuDivider(),
//                   PopupMenuItem<String>(
//                     value: 'Accepted',
//                     child: Text('Accepted'),
//                   ),
//                   PopupMenuDivider(),
//                   PopupMenuItem<String>(
//                     value: 'Declined',
//                     child: Text('Declined'),
//                   ),
//
//
//
//                 ];
//               },
//               icon: Icon(Icons.more_vert, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Import Provider package
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../UserProvider.dart'; // Import UserProvider
//
// class SentRequestsTab extends StatefulWidget {
//   @override
//   _SentRequestsTabState createState() => _SentRequestsTabState();
// }
//
// class _SentRequestsTabState extends State<SentRequestsTab> {
//   List<Map<String, dynamic>> sentProfiles = []; // List to store fetched profiles
//   bool isLoading = true;
//   int? _userId;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndRequests(); // Fetch user ID and requests sequentially
//   }
//
//   Future<void> fetchUserIdAndRequests() async {
//     await fetchUserId(); // Wait for fetchUserId to complete
//     if (_userId != null) {
//       await fetchSentRequests(); // Proceed only if _userId is set
//     } else {
//       print('User ID not found. Skipping fetchSentRequests.');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchUserId() async {
//     try {
//       final user = context.read<UserProvider>().user; // Get the user from Provider
//
//       if (user == null) {
//         print('No logged-in user found.');
//         return;
//       }
//
//       // Query the `users` table for the user ID
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
//   Future<void> fetchSentRequests() async {
//     try {
//       // Ensure `_userId` is available
//       if (_userId == null) {
//         print('User ID is null. Cannot fetch sent requests.');
//         return;
//       }
//
//       // Fetch `request_sent` JSON data from the database
//       final requestSentResponse = await Supabase.instance.client
//           .from('users')
//           .select('request_sent')
//           .eq('id', _userId!)
//           .single();
//
//       final requestSentJson = requestSentResponse['request_sent'] as List<dynamic>?;
//
//       if (requestSentJson == null || requestSentJson.isEmpty) {
//         print('No sent requests found.');
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       // Initialize an empty list for profiles
//       List<Map<String, dynamic>> profiles = [];
//
//       // Loop through each ID in `requestSentJson`
//       for (var i in requestSentJson) {
//         final id = i['id'];
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
//           'name': userResponse['name'],
//           'profile_picture': userResponse['profile_picture'],
//           'ratings': userResponse['rating'] ?? 'N/A',
//         });
//       }
//
//       // Update the state with the fetched profiles
//       setState(() {
//         sentProfiles = profiles;
//         isLoading = false;
//       });
//
//       print('Fetched Profiles: $sentProfiles');
//     } catch (error) {
//       print('Error fetching sent requests: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       child: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: sentProfiles.length,
//         itemBuilder: (context, index) {
//           final profile = sentProfiles[index];
//           return buildSentCard(
//             name: profile['name'] ?? 'Unknown',
//             role: profile['occupation'] ?? 'Unknown',
//            // experience: profile['experience'] ?? 'Unknown',
//             stats: {
//              // "likes": profile['likes']?.toString() ?? '0',
//              // "followers": profile['followers']?.toString() ?? '0',
//             },
//            // backImageUrl: profile['profile_picture'] ?? 'assets/default_avatar.png',
//             ratings: profile['ratings']?.toString() ?? 'N/A',
//             profileImageUrl: profile['profile_picture'] ??
//                 'https://via.placeholder.com/150',
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildSentCard({
//     required String name,
//     required String role,
//    // required String experience,
//     required Map<String, String> stats,
//     required String profileImageUrl,
//     required String ratings,
//   }) {
//     return Card(
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
//                   Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                   Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
//                  // Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
//                   Row(
//                     children: [
//                       Icon(Icons.favorite, size: 16, color: Colors.red),
//                       SizedBox(width: 4),
//                      // Text(stats['likes']!, style: TextStyle(color: Colors.white)),
//                       SizedBox(width: 16),
//                       Icon(Icons.flash_on, size: 16, color: Colors.white),
//                       SizedBox(width: 4),
//                     //  Text(stats['followers']!, style: TextStyle(color: Colors.white)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 // Handle menu selection
//               },
//               itemBuilder: (BuildContext context) {
//                 return [
//                   PopupMenuItem<String>(value: 'Seen', child: Text('Seen')),
//                   PopupMenuDivider(),
//                   PopupMenuItem<String>(value: 'Accepted', child: Text('Accepted')),
//                   PopupMenuDivider(),
//                   PopupMenuItem<String>(value: 'Declined', child: Text('Declined')),
//                 ];
//               },
//               icon: Icon(Icons.more_vert, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// extension on PostgrestFilterBuilder<PostgrestList> {
//   any(String s, List<int> requestSentIds) {}
// }



// with navigation to profile

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
  List<Map<String, dynamic>> sentProfiles = []; // List to store fetched profiles
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    fetchUserIdAndRequests(); // Fetch user ID and requests sequentially
  }

  Future<void> fetchUserIdAndRequests() async {
    await fetchUserId(); // Wait for fetchUserId to complete
    if (_userId != null) {
      await fetchSentRequests(); // Proceed only if _userId is set
    } else {
      print('User ID not found. Skipping fetchSentRequests.');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> fetchUserId() async {
  //   try {
  //     final user = context.read<UserProvider>().user; // Get the user from Provider
  //
  //     if (user == null) {
  //       print('No logged-in user found.');
  //       return;
  //     }
  //
  //     // Query the `users` table for the user ID
  //     final response = await Supabase.instance.client
  //         .from('users')
  //         .select('id')
  //         .eq('email', user.email as Object)
  //         .single();
  //
  //     if (response != null && response['id'] is int) {
  //       setState(() {
  //         _userId = response['id'];
  //       });
  //       print('Fetched User ID: $_userId');
  //     } else {
  //       print('No user found with email ${user.email}');
  //     }
  //   } catch (error) {
  //     print('Error fetching user ID: $error');
  //   }
  // }

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _userId = response['id'];
          });
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
      // Ensure `_userId` is available
      if (_userId == null) {
        print('User ID is null. Cannot fetch sent requests.');
        return;
      }

      // Fetch `request_sent` JSON data from the database
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

      // Initialize an empty list for profiles
      List<Map<String, dynamic>> profiles = [];

      // Loop through each ID in `requestSentJson`
      for (var i in requestSentJson) {
        final id = i['id'];
        final status = i['status']; // Fetch the status

        if(id is int){
          // Fetch user details for the current ID
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('id, name, profile_picture, rating') // Select the required fields
              .eq('id', id)
              .single();

          // Add the fetched details to the profiles list
          profiles.add({
            'id': userResponse['id'],
            'name': userResponse['name'],
            'profile_picture': userResponse['profile_picture'],
            'ratings': userResponse['rating'] ?? 'N/A',
            'status': status, // Include status
          });
        } else {
          print('Invalid ID in request_sent: $id');
        }



      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Update the state with the fetched profiles
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
            return SizedBox.shrink(); // Skip invalid profiles
          }
          return buildSentCard(
            userId: userId,
            name: profile['name'] ?? 'Unknown',
           // role: profile['occupation'], // Replace with appropriate role if available
            stats: {},
            ratings: profile['rating']?.toString() ?? 'N/A',
            profileImageUrl: profile['profile_picture'] ??
                'https://via.placeholder.com/150',
            status: profile['status']
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
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle menu selection
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                        value: 'Seen', child: Text('Seen')),
                    PopupMenuDivider(),
                    PopupMenuItem<String>(
                        value: 'Accepted', child: Text('Accepted')),
                    PopupMenuDivider(),
                    PopupMenuItem<String>(
                        value: 'Declined', child: Text('Declined')),
                  ];
                },
                icon: Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
















