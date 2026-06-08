import 'package:healio_app/features/user/home/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity{
  ImageModel({required super.id, required super.storeId, required super.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json){
    return ImageModel(
      id: json['id'] as int,
      storeId: json['store_id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'image_url': imageUrl,
  };
}