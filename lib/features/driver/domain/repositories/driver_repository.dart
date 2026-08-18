import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../order/domain/entities/order_entity.dart';

abstract class DriverRepository {
  Future<Either<String, void>> updateStatus(bool isOnline);
  Future<Either<String, List<dynamic>>> getAvailableOrders(); // dynamic for now, should be OrderEntity
  Future<Either<String, OrderEntity>> acceptOrder(String orderId);
  Future<void> updateLocation(Position position);
}
