import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(Map<String, dynamic> body) async {
    final response = await dio.post('auth/login', data: body);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> register(Map<String, dynamic> body) async {
    final response = await dio.post('auth/register', data: body);
    return UserModel.fromJson(response.data);
  }

  Future<void> sendOTP(Map<String, dynamic> body) async {
    await dio.post('auth/send-otp', data: body);
  }

  Future<UserModel> verifyOTP(Map<String, dynamic> body) async {
    final response = await dio.post('auth/verify-otp', data: body);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await dio.get('auth/me');
    return UserModel.fromJson(response.data);
  }
}
