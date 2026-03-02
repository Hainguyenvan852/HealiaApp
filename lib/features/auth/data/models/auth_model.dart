import 'package:healio_app/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity{
  AuthModel({required super.id, required super.email});

  factory AuthModel.fromJson(Map<String, dynamic> json){
    return AuthModel(
      id: json['id'] as String,
      email: json['email'] as String
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email
  };
}