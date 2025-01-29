
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final chatId = senderId.compareTo(receiverId) < 0
          ? '${senderId}_$receiverId'
          : '${receiverId}_$senderId';

      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages({
    required String userId,
    required String peerId,
  }) {
    try {
      final chatId = userId.compareTo(peerId) < 0
          ? '${userId}_$peerId'
          : '${peerId}_$userId';

      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      print('Error fetching messages: $e');
      return const Stream.empty();
    }
  }

  Future<Map<String, dynamic>> getLastMessage({
    required String userId,
    required String peerId,
  }) async {
    try {
      final chatId = userId.compareTo(peerId) < 0
          ? '${userId}_$peerId'
          : '${peerId}_$userId';

      final snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastMessage = snapshot.docs.first.data();
        final timestamp = lastMessage['timestamp'] as Timestamp?;

        return {
          'message': lastMessage['message'] ?? '',
          'timestamp': timestamp != null ? timestamp.toDate() : null,
        };
      }
      return {'message': '', 'timestamp': null};
    } catch (e) {
      print('Error fetching last message: $e');
      return {'message': '', 'timestamp': null};
    }
  }
}