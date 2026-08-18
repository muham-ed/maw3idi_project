import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;
  const SendOtpUseCase(this.repository);

  Future<Either<String, void>> call(String phoneNumber) => repository.sendOTP(phoneNumber);
}
