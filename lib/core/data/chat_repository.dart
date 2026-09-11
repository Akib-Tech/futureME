import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

/// Owns `users/{uid}/chatMessages`. One flat, timestamp-ordered log per
/// user; `contextLabel` records which screen/module the message was sent
/// from (chat is placeholder/canned-bot content for now — see
/// `chat_screen.dart` — this just makes sure real message history survives
/// closing the screen, ready to swap in a real Claude-API bot later).
@lazySingleton
class ChatRepository {
  ChatRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String uid) =>
      _firestore.collection('users').doc(uid).collection('chatMessages');

  Future<List<({String sender, String text})>> loadHistory(String uid, String contextLabel) async {
    final snapshot = await _messages(
      uid,
    ).where('contextLabel', isEqualTo: contextLabel).orderBy('createdAt').limit(200).get();
    return snapshot.docs.map((doc) => (sender: doc['sender'] as String, text: doc['text'] as String)).toList();
  }

  Future<void> saveMessage(String uid, {required String contextLabel, required String sender, required String text}) {
    return _messages(uid).add({
      'sender': sender,
      'text': text,
      'contextLabel': contextLabel,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
