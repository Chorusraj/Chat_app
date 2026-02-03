import 'package:chat_app/core/usecase/usecase.dart';

import '../../../../core/usecase/stream_usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetAllUsers
    implements StreamUseCase<List<UserEntity>, NoParams> {
  final UserRepository repository;

  GetAllUsers(this.repository);

  @override
  Stream<List<UserEntity>> call(NoParams params) {
    return repository.getAllUsers();
  }
}
