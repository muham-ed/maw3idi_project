import 'package:dartz/dartz.dart';
import '../repositories/driver_repository.dart';

class GetAvailableOrdersUseCase {
  final DriverRepository repository;
  const GetAvailableOrdersUseCase(this.repository);

  Future<Either<String, List<dynamic>>> call() => repository.getAvailableOrders();
}
