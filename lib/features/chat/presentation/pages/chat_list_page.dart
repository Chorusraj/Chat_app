import 'package:chat_app/core/cache/user_cache.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/user/presentation/bloc/user_list_bloc.dart';
import 'package:chat_app/features/user/presentation/bloc/user_list_event.dart';
import 'package:chat_app/features/user/presentation/bloc/user_list_state.dart';
import 'package:chat_app/features/user/presentation/pages/users_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/chat_list_bloc.dart';
import '../bloc/chat_list_event.dart';
import '../bloc/chat_list_state.dart';
import 'chat_page.dart';
import '../../presentation/bloc/chat_bloc.dart';

class ChatsListPage extends StatelessWidget {
  final String currentUserId;

  const ChatsListPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final userCache = UserCache();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ChatListBloc>()..add(LoadUserChats(currentUserId)),
        ),
        BlocProvider(create: (_) => sl<UserListBloc>()..add(LoadUsers())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UsersListPage(currentUserId: currentUserId),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocListener<UserListBloc, UserListState>(
          listener: (context, state) {
            if (state is UserListLoaded) {
              userCache.setUsers({for (var u in state.users) u.id: u.name});
            }
          },
          child: BlocBuilder<ChatListBloc, ChatListState>(
            builder: (context, chatState) {
              if (chatState is ChatListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatState is ChatListLoaded) {
                if (chatState.chats.isEmpty) {
                  return const Center(child: Text('No chats yet'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chatState.chats.length,
                  separatorBuilder: (_, __) => const Divider(indent: 72),
                  itemBuilder: (_, index) {
                    final chat = chatState.chats[index];
                    final otherUserId = chat.participants.firstWhere(
                      (id) => id != currentUserId,
                    );
                    final otherUserName = userCache.getUserName(otherUserId);

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        child: Text(
                          otherUserName.isNotEmpty
                              ? otherUserName[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(
                        otherUserName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ChatBloc(
                                getMessages: sl(),
                                sendMessage: sl(),
                                chatId: chat.id,
                                participants: chat.participants,
                              )..add(LoadMessages()),
                              child: ChatPage(currentUserId: currentUserId),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              if (chatState is ChatListError) {
                return Center(child: Text(chatState.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
