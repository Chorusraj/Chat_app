import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Listen to messages
class LoadMessages extends ChatEvent {}

// Send a new message
class SendMessageEvent extends ChatEvent {
  final String text;
  final String senderId;

  const SendMessageEvent({required this.text, required this.senderId});

  @override
  List<Object?> get props => [text, senderId];
}
