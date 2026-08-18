import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, void>> sendOTP(String phoneNumber);
  Future<Either<String, UserEntity>> verifyOTP(String phoneNumber, String otp);
  Future<Either<String, UserEntity>> login(String email, String password);
  Future<Either<String, UserEntity>> register(UserEntity user, String password);
  Future<Either<String, void>> logout();
  Future<Either<String, UserEntity>> getCurrentUser();
}
