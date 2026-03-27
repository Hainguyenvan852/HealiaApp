import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';

abstract class StoreRepository {
  Future<List<StoreModel>> getRecommendStore(String? userId, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> getNewlyStore(double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> getStoreWithDistance(double userLat, double userLng,);
  Future<StoreModel> getStoreWithId(int currentStoreId, double userLat, double userLng);
  Future<List<StoreModel>> getTrendingStore(double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchByAllFilter(String filter, TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchByFilter(String filter, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchByCategory(String category, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchByDateTime(TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchByDate(DateTime date, double userLat, double userLng, double radiusKm);
  Future<List<StoreModel>> searchStoreAroundLocation(double lat, double lng, double radiusKm);
  Future<List<StoreModel>> searchByTime(TimeOfDay startTime, TimeOfDay endTime, double userLat, double userLng, double radiusKm);

}