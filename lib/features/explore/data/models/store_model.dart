import 'package:healio_app/features/explore/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity{
  StoreModel({
    required super.id, required super.name,
    required super.email, required super.address,
    required super.district,
    required super.city, required super.introduction,
    required super.phoneNumber, required super.ratingNumber,
    required super.imageUrl, required super.rating,
    required super.distance, required super.primaryCategory,
    required super.longitude, required super.latitude
  });

  factory StoreModel.fromJson(Map<String, dynamic> json){
    final List<dynamic> coordinates = json['location']['coordinates'];
    final longitude = (coordinates[0] as num).toDouble();
    final latitude = (coordinates[1] as num).toDouble();

    return StoreModel(
        id: json['store_id'] as int,
        name: json['store_name'] as String,
        address: json['address'] as String,
        district: json['district'] as String,
        city: json['city'] as String,
        introduction: json['introduction'] as String,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String,
        ratingNumber: json['rating_number'] as int,
        imageUrl: json['image_url'] as String,
        rating: (json['rating'] as num).toDouble(),
        distance: (json['distance'] as num).toDouble(),
        primaryCategory: json['primary_category'] as String,
        longitude: longitude,
        latitude: latitude,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'address': address,
    'phone_number': phoneNumber,
    'district': district,
    'city': city,
    'introduction': introduction,
    'image_url': imageUrl,
    'rating': rating,
  };
}