import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl with ErrorHandler implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<ProductEntity>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to load products'));
    }
  }

  @override
  Future<Either<String, List<StoreEntity>>> getStores() async {
    try {
      final stores = await remoteDataSource.getStores();
      return Right(stores);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to load stores'));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getStoreProducts(String storeId) async {
    try {
      final products = await remoteDataSource.getStoreProducts(storeId);
      return Right(products);
    } on DioException catch (e) {
      return Left(handleError(e, 'Failed to load products'));
    }
  }
}
