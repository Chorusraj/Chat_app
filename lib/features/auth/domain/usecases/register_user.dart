import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class RegisterUser implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) {
    return repository.register(params.email, params.password);
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
