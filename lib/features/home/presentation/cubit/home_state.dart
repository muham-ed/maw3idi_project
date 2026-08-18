part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<StoreEntity> stores;
  final List<ProductEntity> products;
  const HomeLoaded({this.stores = const [], this.products = const []});
  @override
  List<Object?> get props => [stores, products];
}
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
