import 'package:healio_app/features/home/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity{
  StoreModel({required super.id, required super.name, required super.email, required super.address, required super.ward, required super.district, required super.city, required super.country, required super.introduction, required super.managerId, required super.phoneNumber, required super.isActive, required super.latitude, required super.longitude});

  factory StoreModel.fromJson(Map<String, dynamic> json){
    return StoreModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['line'] as String,
        ward: json['ward'] as String,
        district: json['district'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        introduction: json['introduction'] as String,
        managerId: json['manager_id'] as String,
        isActive: json['is_active'] as bool,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'line': address,
    'ward': ward,
    'phone_number': phoneNumber,
    'district': district,
    'city': city,
    'country': country,
    'introduction': introduction,
    'manager_id': managerId,
    'is_active': isActive,
    'latitude': latitude,
    'longitude': longitude
  };
}