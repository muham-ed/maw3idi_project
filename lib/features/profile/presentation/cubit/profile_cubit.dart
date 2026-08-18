import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  ProfileCubit(this.getProfileUseCase) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
