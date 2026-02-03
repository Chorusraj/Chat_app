import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserEntity> users;

  const UserListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserListError extends UserListState{
  final String message;

  const UserListError(this.message);
}
