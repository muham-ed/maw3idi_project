import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SendOtpUseCase sendOtpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.sendOtpUseCase,
  }) : super(AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(phoneNumber);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(AuthOtpSent(phoneNumber)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(email, password);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(UserEntity user, String password) async {
    emit(AuthLoading());
    final result = await registerUseCase(user, password);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(phoneNumber, otp);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
