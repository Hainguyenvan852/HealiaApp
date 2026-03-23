import 'package:healio_app/features/home/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity{
  ImageModel({required super.id, required super.storeId, required super.isPrimary, required super.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json){
    return ImageModel(
      id: json['id'] as int,
      storeId: json['store_id'] as String,
      isPrimary: json['is_primary'] as bool,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'is_primary': isPrimary,
    'image_url': imageUrl,
  };
}