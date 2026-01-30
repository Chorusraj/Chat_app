import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entitiy.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getUserChats(String userId);

  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String chatId,
    required List<String> participants,
  });
}
