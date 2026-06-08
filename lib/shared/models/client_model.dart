class ClientModel {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? profileId;
  final int storeId;
  final bool isActive;
  final DateTime? dateOfBirth;
  final int gender;
  final String fullName;
  final String email;
  final String? phoneNumber;

  ClientModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.profileId,
    required this.storeId,
    required this.isActive,
    this.dateOfBirth,
    required this.gender,
    required this.fullName,
    required this.email,
    this.phoneNumber,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      profileId: json['profile_id'],
      storeId: json['store_id'],
      isActive: json['is_active'] ?? true,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'] ?? 3,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      'store_id': storeId,
      'is_active': isActive,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
