import 'package:flutter/src/material/time.dart';
import 'package:healio_app/features/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

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

  @override
  Future<List<StoreModel>> searchByAllFilter(String filter, TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByAllFilter(filter, startTime, endTime, date, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByCategory(String category, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByCategory(category, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByDate(DateTime date, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByDate(date, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByDateTime(TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByDateTime(date, startTime, endTime, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByFilter(String filter, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByFilter(filter, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByTime(TimeOfDay startTime, TimeOfDay endTime, double userLat, double userLng, double radiusKm) {
    return storeDatasource.fetchStoreByTime(startTime, endTime, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchStoreAroundLocation(double lat, double lng, double radiusKm) {
    return storeDatasource.fetchStoreAroundLocation(lat, lng, radiusKm);
  }
}