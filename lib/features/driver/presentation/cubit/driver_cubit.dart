import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/usecases/accept_order_usecase.dart';
import '../../domain/usecases/update_location_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import '../../domain/usecases/get_available_orders_usecase.dart';
import '../../../../core/services/socket_service.dart';

part 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final AcceptOrderUseCase acceptOrderUseCase;
  final UpdateLocationUseCase updateLocationUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final GetAvailableOrdersUseCase getAvailableOrdersUseCase;
  final SocketService socketService;

  DriverCubit({
    required this.acceptOrderUseCase,
    required this.updateLocationUseCase,
    required this.updateStatusUseCase,
    required this.getAvailableOrdersUseCase,
    required this.socketService,
  }) : super(DriverInitial());

  Future<void> updateStatus(bool isOnline) async {
    emit(DriverLoading());
    final result = await updateStatusUseCase(isOnline);
    result.fold(
      (failure) => emit(DriverError(failure)),
      (_) {
        emit(DriverStatusUpdated(isOnline));
        if (isOnline) {
          loadAvailableOrders();
        }
      },
    );
  }

  Future<void> loadAvailableOrders() async {
    emit(DriverLoading());
    final result = await getAvailableOrdersUseCase();
    result.fold(
      (failure) => emit(DriverError(failure)),
      (orders) => emit(DriverOrdersLoaded(orders)),
    );
  }

  Future<void> acceptOrder(String orderId) async {
    emit(DriverLoading());
    final result = await acceptOrderUseCase(orderId);
    result.fold(
      (failure) => emit(DriverError(failure)),
      (order) => emit(DriverOrderAccepted(order)),
    );
  }

  Future<void> updateLocation(Position position, String? currentOrderId) async {
    await updateLocationUseCase(position);
    if (currentOrderId != null) {
      socketService.updateLocation(currentOrderId, position.latitude, position.longitude);
    }
    emit(DriverLocationUpdated(position));
  }
}
