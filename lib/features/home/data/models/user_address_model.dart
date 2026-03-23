import 'package:healio_app/features/home/domain/entities/user_address_entity.dart';

class UserAddressModel extends UserAddressEntity{
  UserAddressModel({required super.id, required super.userId, required super.name, required super.address, required super.latitude, required super.longitude});

  factory UserAddressModel.fromJson(Map<String, dynamic> json){

    final List<dynamic> coordinates = json['location']['coordinates'];
    final longitude = (coordinates[0] as num).toDouble();
    final latitude = (coordinates[1] as num).toDouble();

    return UserAddressModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        latitude: latitude,
        longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': address,
    'address': userId,
    'location': 'POINT(${longitude} ${latitude})',
  };
}