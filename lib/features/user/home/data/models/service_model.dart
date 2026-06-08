import 'package:healio_app/features/user/home/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.duration,
    required super.price,
    required super.categoryId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json){
    return ServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      duration: json['duration_minutes'] as int,
      price: json['price'] as double,
      categoryId: json['category_id'] as int,
    );
  }
}
