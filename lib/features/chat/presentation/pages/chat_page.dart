import 'package:chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;

  const ChatPage({super.key, required this.currentUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages());
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessageEvent(text: text, senderId: widget.currentUserId),
    );

    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_)=> _scrollToBottom(force: true));
  }

  void _scrollToBottom({bool force = false}) {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final distanceFromBottom = maxScroll - currentScroll;

    if(distanceFromBottom < 100 || force){
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }
        
                  if (state is ChatLoaded) {
                    final messages = state.messages;
        
                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
        
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _scrollToBottom(),
                    );
        
                    return ListView.separated(
                      key: const PageStorageKey('chatList'),
                      controller: _scrollController,
                      reverse: false,
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4,),
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == widget.currentUserId;
        
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blueAccent
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
        
                  return const SizedBox.shrink();
                },
              ),
            ),
        
            // Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
