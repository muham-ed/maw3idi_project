import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit(this.homeRepository) : super(HomeInitial());
  
  Future<void> loadStores() async {
    emit(HomeLoading());
    final result = await homeRepository.getStores();
    result.fold(
      (failure) => emit(HomeError(failure)),
      (stores) => emit(HomeLoaded(stores: stores)),
    );
  }

  Future<void> loadStoreProducts(String storeId) async {
    final currentState = state;
    List<StoreEntity> stores = [];
    if (currentState is HomeLoaded) {
      stores = currentState.stores;
    }
    emit(HomeLoading());
    final result = await homeRepository.getStoreProducts(storeId);
    result.fold(
      (failure) => emit(HomeError(failure)),
      (products) => emit(HomeLoaded(stores: stores, products: products)),
    );
  }
}
