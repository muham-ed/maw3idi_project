import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, description, category];
}
