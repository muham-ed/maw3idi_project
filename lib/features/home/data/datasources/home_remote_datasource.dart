import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSource(this.dio);

  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('products');
    return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<StoreModel>> getStores() async {
    final response = await dio.get('stores');
    return (response.data as List).map((e) => StoreModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getStoreProducts(String storeId) async {
    final response = await dio.get('stores/$storeId/products');
    return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
