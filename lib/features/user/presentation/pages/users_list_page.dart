import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/chat/domain/utils/chat_id_helper.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/user_list_bloc.dart';
import '../bloc/user_list_event.dart';
import '../bloc/user_list_state.dart';

class UsersListPage extends StatelessWidget {
  final String currentUserId;

  const UsersListPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserListBloc>()..add(LoadUsers()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Start new chat'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: BlocBuilder<UserListBloc, UserListState>(
            builder: (context, state) {
              if (state is UserListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserListLoaded) {
                final users = state.users
                    .where((u) => u.id != currentUserId)
                    .toList();

                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: users.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (_, index) {
                    final user = users[index];

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        user.email,
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        final chatId = getChatId(currentUserId, user.id);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ChatBloc(
                                getMessages: sl(),
                                sendMessage: sl(),
                                chatId: chatId,
                                participants: [currentUserId, user.id],
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

              if (state is UserListError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
