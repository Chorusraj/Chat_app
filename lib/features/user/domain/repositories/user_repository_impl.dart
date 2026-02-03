import 'package:chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:chat_app/features/user/domain/entities/user_entity.dart';
import 'package:chat_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return remoteDataSource.getAllUsers();
  }
}
