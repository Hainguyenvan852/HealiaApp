import 'package:healio_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({required super.id, required super.fullName, required super.email, super.avatarUrl, super.gender, super.dateOfBirth, super.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as DateTime?,
      phoneNumber: json['phone_number'] as String?
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email': email,
    'avatar_url': avatarUrl,
    'gender': gender,
    'date_of_birth': dateOfBirth,
    'phone_number': phoneNumber
  };
}