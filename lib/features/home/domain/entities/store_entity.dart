import 'package:geolocator/geolocator.dart';

class StoreEntity {
  int id;
  String name;
  String email;
  String address;
  String district;
  String city;
  String introduction;
  String phoneNumber;
  int ratingNumber;
  double distance;
  String imageUrl;
  double rating;
  String primaryCategory;
  double latitude;
  double longitude;

  StoreEntity({
    required this.id, required this.name,
    required this.email, required this.address,
    required this.ratingNumber,
    required this.introduction, required this.phoneNumber,
    required this.city, required this.imageUrl,
    required this.rating, required this.district,
    required this.longitude, required this.latitude,
    required this.distance, required this.primaryCategory
  });
}