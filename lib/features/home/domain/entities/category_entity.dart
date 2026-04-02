import 'package:healio_app/features/home/data/models/service_model.dart';

class CategoryEntity {
  int id, storeId;
  String name, description;
  List<ServiceModel>? services;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.storeId,
    this.services
  });
}
