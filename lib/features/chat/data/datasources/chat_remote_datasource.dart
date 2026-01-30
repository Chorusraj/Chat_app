import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatModel>> getUserChats(String userId);

  Stream<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> participants,
  });
}
