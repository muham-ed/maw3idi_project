import 'package:dio/dio.dart';

class DriverRemoteDataSource {
  final Dio dio;
  DriverRemoteDataSource(this.dio);

  Future<void> updateStatus(Map<String, dynamic> body) async {
    await dio.patch('driver/status', data: body);
  }

  Future<List<dynamic>> getAvailableOrders() async {
    final response = await dio.get('driver/available-orders');
    return response.data as List;
  }

  Future<dynamic> acceptOrder(String orderId) async {
    final response = await dio.post('driver/accept-order/$orderId');
    return response.data;
  }
}
