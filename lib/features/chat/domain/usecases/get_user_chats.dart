import '../../../../core/usecase/stream_usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetUserChats
    implements StreamUseCase<List<ChatEntity>, GetUserChatsParams> {
  final ChatRepository repository;

  GetUserChats(this.repository);

  @override
  Stream<List<ChatEntity>> call(GetUserChatsParams params) {
    return repository.getUserChats(params.userId);
  }
}

class GetUserChatsParams {
  final String userId;

  GetUserChatsParams({required this.userId});
}
