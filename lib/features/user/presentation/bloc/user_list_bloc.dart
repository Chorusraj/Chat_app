import 'dart:async';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/user/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_users.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetAllUsers getAllUsers;

  UserListBloc({required this.getAllUsers}) : super(UserListLoading()) {
    on<LoadUsers>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());

    await emit.forEach<List<UserEntity>>(
      getAllUsers(NoParams()),
      onData: (users) {
        return UserListLoaded(users);
      },
      onError: (error, _) {
        return (UserListError(error.toString()));
      },
    );
  }
}
