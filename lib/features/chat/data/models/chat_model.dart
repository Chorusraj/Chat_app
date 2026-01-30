import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.participants,
    required super.lastMessage,
    required super.updatedAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
