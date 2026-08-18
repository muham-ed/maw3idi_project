import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/track_order_usecase.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/entities/order_entity.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final TrackOrderUseCase trackOrderUseCase;
  final GetOrderHistoryUseCase getOrderHistoryUseCase;

  OrderCubit({
    required this.createOrderUseCase,
    required this.trackOrderUseCase,
    required this.getOrderHistoryUseCase,
  }) : super(OrderInitial());

  Future<void> createOrder(OrderEntity order) async {
    emit(OrderLoading());
    final result = await createOrderUseCase(order);
    result.fold(
      (failure) => emit(OrderError(failure)),
      (newOrder) => emit(OrderCreated(newOrder)),
    );
  }

  Future<void> trackOrder(String orderId) async {
    emit(OrderLoading());
    final result = await trackOrderUseCase(orderId);
    result.fold(
      (failure) => emit(OrderError(failure)),
      (order) => emit(OrderTrackingLoaded(order)),
    );
  }

  Future<void> loadOrderHistory() async {
    emit(OrderLoading());
    final result = await getOrderHistoryUseCase();
    result.fold(
      (failure) => emit(OrderError(failure)),
      (orders) => emit(OrderHistoryLoaded(orders)),
    );
  }
}
