import 'package:dartz/dartz.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  const GetProfileUseCase(this.repository);

  Future<Either<String, UserEntity>> call() => repository.getCurrentUser();
}
