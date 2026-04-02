class ServiceEntity {
  int id, duration, categoryId, treatmentId;
  String name, description, priceType;
  double price;

  ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.priceType,
    required this.categoryId,
    required this.treatmentId,
  });
}
