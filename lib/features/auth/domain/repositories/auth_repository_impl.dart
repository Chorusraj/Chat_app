import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    try {
      return await remoteDataSource.register(email, password);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return remoteDataSource.getCurrentUser();
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }
}
