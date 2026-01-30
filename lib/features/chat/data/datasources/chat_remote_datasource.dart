import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages();
  Future<void> sendMessage(MessageModel message);
}