import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.storeId,
    super.services,
    required super.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      storeId: json['store_id'] as int,
      services: json['services'] != null
          ? (json['services'] as List)
                .map((e) => ServiceModel.fromJson(e))
                .toList()
          : null,
      isActive: json['is_active'] as bool,
    );
  }
}
