import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_chats.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetUserChats getUserChats;

  ChatListBloc({required this.getUserChats}) : super(ChatListInitial()) {
    on<LoadUserChats>(_onLoadUserChats);
  }

  Future<void> _onLoadUserChats(
    LoadUserChats event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());

    await emit.forEach(
      getUserChats(GetUserChatsParams(userId: event.userId)),
      onData: (chats) => ChatListLoaded(chats),
      onError: (error, _) => ChatListError(error.toString()),
    );
  }
}
