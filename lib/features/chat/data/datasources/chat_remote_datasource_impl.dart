import 'package:chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<ChatModel>> getUserChats(String userId) {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => ChatModel.fromFirestore(e)).toList(),
        );
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(MessageModel.fromFirestore).toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> participants,
  }) async {
    final chatRef = firestore.collection('chats').doc(chatId);

    await chatRef.set({
      'participants': participants,
      'lastMessage': message.text,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await chatRef.collection('messages').add(message.toFirestore());
  }
}
