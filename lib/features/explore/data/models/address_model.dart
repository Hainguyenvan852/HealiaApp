import 'package:healio_app/features/explore/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity{

  AddressModel({
    required super.id,
    required super.name,
    required super.address,
    super.district,
    required super.province,
    super.commune,
    required super.lat,
    required super.lng
  });

  factory AddressModel.fromJson(Map<String, dynamic> json){

    return AddressModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      district: json['district'] as String?,
      province: json['province'] as String,
      commune: json['commune'] as String?,
      lng: (json['lng'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'district': district,
    'province': province,
    'commune': commune,
    'location': 'POINT($lng $lat)',
  };
}