import 'package:chat_app/features/chat/domain/entities/message_entitiy.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages();
  Future<void> sendMessage(String text, String senderId);
}
