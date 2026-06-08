import 'package:healio_app/features/user/explore/domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel({
    required super.id,
    required super.name,
    required super.email,
    required super.address,
    required super.district,
    required super.primaryCategory,
    required super.province,
    required super.introduction,
    required super.phoneNumber,
    required super.ratingNumber,
    required super.primaryImageUrl,
    required super.rating,
    required super.longitude,
    required super.latitude,
    required super.managerId,
    super.distance,
    required super.storeType,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> coordinates = json['location']['coordinates'];
    final longitude = (coordinates[0] as num).toDouble();
    final latitude = (coordinates[1] as num).toDouble();

    return StoreModel(
      id: json['store_id'] as int,
      name: json['store_name'] as String,
      address: json['address'] as String,
      district: json['district'] as String? ?? '',
      province: json['province'] as String,
      introduction: json['introduction'] as String? ?? '',
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      ratingNumber: json['rating_number'] as int? ?? 0,
      primaryImageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num).toDouble(),
      primaryCategory: json['primary_category'] as String,
      longitude: longitude,
      latitude: latitude,
      managerId: json['manager_id'] as String? ?? '',
      storeType: json['store_type'] as String? ?? '',
    );
  }

  factory StoreModel.fromJson2(
    Map<String, dynamic> json,
    Map<String, dynamic> location,
  ) {
    return StoreModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      district: json['district'] as String? ?? '',
      province: json['province'] as String,
      introduction: json['introduction'] as String? ?? '',
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      ratingNumber: json['rating_number'] as int? ?? 0,
      primaryImageUrl: json['image_url'] as String? ?? '',
      rating: (json['rating'] as num).toDouble(),
      primaryCategory: json['primary_category'] as String,
      longitude: location['lng'],
      latitude: location['lat'],
      managerId: json['manager_id'] as String,
      storeType: json['store_type'] as String,
    );
  }

  StoreModel updateDistance(double distance) => StoreModel(
    id: id,
    name: name,
    email: email,
    address: address,
    district: district,
    primaryCategory: primaryCategory,
    province: province,
    introduction: introduction,
    phoneNumber: phoneNumber,
    ratingNumber: ratingNumber,
    primaryImageUrl: primaryImageUrl,
    rating: rating,
    longitude: longitude,
    latitude: latitude,
    distance: distance,
    managerId: managerId,
    storeType: storeType,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'address': address,
    'phone_number': phoneNumber,
    'district': district,
    'province': province,
    'introduction': introduction,
    'image_url': primaryImageUrl,
    'rating': rating,
    'manager_id': managerId,
    'store_type': storeType,
  };

  StoreModel copyWith({
    int? id,
    String? name,
    String? email,
    String? address,
    String? district,
    String? primaryCategory,
    String? province,
    String? introduction,
    String? phoneNumber,
    int? ratingNumber,
    String? primaryImageUrl,
    double? rating,
    double? longitude,
    double? latitude,
    String? managerId,
    double? distance,
    String? storeType,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      district: district ?? this.district,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      province: province ?? this.province,
      introduction: introduction ?? this.introduction,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      ratingNumber: ratingNumber ?? this.ratingNumber,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      rating: rating ?? this.rating,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      managerId: managerId ?? this.managerId,
      distance: distance ?? this.distance,
      storeType: storeType ?? this.storeType,
    );
  }
}
