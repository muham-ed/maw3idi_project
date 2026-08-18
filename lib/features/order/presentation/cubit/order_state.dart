part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderCreated extends OrderState {
  final OrderEntity order;
  const OrderCreated(this.order);
  @override
  List<Object?> get props => [order];
}
class OrderTrackingLoaded extends OrderState {
  final OrderEntity order;
  const OrderTrackingLoaded(this.order);
  @override
  List<Object?> get props => [order];
}
class OrderHistoryLoaded extends OrderState {
  final List<OrderEntity> orders;
  const OrderHistoryLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}
class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}
