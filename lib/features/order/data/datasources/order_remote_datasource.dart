import 'package:dio/dio.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSource(this.dio);

  Future<OrderModel> createOrder(Map<String, dynamic> body) async {
    final response = await dio.post('orders', data: body);
    return OrderModel.fromJson(response.data);
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await dio.get('orders/$id');
    return OrderModel.fromJson(response.data);
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await dio.get('orders');
    return (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
  }
}
