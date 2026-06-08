class StoreEntity {
  int id;
  String name;
  String email;
  String address;
  String? district;
  String province;
  String introduction;
  String phoneNumber;
  int ratingNumber;
  String primaryImageUrl;
  double rating;
  String primaryCategory;
  double latitude;
  double longitude;
  double? distance;
  String managerId;
  String storeType;

  StoreEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.ratingNumber,
    required this.primaryCategory,
    required this.introduction,
    required this.phoneNumber,
    required this.province,
    required this.primaryImageUrl,
    required this.rating,
    this.district,
    required this.longitude,
    required this.latitude,
    required this.managerId,
    required this.storeType,
    this.distance,
  });
}
