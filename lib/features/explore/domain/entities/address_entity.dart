class AddressEntity {
  int id;
  String name;
  String address;
  String? district;
  String province;
  String? commune;
  double lat;
  double lng;

  AddressEntity(
      {required this.id, required this.name, required this.address, this.district, required this.province, this.commune, required this.lat, required this.lng});

}