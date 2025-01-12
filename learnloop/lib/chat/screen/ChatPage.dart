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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnloop/MainPage.dart';
import 'package:learnloop/chat/screen/ChatInterface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Fetch the `fire_id` of the current Firebase user from Supabase
  Future<String?> getCurrentUserFireId() async {
    try {
      final supabaseClient = Supabase.instance.client;
      final response = await supabaseClient
          .from('users')
          .select('fire_id')
          .eq('fire_id', currentUser?.uid as Object)
          .single();

      if (response == null || response['fire_id'] == null) {
        throw Exception('No matching user found in Supabase for the current Firebase user');
      }

      return response['fire_id'] as String?;
    } catch (e) {
      print('Error fetching fire_id: $e');
      return null;
    }
  }

  // Fetch the friends list of the current user from Supabase
  Future<List<int>> fetchFriends() async {
    try {
      final fireId = await getCurrentUserFireId();
      if (fireId == null) throw Exception('Current user fire_id not found');

      final supabaseClient = Supabase.instance.client;
      final response = await supabaseClient
          .from('users')
          .select('friends')
          .eq('fire_id', fireId)
          .single();

      if (response == null || response['friends'] == null) {
        throw Exception('No friends found for the current user');
      }

      // Parse the friends JSON field to extract friend IDs
      final friendsJson = response['friends'] as List<dynamic>;
      return friendsJson.map((friend) => friend['id'] as int).toList();
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  // Fetch friend details from Supabase `users` table including `fire_id`
  Future<List<Map<String, dynamic>>> fetchFriendDetails(List<int> friendIds) async {
    try {
      if (friendIds.isEmpty) return [];

      final supabaseClient = Supabase.instance.client;
      final response = await supabaseClient
          .from('users')
          .select('id, name, profile_picture, fire_id')
          .in_('id', friendIds);

      if (response == null || response.isEmpty) {
        throw Exception('No friend details found in Supabase');
      }

      return List<Map<String, dynamic>>.from(response as List<dynamic>);
    } catch (e) {
      print('Error fetching friend details: $e');
      return [];
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
        title: Text('Chat'),
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
                    return ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        final friendFireId = friend['fire_id'];
                        final friendName = friend['name'];
                        final profilePicture = friend['profile_picture'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profilePicture.isNotEmpty
                                ? NetworkImage(profilePicture)
                                : null,
                            child: profilePicture.isEmpty
                                ? Icon(Icons.person, size: 30)
                                : null,
                          ),
                          title: Text(friendName ?? 'Unknown'),
                          subtitle: Text('Tap to chat'),
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
            ),
          ),
        ],
      ),
    );
  }
}

extension on PostgrestFilterBuilder<PostgrestList> {
  in_(String s, List<int> friendIds) {}
}
