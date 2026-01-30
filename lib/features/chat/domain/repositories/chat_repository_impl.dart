import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entitiy.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatEntity>> getUserChats(String userId) {
    try {
      return remoteDataSource.getUserChats(userId);
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    try {
      return remoteDataSource.getMessages(chatId);
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required List<String> participants,
  }) async {
    try {
      final message = MessageModel(
        id: '',
        text: text,
        senderId: senderId,
        timestamp: DateTime.now(),
      );

      await remoteDataSource.sendMessage(
        chatId: chatId,
        message: message,
        participants: participants,
      );
    } catch (e) {
      throw ServerFailure();
    }
  }
}
