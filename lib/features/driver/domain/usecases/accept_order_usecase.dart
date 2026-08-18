import 'package:dartz/dartz.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../repositories/driver_repository.dart';

class AcceptOrderUseCase {
  final DriverRepository repository;
  const AcceptOrderUseCase(this.repository);

  Future<Either<String, OrderEntity>> call(String orderId) => repository.acceptOrder(orderId);
}
