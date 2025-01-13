import 'package:learnloop/chat/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInterface extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userName; // The name of the other user in the chat
  final String peerId; // The ID of the user being chatted with

  const ChatInterface({
    Key? key,
    required this.userId,
    required this.userName,
    required this.peerId,
  }) : super(key: key);

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? peerPhotoUrl;

  /// Fetch the peer's photo URL
  Future<void> _getPeerPhotoUrl() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.peerId)
          .get();
      if (doc.exists) {
        setState(() {
          peerPhotoUrl = doc['photoUrl'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching peer photo URL: $e');
    }
  }

  /// Send a message to the Firestore database.
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _firestoreService.sendMessage(
        senderId: widget.userId,
        receiverId: widget.peerId,
        message: message,
      );
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    //_getPeerPhotoUrl(); // Fetch peer photo URL when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: peerPhotoUrl != null && peerPhotoUrl!.isNotEmpty
                  ? NetworkImage(peerPhotoUrl!)
                  : null,
              child: peerPhotoUrl == null || peerPhotoUrl!.isEmpty
                  ? Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message List
          Divider(),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getMessages(
                userId: widget.userId,
                peerId: widget.peerId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true, // Show the latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == widget.userId;

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender
                              ? Colors.black
                              : Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message['message']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

