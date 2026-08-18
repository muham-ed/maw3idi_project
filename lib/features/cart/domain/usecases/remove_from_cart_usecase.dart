import 'package:dartz/dartz.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;
  const RemoveFromCartUseCase(this.repository);

  Future<Either<String, List<CartItemEntity>>> call(int productId) => repository.removeFromCart(productId);
}
