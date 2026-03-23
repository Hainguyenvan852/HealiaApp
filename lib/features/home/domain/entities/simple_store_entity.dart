class SimpleStoreEntity {
  String id;
  String name;
  String address;
  String? district;
  String? city;
  int bookingNumber;
  double distance;
  String? imageUrl;
  double rating;
  String primaryCategory;

  SimpleStoreEntity({
    required this.id, required this.name,
    required this.rating, required this.distance,
    required this.bookingNumber, this.district,
    this.city, this.imageUrl,
    required this.address, required this.primaryCategory
  });
}