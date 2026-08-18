import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderHistoryUseCase {
  final OrderRepository repository;
  const GetOrderHistoryUseCase(this.repository);

  Future<Either<String, List<OrderEntity>>> call() => repository.getOrderHistory();
}
