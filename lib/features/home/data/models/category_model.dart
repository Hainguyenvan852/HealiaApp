import 'package:healio_app/features/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.storeId,
    super.services
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      storeId: json['store_id'] as int,
    );
  }
}
