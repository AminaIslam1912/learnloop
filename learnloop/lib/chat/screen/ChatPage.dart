
//merge code

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnloop/MainPage.dart';
import 'package:learnloop/chat/screen/ChatInterface.dart';
import 'package:intl/intl.dart';
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
      final unseenCountSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('isSeen', isEqualTo: false)
          .where('receiverId', isEqualTo:currentUser?.uid)
          .get();

      final unseenCount = unseenCountSnapshot.docs.length;

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return {
          'lastMessage': data['message'],
          'timestamp': data['timestamp'],
          'unseenCount': unseenCount,
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
      return DateFormat.jm().format(messageTime);
    } else {
      return DateFormat('d MMM').format(messageTime);
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
          decoration: const InputDecoration(
            hintText: 'Search by name',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10.0, top: 11.0, bottom: 8.0),
          ),
        )
            : Text('Chat', style: TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
            fontSize: 20,
            color: Colors.white// Adjust font size if needed
        ),),
        centerTitle: true, // Center the title
        backgroundColor: Colors.black,

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
          const Divider(),
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
                            final lastMessage = messageSnapshot.data?['lastMessage'] ?? '';
                            final timestamp = messageSnapshot.data?['timestamp'];
                            final unseenCount = messageSnapshot.data?['unseenCount'] ?? 0;

                            return Container(

                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: profilePicture.isNotEmpty
                                      ? NetworkImage(profilePicture)
                                      : const NetworkImage(
                                      "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"), // Default image
                                ),

                                title: Text(
                                  friendName ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: unseenCount > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text(
                                  lastMessage,
                                  style: TextStyle(
                                    fontWeight: unseenCount > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(formatTimestamp(timestamp)),
                                    if (unseenCount > 0)
                                      Container(
                                        margin: EdgeInsets.only(top: 4.0),
                                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          unseenCount.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () async {
                                  if (unseenCount > 0) {
                                    final chatId = currentUser!.uid.compareTo(friendFireId) < 0
                                        ? "${currentUser!.uid}_$friendFireId"
                                        : "${friendFireId}_${currentUser!.uid}";

                                    // Fetch and update unseen messages
                                    final querySnapshot = await FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(chatId)
                                        .collection('messages')
                                        .where('isSeen', isEqualTo: false)
                                        .get();

                                    for (var doc in querySnapshot.docs) {
                                      await doc.reference.update({'isSeen': true});
                                    }
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatInterface(
                                        userId: currentUser!.uid,
                                        peerId: friendFireId,
                                        userName: friendName,
                                        peerProfilePicture: profilePicture,
                                      ),
                                    ),
                                  );
                                },
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