class StoreEntity {
  int id;
  String name;
  String email;
  String address;
  String district;
  String province;
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
    required this.province, required this.imageUrl,
    required this.rating, required this.district,
    required this.longitude, required this.latitude,
    required this.distance, required this.primaryCategory
  });
}