import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:learnloop/chat/service/firestore_service.dart';
import 'package:learnloop/chat/screen/ChatPage.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatInterface extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userName; // The name of the other user in the chat
  final String peerId; // The ID of the user being chatted with
  final String peerProfilePicture;

  const ChatInterface({
    Key? key,
    required this.userId,
    required this.userName,
    required this.peerId,
    required this.peerProfilePicture,
  }) : super(key: key);

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? peerPhotoUrl;

  // Send a message to the Firestore database.
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

  // Open a calendar to pick a date and time for scheduling a class
  Future<void> _scheduleClass() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime scheduledDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final String formattedDateTime =
        DateFormat('MMM dd, yyyy, hh:mm a').format(scheduledDateTime);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Class scheduled for $formattedDateTime'),
          ),
        );

        await FirebaseFirestore.instance.collection('schedules').add({
          'userId': widget.userId,
          'peerId': widget.peerId,
          'scheduledAt': scheduledDateTime,
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            ).then((shouldRefresh) {
              if (shouldRefresh == true) {
                setState(() {});
              }
            });
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.peerProfilePicture.isNotEmpty
                  ? NetworkImage(widget.peerProfilePicture)
                  : const NetworkImage(
                  "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"), // Default image
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async {
              const String meetLink = 'https://meet.google.com/landing';
              await launchUrl(Uri.parse(meetLink),
                  mode: LaunchMode.externalApplication);
            },
          ),
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: _scheduleClass,
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(),
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
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == widget.userId;

                    return GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(text: message['message']),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message copied!')),
                        );
                      },
                      child: Align(
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
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['message'],
                            style: const TextStyle(color: Colors.black),
                          ),

                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
