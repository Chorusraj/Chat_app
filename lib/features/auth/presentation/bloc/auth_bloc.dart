import 'package:chat_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:chat_app/features/auth/domain/usecases/logout_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logout,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final user = await getCurrentUser();

    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await loginUser(LoginParams(event.email, event.password));
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await registerUser(
        RegisterParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'name': event.name,
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
