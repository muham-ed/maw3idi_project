import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/network/error_handler.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/data/models/order_model.dart';
import '../../domain/repositories/driver_repository.dart';
import '../datasources/driver_remote_datasource.dart';
import 'package:dio/dio.dart';

class DriverRepositoryImpl with ErrorHandler implements DriverRepository {
  final DriverRemoteDataSource remoteDataSource;

  DriverRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> updateStatus(bool isOnline) async {
    try {
      await remoteDataSource.updateStatus({'isOnline': isOnline});
      return const Right(null);
    } catch (e) {
      return Left(handleError(e, 'Failed to update status'));
    }
  }

  @override
  Future<Either<String, List<dynamic>>> getAvailableOrders() async {
    try {
      final orders = await remoteDataSource.getAvailableOrders();
      return Right(orders);
    } catch (e) {
      return Left(handleError(e, 'Failed to fetch orders'));
    }
  }

  @override
  Future<Either<String, OrderEntity>> acceptOrder(String orderId) async {
    try {
      final response = await remoteDataSource.acceptOrder(orderId);
      final orderModel = OrderModel.fromJson(response);
      return Right(orderModel);
    } catch (e) {
      return Left(handleError(e, 'Failed to accept order'));
    }
  }

  @override
  Future<void> updateLocation(Position position) async {
    // This is usually handled via SocketService in the Cubit, 
    // but we can add a REST backup here if needed.
    print("Updating location: ${position.latitude}, ${position.longitude}");
  }
}
