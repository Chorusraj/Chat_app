import 'dart:async';

import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/chat/domain/usecases/get_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;

  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await _messagesSubscription?.cancel();

    _messagesSubscription = getMessages(NoParams()).listen(
      (messages) => add(_MessagesUpdated(messages)),
      onError: (error) => emit(ChatError(error.toString())),
    );
  }

  void _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await sendMessage(
        SendMessageParams(
          text: event.text,
          senderId: event.senderId,
        ),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}

// Internal event to handle updates from stream
class _MessagesUpdated extends ChatEvent {
  final List messages;

  _MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
