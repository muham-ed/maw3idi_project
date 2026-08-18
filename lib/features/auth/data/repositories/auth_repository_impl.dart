import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl with ErrorHandler implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<void> _saveToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }
  }

  @override
  Future<Either<String, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login({
        'email': email,
        'password': password,
      });
      await _saveToken(userModel.token);
      return Right(userModel);
    } catch (e) {
      return Left(handleError(e, 'Login failed'));
    }
  }

  @override
  Future<Either<String, UserEntity>> register(UserEntity user, String password) async {
    try {
      final body = UserModel.fromEntity(user).toJson();
      body['password'] = password;
      final userModel = await remoteDataSource.register(body);
      await _saveToken(userModel.token);
      return Right(userModel);
    } catch (e) {
      return Left(handleError(e, 'Registration failed'));
    }
  }

  @override
  Future<Either<String, void>> sendOTP(String phoneNumber) async {
    try {
      await remoteDataSource.sendOTP({'phone': phoneNumber});
      return const Right(null);
    } catch (e) {
      return Left(handleError(e, 'Failed to send OTP'));
    }
  }

  @override
  Future<Either<String, UserEntity>> verifyOTP(String phoneNumber, String otp) async {
    try {
      final userModel = await remoteDataSource.verifyOTP({
        'phone': phoneNumber,
        'otp': otp,
      });
      await _saveToken(userModel.token);
      return Right(userModel);
    } catch (e) {
      return Left(handleError(e, 'OTP verification failed'));
    }
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel);
    } catch (e) {
      return Left(handleError(e, 'Failed to get user'));
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return const Right(null);
  }
}
