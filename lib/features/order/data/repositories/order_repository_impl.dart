import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl with ErrorHandler implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final orderModel = await remoteDataSource.createOrder({
        'total': order.total,
        'address': order.address,
        'items': order.items.map((item) => {
          'productId': item.product.id,
          'quantity': item.quantity,
          'price': item.product.price
        }).toList(),
      });
      return Right(orderModel);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to create order'));
    }
  }

  @override
  Future<Either<String, OrderEntity>> getOrderById(String id) async {
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to fetch order'));
    }
  }

  @override
  Future<Either<String, List<OrderEntity>>> getOrderHistory() async {
    try {
      final orders = await remoteDataSource.getOrders();
      return Right(orders);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to fetch order history'));
    }
  }
}
