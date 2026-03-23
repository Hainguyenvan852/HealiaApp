import 'package:healio_app/features/home/data/models/store_model.dart';

abstract class StoreRepository {
  Future<List<StoreModel>> getRecommendStore(String? userId, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> getNewlyStore(double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> getStoreWithDistance(double userLat, double userLng,);
  Future<StoreModel> getStoreWithId(int currentStoreId, double userLat, double userLng);
  Future<List<StoreModel>> getTrendingStore(double userLat, double userLng, double radiusKm);
}