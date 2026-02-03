import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return ChatsListPage(currentUserId: state.user.id); // chat screen
        }

        return const LoginPage();
      },
    );
  }
}
