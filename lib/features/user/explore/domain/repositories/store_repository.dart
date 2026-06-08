import 'package:flutter/material.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/favorite_store_model.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';

abstract class StoreRepository {
  Future<List<StoreModel>> getRecommendStore(String? userId);
  Future<List<StoreModel>> getNewlyStore();
  Future<List<StoreModel>> getStoreWithDistance();
  Future<StoreModel> getStoreWithId(int currentStoreId);
  Future<List<StoreModel>> getTrendingStore();
  Future<List<StoreModel>> searchByAllFilter(
    String filter,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchByFilter(
    String filter,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchByCategory(
    String category,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchByDateTime(
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchByDate(
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchStoreAroundLocation(
    double lat,
    double lng,
    double radiusKm,
  );
  Future<List<StoreModel>> searchByTime(
    TimeOfDay startTime,
    TimeOfDay endTime,
    double userLat,
    double userLng,
    double radiusKm,
  );
  Future<List<CategoryModel>> getCategoryList(int storeId);
  Future<List<ServiceModel>> getServiceList(int categoryId);
  Future<List<ReviewModel>> getReviewList(int storeId);
  Future<List<StoreWorkingHourModel>> getOpeningHourList(int storeId);
  Future<FavoriteStoreModel?> getFavoriteStore(String userId, int storeId);
  Future<List<FavoriteStoreModel>> getFavoriteStores(String userId);
  Future<void> insertFavoriteStores(String userId, int storeId);
  Future<void> deleteFavoriteStores(String userId, int storeId);
  Future<List<StaffModel>> getTeamMemberByService(int serviceId);
  Future<List<ImageModel>> getStoreImages(int storeId);
}
