import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.total,
    required super.address,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      items: const [], // Simplified for now
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'address': address,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
