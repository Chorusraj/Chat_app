import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/message_entitiy.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<MessageEntity>> getMessages() {
    try {
      return remoteDataSource.getMessages();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> sendMessage(String text, String senderId) async {
    try {
      final message = MessageModel(
        id: '',
        text: text,
        senderId: senderId,
        timestamp: DateTime.now(),
      );

      await remoteDataSource.sendMessage(message);
    } catch (e) {
      throw ServerFailure();
    }
  }
}
