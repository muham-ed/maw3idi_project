import 'package:dartz/dartz.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<String, List<CartItemEntity>>> addToCart(CartItemEntity item);
  Future<Either<String, List<CartItemEntity>>> removeFromCart(int productId);
  Future<Either<String, List<CartItemEntity>>> getCart();
}
