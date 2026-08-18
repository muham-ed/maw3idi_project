import 'package:dartz/dartz.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<String, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<String, OrderEntity>> getOrderById(String id);
  Future<Either<String, List<OrderEntity>>> getOrderHistory();
}
