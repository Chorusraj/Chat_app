import 'package:chat_app/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Stream<List<UserEntity>> getAllUsers();
}
