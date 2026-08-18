import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  CartCubit(this.addToCartUseCase, this.removeFromCartUseCase) : super(CartInitial());

  Future<void> addItem(CartItemEntity item) async {
    final result = await addToCartUseCase(item);
    result.fold((failure) => emit(CartError(failure)), (items) => emit(CartLoaded(items)));
  }

  Future<void> removeItem(int productId) async {
    final result = await removeFromCartUseCase(productId);
    result.fold((failure) => emit(CartError(failure)), (items) => emit(CartLoaded(items)));
  }
}