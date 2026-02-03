import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserChats extends ChatListEvent {
  final String userId;

  const LoadUserChats(this.userId);

  @override
  List<Object?> get props => [userId];
}
