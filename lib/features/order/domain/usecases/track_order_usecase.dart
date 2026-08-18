import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class TrackOrderUseCase {
  final OrderRepository repository;
  const TrackOrderUseCase(this.repository);

  Future<Either<String, OrderEntity>> call(String orderId) => repository.getOrderById(orderId);
}
