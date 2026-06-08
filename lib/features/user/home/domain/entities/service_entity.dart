class ServiceEntity {
  int id, duration, categoryId;
  String name, description;
  double price;

  ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.categoryId,
  });
}
