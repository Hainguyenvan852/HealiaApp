import 'package:flutter/src/material/time.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/favorite_store_model.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';

class IStoreRepository extends StoreRepository {
  final StoreDatasource storeDatasource;

  IStoreRepository(this.storeDatasource);

  @override
  Future<List<StoreModel>> getNewlyStore() {
    return storeDatasource.fetchNewlyStore();
  }

  @override
  Future<List<StoreModel>> getRecommendStore(String? userId) {
    return storeDatasource.fetchRecommendStore(userId);
  }

  @override
  Future<List<StoreModel>> getStoreWithDistance() {
    return storeDatasource.fetchStoreWithDistance();
  }

  @override
  Future<StoreModel> getStoreWithId(int currentStoreId) {
    return storeDatasource.fetchStoreWithId(currentStoreId);
  }

  @override
  Future<List<StoreModel>> getTrendingStore() {
    return storeDatasource.fetchTrendingStore();
  }

  @override
  Future<List<StoreModel>> searchByAllFilter(
    String filter,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByAllFilter(
      filter,
      startTime,
      endTime,
      date,
      userLat,
      userLng,
      radiusKm,
    );
  }

  @override
  Future<List<StoreModel>> searchByCategory(
    String category,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByCategory(
      category,
      userLat,
      userLng,
      radiusKm,
    );
  }

  @override
  Future<List<StoreModel>> searchByDate(
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByDate(date, userLat, userLng, radiusKm);
  }

  @override
  Future<List<StoreModel>> searchByDateTime(
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByDateTime(
      date,
      startTime,
      endTime,
      userLat,
      userLng,
      radiusKm,
    );
  }

  @override
  Future<List<StoreModel>> searchByFilter(
    String filter,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByFilter(
      filter,
      userLat,
      userLng,
      radiusKm,
    );
  }

  @override
  Future<List<StoreModel>> searchByTime(
    TimeOfDay startTime,
    TimeOfDay endTime,
    double userLat,
    double userLng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreByTime(
      startTime,
      endTime,
      userLat,
      userLng,
      radiusKm,
    );
  }

  @override
  Future<List<StoreModel>> searchStoreAroundLocation(
    double lat,
    double lng,
    double radiusKm,
  ) {
    return storeDatasource.fetchStoreAroundLocation(lat, lng, radiusKm);
  }

  @override
  Future<List<CategoryModel>> getCategoryList(int storeId) {
    return storeDatasource.fetchCategorys(storeId);
  }

  @override
  Future<List<StoreWorkingHourModel>> getOpeningHourList(int storeId) {
    return storeDatasource.fetchOpeningHours(storeId);
  }

  @override
  Future<List<ReviewModel>> getReviewList(int storeId) {
    return storeDatasource.fetchReviews(storeId);
  }

  @override
  Future<List<ServiceModel>> getServiceList(int categoryId) {
    return storeDatasource.fetchServices(categoryId);
  }

  @override
  Future<void> deleteFavoriteStores(String userId, int storeId) async {
    storeDatasource.deleteFavoriteStore(userId, storeId);
  }

  @override
  Future<List<FavoriteStoreModel>> getFavoriteStores(String userId) {
    return storeDatasource.fetchFavoriteStores(userId);
  }

  @override
  Future<void> insertFavoriteStores(String userId, int storeId) async {
    storeDatasource.insertFavoriteStore(userId, storeId);
  }

  @override
  Future<FavoriteStoreModel?> getFavoriteStore(String userId, int storeId) {
    return storeDatasource.fetchFavoriteStore(userId, storeId);
  }

  @override
  Future<List<StaffModel>> getTeamMemberByService(int serviceId) {
    return storeDatasource.fetchTeamMembersByService(serviceId);
  }

  @override
  Future<List<ImageModel>> getStoreImages(int storeId) {
    return storeDatasource.fetchStoreImages(storeId);
  }
}
