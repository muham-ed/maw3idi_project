import 'package:dartz/dartz.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;
  const AddToCartUseCase(this.repository);

  Future<Either<String, List<CartItemEntity>>> call(CartItemEntity item) => repository.addToCart(item);
}
