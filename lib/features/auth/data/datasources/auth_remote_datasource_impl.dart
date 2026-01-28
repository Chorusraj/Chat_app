import 'package:chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'User is null',
      );
    }

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> register(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'User is null',
      );
    }

    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}