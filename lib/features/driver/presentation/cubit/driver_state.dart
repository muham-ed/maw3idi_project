part of 'driver_cubit.dart';

abstract class DriverState extends Equatable {
  const DriverState();
  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}
class DriverLoading extends DriverState {}
class DriverStatusUpdated extends DriverState {
  final bool isOnline;
  const DriverStatusUpdated(this.isOnline);
  @override
  List<Object?> get props => [isOnline];
}
class DriverOrdersLoaded extends DriverState {
  final List<dynamic> orders;
  const DriverOrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}
class DriverOrderAccepted extends DriverState {
  final dynamic order;
  const DriverOrderAccepted(this.order);
  @override
  List<Object?> get props => [order];
}
class DriverLocationUpdated extends DriverState {
  final Position position;
  const DriverLocationUpdated(this.position);
  @override
  List<Object?> get props => [position];
}
class DriverError extends DriverState {
  final String message;
  const DriverError(this.message);
  @override
  List<Object?> get props => [message];
}
