import 'package:healio_app/features/home/data/datasources/store_datasource.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class IStoreRepository extends StoreRepository{

  final StoreDatasource storeDatasource;

  IStoreRepository(this.storeDatasource);

  @override
  Future<List<StoreModel>> getNewlyStore(double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchNewlyStore(userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> getRecommendStore(String? userId, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchRecommendStore(userId, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> getStoreWithDistance(double userLat, double userLng) {
    return storeDatasource.fetchStoreWithDistance(userLat, userLng);
  }

  @override
  Future<StoreModel> getStoreWithId(int currentStoreId, double userLat, double userLng) {
    return storeDatasource.fetchStoreWithId(currentStoreId, userLat, userLng);
  }

  @override
  Future<List<StoreModel>> getTrendingStore(double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchTrendingStore(userLat, userLng, radiusKm);
  }
}