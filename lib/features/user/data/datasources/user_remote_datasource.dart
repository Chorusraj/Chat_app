import 'package:chat_app/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Stream<List<UserModel>> getAllUsers();
}