import 'package:healio_app/features/user/home/domain/entities/favorite_store_entiy.dart';

class FavoriteStoreModel extends FavoriteStoreEntiy{
  FavoriteStoreModel({required super.id, required super.storeId, required super.userId});

  factory FavoriteStoreModel.fromJson(Map<String, dynamic> json){
    return FavoriteStoreModel(
      id: json['id'] as int,
      storeId: json['store_id'] as int,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'store_id': storeId,
    'user_id': userId
  };
}