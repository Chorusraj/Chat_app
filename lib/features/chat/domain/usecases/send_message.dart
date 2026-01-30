import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<void> call(SendMessageParams params) {
    return repository.sendMessage(
      params.text,
      params.senderId,
    );
  }
}

class SendMessageParams {
  final String text;
  final String senderId;

  SendMessageParams({
    required this.text,
    required this.senderId,
  });
}
