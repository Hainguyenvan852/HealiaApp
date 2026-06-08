import 'package:healio_app/features/user/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.avatarUrl,
    super.dateOfBirth,
    super.phoneNumber, 
    required super.gender, 
    required super.role,
    super.verifyStore
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dob = json['date_of_birth'] != null
        ? DateTime.parse(json['date_of_birth'])
        : null;

    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as int,
      dateOfBirth: dob,
      phoneNumber: json['phone_number'] as String?, 
      role: json['role'] as String,
      verifyStore: json['verify_store'] as bool?
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email': email,
    'avatar_url': avatarUrl,
    'gender': gender,
    'date_of_birth': dateOfBirth,
    'phone_number': phoneNumber,
  };
}
