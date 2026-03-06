class StoreEntity {
  String id;
  String name;
  String email;
  String address;
  String ward;
  String district;
  String city;
  String country;
  String introduction;
  String managerId;
  String phoneNumber;
  String latitude;
  String longitude;
  bool isActive;

  StoreEntity({
    required this.id, required this.name,
    required this.email, required this.address,
    required this.ward, required this.longitude,
    required this.district, required this.city,
    required this.country, required this.introduction,
    required this.managerId, required this.phoneNumber,
    required this.isActive, required this.latitude,
  });
}