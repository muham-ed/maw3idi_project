import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? role; // 'client' or 'driver'
  final String? token;
  final String? avatar;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.token,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, phone, role, token, avatar];
}
