import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double total;
  final String address;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, items, total, address, status, createdAt];
}
