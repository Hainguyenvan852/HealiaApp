import 'package:healio_app/features/home/domain/entities/simple_store_entity.dart';

class SimpleStoreModel extends SimpleStoreEntity{
  SimpleStoreModel({required super.id, required super.name, required super.rating, required super.distance, required super.bookingNumber, required super.district, required super.city, required super.imageUrl, required super.address, required super.primaryCategory});

  factory SimpleStoreModel.fromJson(Map<String, dynamic> json){
    return SimpleStoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      district: json['district'] as String?,
      city: json['city'] as String?,
      primaryCategory: json['primary_category'] as String,
      bookingNumber: json['booking_number'] as int,
      imageUrl: json['image_url'] as String?,
      rating: json['rating'] as double,
      distance: json['distance'] as double,
    );
  }
}