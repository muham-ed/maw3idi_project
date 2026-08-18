import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../entities/store_entity.dart';

abstract class HomeRepository {
  Future<Either<String, List<ProductEntity>>> getProducts();
  Future<Either<String, List<StoreEntity>>> getStores();
  Future<Either<String, List<ProductEntity>>> getStoreProducts(String storeId);
}
