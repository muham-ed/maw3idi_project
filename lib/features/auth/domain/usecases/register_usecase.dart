import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  const RegisterUseCase(this.repository);
  Future<Either<String, UserEntity>> call(UserEntity user, String password) => repository.register(user, password);
}
