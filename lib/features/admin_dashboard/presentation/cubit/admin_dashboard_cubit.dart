import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

part 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final Dio dio;

  AdminDashboardCubit(this.dio) : super(AdminDashboardInitial());

  Future<void> loadStats() async {
    emit(AdminDashboardLoading());
    try {
      final response = await dio.get('admin/stats');
      emit(AdminDashboardLoaded(response.data));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }
}
