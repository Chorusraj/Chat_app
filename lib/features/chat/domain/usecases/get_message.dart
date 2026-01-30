import 'package:chat_app/core/usecase/stream_usecase.dart';
import 'package:chat_app/features/chat/domain/entities/message_entitiy.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class GetMessages implements StreamUseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Stream<List<MessageEntity>> call(GetMessagesParams params) {
    return repository.getMessages(params.chatId);
  }
}

class GetMessagesParams {
  final String chatId;

  GetMessagesParams(this.chatId);
}
