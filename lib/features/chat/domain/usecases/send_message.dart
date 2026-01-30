import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<void> call(SendMessageParams params) {
    return repository.sendMessage(
      chatId: params.chatId,
      text: params.text,
      senderId: params.senderId,
      participants: params.participants,
    );
  }
}

class SendMessageParams {
  final String text;
  final String senderId;
  final String chatId;
  final List<String> participants;

  SendMessageParams({
    required this.text,
    required this.senderId,
    required this.chatId,
    required this.participants,
  });
}
