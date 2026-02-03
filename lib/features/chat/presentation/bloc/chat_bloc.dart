import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message_entitiy.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final String chatId;
  final List<String> participants;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.chatId,
    required this.participants,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await emit.onEach<List<MessageEntity>>(
      getMessages(GetMessagesParams(chatId)),
      onData: (messages) => emit(ChatLoaded(messages)),
      onError: (error, stackTrace) => emit(ChatError(error.toString())),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await sendMessage(
        SendMessageParams(
          chatId: chatId,
          text: event.text,
          senderId: event.senderId,
          participants: participants,
        ),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
