import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? role,
    String? token,
    String? avatar,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          role: role,
          token: token,
          avatar: avatar,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'],
      token: json['token'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'token': token,
      'avatar': avatar,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
      token: entity.token,
      avatar: entity.avatar,
    );
  }
}
