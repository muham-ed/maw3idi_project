import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;
  const VerifyOtpUseCase(this.repository);
  Future<Either<String, UserEntity>> call(String phoneNumber, String otp) => repository.verifyOTP(phoneNumber, otp);
}
