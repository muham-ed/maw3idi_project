import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;
  const CreateOrderUseCase(this.repository);

  Future<Either<String, OrderEntity>> call(OrderEntity order) => repository.createOrder(order);
}
