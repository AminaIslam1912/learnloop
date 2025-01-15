//
//
//
 //import 'package:chatapp/screen/Registration.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:learnloop/MainPage.dart';
// import 'package:learnloop/chat/screen/ChatInterface.dart'; // Update the path as needed
// import 'package:learnloop/chat/service/firestore_service.dart';
// import 'package:intl/intl.dart';  // Import intl for formatting timestamp
//
// class ChatPage extends StatelessWidget {
//   final User? currentUser = FirebaseAuth.instance.currentUser;
//   final FirestoreService _firestoreService = FirestoreService(); // Create instance of FirestoreService
//
//   // Fetch users from Firestore, excluding the current user
//   Future<List<Map<String, dynamic>>> fetchUsers() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance.collection('users').get();
//       return snapshot.docs
//           .where((doc) => doc['uid'] != currentUser?.uid)
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching users: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainPage(), // Navigate to the login page
//               ),
//             );
//           },
//         ),
//         title: Text('Chat'),
//         actions: [
//           currentUser != null
//               ? FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(currentUser!.uid)
//                 .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return CircleAvatar(child: Icon(Icons.person));
//               }
//
//               final userData = snapshot.data!.data() as Map<String, dynamic>;
//               final photoUrl = userData['photoUrl'] ?? '';
//
//               return Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: CircleAvatar(
//                   backgroundImage: photoUrl.isNotEmpty
//                       ? NetworkImage(photoUrl)
//                       : null,
//                   child: photoUrl.isEmpty ? Icon(Icons.person) : null,
//                 ),
//               );
//             },
//           )
//               : Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: CircleAvatar(child: Icon(Icons.person)),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Divider(),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: fetchUsers(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No users available.'));
//                 }
//
//                 final users = snapshot.data!;
//
//                 return ListView.builder(
//                   itemCount: users.length,
//                   itemBuilder: (context, index) {
//                     final user = users[index];
//                     final userId = user['uid'];
//                     final userName = user['name'];
//                     final photoUrl = user['photoUrl'] ?? '';
//
//                     return FutureBuilder<Map<String, dynamic>>(
//                       future: _firestoreService.getLastMessage(
//                         userId: currentUser!.uid,
//                         peerId: userId,
//                       ),
//                       builder: (context, messageSnapshot) {
//                         if (messageSnapshot.connectionState == ConnectionState.waiting) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: photoUrl.isNotEmpty
//                                   ? NetworkImage(photoUrl)
//                                   : null,
//                               child: photoUrl.isEmpty ? Icon(Icons.person, size: 30) : null,
//                             ),
//                             title: Text(userName ?? 'Unknown'),
//                             subtitle: Text('Loading...'),
//                           );
//                         }
//
//                         if (messageSnapshot.hasError) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: photoUrl.isNotEmpty
//                                   ? NetworkImage(photoUrl)
//                                   : null,
//                               child: photoUrl.isEmpty ? Icon(Icons.person, size: 30) : null,
//                             ),
//                             title: Text(userName ?? 'Unknown'),
//                             subtitle: Text('Error fetching message'),
//                           );
//                         }
//
//                         final lastMessage = messageSnapshot.data!['message'];
//                         final timestamp = messageSnapshot.data!['timestamp'];
//
//                         // Handle both Timestamp and DateTime cases
//                         String formattedTime = 'No timestamp';
//                         if (timestamp is Timestamp) {
//                           formattedTime = DateFormat('hh:mm a').format(timestamp.toDate()); // Convert Timestamp to DateTime
//                         } else if (timestamp is DateTime) {
//                           formattedTime = DateFormat('hh:mm a').format(timestamp); // Format DateTime directly
//                         }
//
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: photoUrl.isNotEmpty
//                                 ? NetworkImage(photoUrl)
//                                 : null,
//                             child: photoUrl.isEmpty ? Icon(Icons.person, size: 30) : null,
//                           ),
//                           title: Text(userName ?? 'Unknown'),
//                           subtitle: Text(lastMessage ?? 'No messages'),
//                           trailing: Padding(
//                             padding: const EdgeInsets.only(right: 10.0),
//                             child: Text(formattedTime),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatInterface(
//                                   userId: currentUser!.uid,
//                                   peerId: userId,
//                                   userName: userName,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:learnloop/MainPage.dart';
// import 'package:learnloop/chat/screen/ChatInterface.dart'; // Update the path as needed
// import 'package:learnloop/chat/service/firestore_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:intl/intl.dart'; // For timestamp formatting
// import  'package:gotrue/src/types/user.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:gotrue/src/types/user.dart' as supabase_user;
//
//
// class ChatPage extends StatelessWidget {
//   final firebase_auth.User? currentUser = FirebaseAuth.instance.currentUser;
//   final FirestoreService _firestoreService = FirestoreService();
//
//  // typedef FirebaseUser = firebase_auth.User;
//   //typedef SupabaseUser = supabase_user.User;
//
// // Usage
//  // final FirebaseUser? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
//
//   // Fetch the friends of the logged-in user from Supabase
//   Future<List<Map<String, dynamic>>> fetchFriends() async {
//     try {
//       final supabaseClient = Supabase.instance.client;
//
//       // Fetch the logged-in user's row
//       final response = await supabaseClient
//           .from('users')
//           .select('friends')
//           .eq('fire_id', currentUser?.uid as Object)
//           .single();
//
//       if (response == null || response['friends'] == null) {
//         throw Exception('No friends found for the current user');
//       }
//
//       // Extract friend IDs from the friends JSON field
//       final friendsJson = response['friends'] as List<dynamic>;
//       final friendIds = friendsJson.map((friend) => friend['id']).toList();
//
//       // Fetch friend details using the friend IDs
//       final friendsResponse = await supabaseClient
//           .from('users')
//           .select('id, name, profile_picture')
//           .any('id', friendIds);
//
//       if (friendsResponse == null) {
//         throw Exception('Error fetching friend details');
//       }
//
//       return (friendsResponse as List<dynamic>)
//           .map((friend) => friend as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching friends: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainPage(),
//               ),
//             );
//           },
//         ),
//         title: Text('Chat'),
//         actions: [
//           currentUser != null
//               ? FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(currentUser!.uid)
//                 .get(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return CircleAvatar(child: Icon(Icons.person));
//               }
//
//               final userData = snapshot.data!.data() as Map<String, dynamic>;
//               final photoUrl = userData['photoUrl'] ?? '';
//
//               return Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: CircleAvatar(
//                   backgroundImage: photoUrl.isNotEmpty
//                       ? NetworkImage(photoUrl)
//                       : null,
//                   child: photoUrl.isEmpty ? Icon(Icons.person) : null,
//                 ),
//               );
//             },
//           )
//               : Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: CircleAvatar(child: Icon(Icons.person)),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Divider(),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: fetchFriends(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError || !snapshot.hasData) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (snapshot.data!.isEmpty) {
//                   return Center(child: Text('No friends available.'));
//                 }
//
//                 final friends = snapshot.data!;
//
//                 return ListView.builder(
//                   itemCount: friends.length,
//                   itemBuilder: (context, index) {
//                     final friend = friends[index];
//                     final userId = friend['id'];
//                     final userName = friend['name'];
//                     final photoUrl = friend['profile_picture'] ?? '';
//
//                     return FutureBuilder<Map<String, dynamic>>(
//                       future: _firestoreService.getLastMessage(
//                         userId: currentUser!.uid,
//                         peerId: userId.toString(),
//                       ),
//                       builder: (context, messageSnapshot) {
//                         if (messageSnapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: photoUrl.isNotEmpty
//                                   ? NetworkImage(photoUrl)
//                                   : null,
//                               child: photoUrl.isEmpty
//                                   ? Icon(Icons.person, size: 30)
//                                   : null,
//                             ),
//                             title: Text(userName ?? 'Unknown'),
//                             subtitle: Text('Loading...'),
//                           );
//                         }
//
//                         if (messageSnapshot.hasError) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: photoUrl.isNotEmpty
//                                   ? NetworkImage(photoUrl)
//                                   : null,
//                               child: photoUrl.isEmpty
//                                   ? Icon(Icons.person, size: 30)
//                                   : null,
//                             ),
//                             title: Text(userName ?? 'Unknown'),
//                             subtitle: Text('Error fetching message'),
//                           );
//                         }
//
//                         final lastMessage = messageSnapshot.data!['message'];
//                         final timestamp = messageSnapshot.data!['timestamp'];
//
//                         String formattedTime = 'No timestamp';
//                         if (timestamp is Timestamp) {
//                           formattedTime = DateFormat('hh:mm a')
//                               .format(timestamp.toDate());
//                         } else if (timestamp is DateTime) {
//                           formattedTime = DateFormat('hh:mm a')
//                               .format(timestamp);
//                         }
//
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: photoUrl.isNotEmpty
//                                 ? NetworkImage(photoUrl)
//                                 : null,
//                             child: photoUrl.isEmpty
//                                 ? Icon(Icons.person, size: 30)
//                                 : null,
//                           ),
//                           title: Text(userName ?? 'Unknown'),
//                           subtitle: Text(lastMessage ?? 'No messages'),
//                           trailing: Padding(
//                             padding: const EdgeInsets.only(right: 10.0),
//                             child: Text(formattedTime),
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatInterface(
//                                   userId: currentUser!.uid,
//                                   peerId: userId.toString(),
//                                   userName: userName,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// extension on PostgrestFilterBuilder<PostgrestList> {
//   any(String s, List friendIds) {}
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:learnloop/MainPage.dart';
// import 'package:learnloop/chat/screen/ChatInterface.dart'; // Update the path as needed
// import 'package:learnloop/chat/service/firestore_service.dart';
// import 'package:postgrest/postgrest.dart'; // Import Supabase dependency for making API calls
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class ChatPage extends StatelessWidget {
//    final  currentUser = FirebaseAuth.instance.currentUser;
//   // final FirestoreService _firestoreService = FirestoreService();
//   //final currentUser = FirebaseAuth.instance.currentUser;
//    final FirestoreService _firestoreService = FirestoreService();
//   // Fetch the `fire_id` of the current Firebase user from Supabase
//   Future<String?> getCurrentUserFireId() async {
//     try {
//       final supabaseClient = Supabase.instance.client;
//       final response = await supabaseClient
//           .from('users')
//           .select('fire_id')
//           .eq('fire_id', currentUser?.uid as Object)
//           .single();
//
//       if (response == null || response['fire_id'] == null) {
//         throw Exception('No matching user found in Supabase for current Firebase user');
//       }
//
//       return response['fire_id'] as String?;
//     } catch (e) {
//       print('Error fetching fire_id: $e');
//       return null;
//     }
//   }
//
//   // Fetch the friends of the current user from Supabase
//   Future<List<String>> fetchFriends() async {
//     try {
//       final fireId = await getCurrentUserFireId();
//       if (fireId == null) throw Exception('Current user fire_id not found');
//
//       final supabaseClient = Supabase.instance.client;
//       final response = await supabaseClient
//           .from('users')
//           .select('friends')
//           .eq('fire_id', fireId)
//           .single();
//
//       if (response == null || response['friends'] == null) {
//         throw Exception('No friends found for the current user');
//       }
//
//       // Parse the friends JSON field to extract friend IDs
//       final friendsJson = response['friends'] as List<dynamic>;
//       return friendsJson.map((friend) => friend['id'].toString()).toList();
//     } catch (e) {
//       print('Error fetching friends: $e');
//       return [];
//     }
//   }
//
//   // Fetch friend details from Firestore
//   Future<List<Map<String, dynamic>>> fetchFriendDetails(List<String> friendIds) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('uid', whereIn: friendIds)
//           .get();
//
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print('Error fetching friend details: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainPage(),
//               ),
//             );
//           },
//         ),
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Divider(),
//           Expanded(
//             child: FutureBuilder<List<String>>(
//               future: fetchFriends(),
//               builder: (context, friendIdsSnapshot) {
//                 if (friendIdsSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (friendIdsSnapshot.hasError || friendIdsSnapshot.data == null) {
//                   return Center(child: Text('Error: ${friendIdsSnapshot.error}'));
//                 }
//                 final friendIds = friendIdsSnapshot.data!;
//                 return FutureBuilder<List<Map<String, dynamic>>>(
//                   future: fetchFriendDetails(friendIds),
//                   builder: (context, friendsSnapshot) {
//                     if (friendsSnapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (friendsSnapshot.hasError || friendsSnapshot.data == null) {
//                       return Center(child: Text('Error: ${friendsSnapshot.error}'));
//                     }
//                     final friends = friendsSnapshot.data!;
//                     return ListView.builder(
//                       itemCount: friends.length,
//                       itemBuilder: (context, index) {
//                         final friend = friends[index];
//                         final userId = friend['uid'];
//                         final userName = friend['name'];
//                         final photoUrl = friend['photoUrl'] ?? '';
//
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: photoUrl.isNotEmpty
//                                 ? NetworkImage(photoUrl)
//                                 : null,
//                             child: photoUrl.isEmpty ? Icon(Icons.person, size: 30) : null,
//                           ),
//                           title: Text(userName ?? 'Unknown'),
//                           subtitle: Text('Tap to chat'),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatInterface(
//                                   userId: currentUser!.uid,
//                                   peerId: userId,
//                                   userName: userName,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:learnloop/MainPage.dart';
// import 'package:learnloop/chat/screen/ChatInterface.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class ChatPage extends StatelessWidget {
//   final currentUser = FirebaseAuth.instance.currentUser;
//
//   // Fetch the `fire_id` of the current Firebase user from Supabase
//   Future<String?> getCurrentUserFireId() async {
//     try {
//       final supabaseClient = Supabase.instance.client;
//       final response = await supabaseClient
//           .from('users')
//           .select('fire_id')
//           .eq('fire_id', currentUser?.uid as Object)
//           .single();
//
//       print(response);
//
//       if (response == null || response['fire_id'] == null) {
//         throw Exception('No matching user found in Supabase for the current Firebase user');
//       }
//
//       return response['fire_id'] as String?;
//     } catch (e) {
//       print('Error fetching fire_id: $e');
//       return null;
//     }
//   }
//
//   // Fetch the friends list of the current user from Supabase
//   Future<List<int>> fetchFriends() async {
//     try {
//       String? id = currentUser?.uid;
//       final fireId = await getCurrentUserFireId();
//       if (fireId == null) throw Exception('Current user fire_id not found');
//
//       final supabaseClient = Supabase.instance.client;
//       final response = await supabaseClient
//           .from('users')
//           .select('friends')
//           .eq('fire_id', id as Object )
//           .single();
//       //print(response);
//       if (response == null || response['friends'] == null) {
//         throw Exception('No friends found for the current user');
//       }
//
//       //print(response);
//
//       // Parse the friends JSON field to extract friend IDs
//       final friendsJson = response['friends'] as List<dynamic>;
//       return friendsJson.map((friend) => friend['id'] as int).toList();
//     } catch (e) {
//       print('Error fetching friends: $e');
//       return [];
//     }
//   }
//
//   // Fetch friend details from Supabase `users` table including `fire_id`
//   // Future<List<Map<String, dynamic>>> fetchFriendDetails(List<int> friendIds) async {
//   //   try {
//   //
//   //     //print()
//   //     if (friendIds.isEmpty) return [];
//   //     print(friendIds);
//   //     int id = 16;
//   //     final supabaseClient = Supabase.instance.client;
//   //     final response = await supabaseClient
//   //         .from('users')
//   //         .select('id, name, profile_picture, fire_id')
//   //         .eq('id', id);
//   //     print(response);
//   //     if (response == null || response.isEmpty) {
//   //       throw Exception('No friend details found in Supabase');
//   //     }
//   //
//   //     return List<Map<String, dynamic>>.from(response as List<dynamic>);
//   //   } catch (e) {
//   //     print('Error fetching friend details: $e');
//   //     return [];
//   //   }
//   // }
//
//   // Fetch friend details from Supabase `users` table including `fire_id`
//   Future<List<Map<String, dynamic>>> fetchFriendDetails(List<int> friendIds) async {
//     try {
//       // Return an empty list if no friend IDs are provided
//       if (friendIds.isEmpty) return [];
//
//       final supabaseClient = Supabase.instance.client;
//       List<Map<String, dynamic>> friendDetails = [];
//
//       // Iterate over each friend ID in the list
//       for (int friendId in friendIds) {
//         final response = await supabaseClient
//             .from('users')
//             .select('id, name, profile_picture, fire_id')
//             .eq('id', friendId)
//             .maybeSingle(); // Fetch a single record or null
//
//         if (response != null) {
//           friendDetails.add(Map<String, dynamic>.from(response));
//         }
//       }
//
//       return friendDetails;
//     } catch (e) {
//       print('Error fetching friend details: $e');
//       return [];
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainPage(),
//               ),
//             );
//           },
//         ),
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           Divider(),
//           Expanded(
//             child: FutureBuilder<List<int>>(
//               future: fetchFriends(),
//               builder: (context, friendIdsSnapshot) {
//                 if (friendIdsSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (friendIdsSnapshot.hasError || friendIdsSnapshot.data == null) {
//                   return Center(child: Text('Error: ${friendIdsSnapshot.error}'));
//                 }
//                 final friendIds = friendIdsSnapshot.data!;
//                 print(friendIds);
//                 return FutureBuilder<List<Map<String, dynamic>>>(
//                   future: fetchFriendDetails(friendIds),
//                   builder: (context, friendsSnapshot) {
//                     if (friendsSnapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (friendsSnapshot.hasError || friendsSnapshot.data == null) {
//                       return Center(child: Text('Error: ${friendsSnapshot.error}'));
//                     }
//                     final friends = friendsSnapshot.data!;
//                     print(friends);
//                     return ListView.builder(
//                       itemCount: friends.length,
//                       itemBuilder: (context, index) {
//                         final friend = friends[index];
//                         final friendFireId = friend['fire_id'];
//                         final friendName = friend['name'];
//                         final profilePicture = friend['profile_picture'] ?? '';
//
//                         return ListTile(
//                           leading:
//                           CircleAvatar(
//                             backgroundImage: profilePicture.isNotEmpty
//                                 ? const AssetImage("PICforREGISTRATION.png")
//                                 : null,
//                             child: profilePicture.isEmpty
//                                 ? Icon(Icons.person, size: 30)
//                                 : null,
//                           ),
//                           title: Text(friendName ?? 'Unknown'),
//                          subtitle: Text('Tap to chat'),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatInterface(
//                                   userId: currentUser!.uid,
//                                   peerId: friendFireId,
//                                   userName: friendName,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// extension on PostgrestFilterBuilder<PostgrestList> {
//   in_(String s, List<int> friendIds) {}
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnloop/MainPage.dart';
import 'package:learnloop/chat/screen/ChatInterface.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String searchQuery = ""; // Holds the search query
  bool isSearching = false; // To track search mode

  Future<List<int>> fetchFriends() async {
    try {
      String? id = currentUser?.uid;
      final supabaseClient = Supabase.instance.client;
      final response = await supabaseClient
          .from('users')
          .select('friends')
          .eq('fire_id', id as Object)
          .single();

      if (response == null || response['friends'] == null) {
        throw Exception('No friends found for the current user');
      }

      final friendsJson = response['friends'] as List<dynamic>;
      return friendsJson.map((friend) => friend['id'] as int).toList();
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchFriendDetails(List<int> friendIds) async {
    try {
      if (friendIds.isEmpty) return [];

      final supabaseClient = Supabase.instance.client;
      List<Map<String, dynamic>> friendDetails = [];

      for (int friendId in friendIds) {
        final response = await supabaseClient
            .from('users')
            .select('id, name, profile_picture, fire_id')
            .eq('id', friendId)
            .maybeSingle();

        if (response != null) {
          friendDetails.add(Map<String, dynamic>.from(response));
        }
      }

      return friendDetails;
    } catch (e) {
      print('Error fetching friend details: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchLastMessage(String friendFireId) async {
    try {
      final chatId = currentUser!.uid.compareTo(friendFireId) < 0
          ? "${currentUser!.uid}_$friendFireId"
          : "${friendFireId}_${currentUser!.uid}";

      final snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return {
          'lastMessage': data['message'],
          'timestamp': data['timestamp'],
        };
      }

      return null;
    } catch (e) {
      print('Error fetching last message: $e');
      return null;
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    DateTime messageTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(messageTime);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(messageTime); // e.g., 2:30 PM
    } else {
      return DateFormat('d MMM').format(messageTime); // e.g., 7 Jan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          },
        ),
        title: isSearching
            ? TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchQuery = value.trim().toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search by name',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,  // Remove the border
            contentPadding: EdgeInsets.only(left: 10.0, top: 11.0, bottom: 8.0),  // Adjust vertical padding
          ),

        )
            : Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchQuery = ""; // Clear search query when closing search
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(
            child: FutureBuilder<List<int>>(
              future: fetchFriends(),
              builder: (context, friendIdsSnapshot) {
                if (friendIdsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (friendIdsSnapshot.hasError || friendIdsSnapshot.data == null) {
                  return Center(child: Text('Error: ${friendIdsSnapshot.error}'));
                }
                final friendIds = friendIdsSnapshot.data!;
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchFriendDetails(friendIds),
                  builder: (context, friendsSnapshot) {
                    if (friendsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (friendsSnapshot.hasError || friendsSnapshot.data == null) {
                      return Center(child: Text('Error: ${friendsSnapshot.error}'));
                    }
                    final friends = friendsSnapshot.data!;
                    final filteredFriends = friends.where((friend) {
                      final friendName = friend['name']?.toLowerCase() ?? '';
                      return friendName.contains(searchQuery);
                    }).toList();

                    if (filteredFriends.isEmpty) {
                      return Center(child: Text('No matching user found'));
                    }

                    return ListView.builder(
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = filteredFriends[index];
                        final friendFireId = friend['fire_id'];
                        final friendName = friend['name'];
                        final profilePicture = friend['profile_picture'] ?? '';

                        return FutureBuilder<Map<String, dynamic>?>(
                          future: fetchLastMessage(friendFireId),
                          builder: (context, messageSnapshot) {
                            final lastMessage =
                                messageSnapshot.data?['lastMessage'] ?? '';
                            final timestamp = messageSnapshot.data?['timestamp'];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: profilePicture.isNotEmpty
                                    ? NetworkImage(profilePicture)
                                    : null,
                                child: profilePicture.isEmpty
                                    ? Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(friendName ?? 'Unknown'),
                              subtitle: Text(lastMessage),
                              trailing: Text(formatTimestamp(timestamp)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatInterface(
                                      userId: currentUser!.uid,
                                      peerId: friendFireId,
                                      userName: friendName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}