import 'package:dartz/dartz.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _cartItems = [];

  @override
  Future<Either<String, List<CartItemEntity>>> addToCart(CartItemEntity item) async {
    final index = _cartItems.indexWhere((i) => i.product.id == item.product.id);
    if (index != -1) {
      _cartItems[index] = CartItemEntity(
        product: _cartItems[index].product,
        quantity: _cartItems[index].quantity + item.quantity,
      );
    } else {
      _cartItems.add(item);
    }
    return Right(List.from(_cartItems));
  }

  @override
  Future<Either<String, List<CartItemEntity>>> removeFromCart(int productId) async {
    _cartItems.removeWhere((i) => i.product.id == productId.toString());
    return Right(List.from(_cartItems));
  }

  @override
  Future<Either<String, List<CartItemEntity>>> getCart() async {
    return Right(List.from(_cartItems));
  }
}
