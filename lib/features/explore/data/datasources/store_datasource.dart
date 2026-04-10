import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';
import 'package:healio_app/features/home/data/models/favorite_store_model.dart';
import 'package:healio_app/features/home/data/models/review_model.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';
import 'package:healio_app/features/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreDatasource {
  final SupabaseClient _supabase;

  StoreDatasource(this._supabase);

  Future<List<StoreModel>> fetchRecommendStore(
    String? userId,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_smart_recommendations',
        params: {
          'current_user_id': userId,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchNewlyStore(
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_newly_store',
        params: {
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreWithDistance(
    double userLat,
    double userLng,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_with_distance',
        params: {'user_lat': userLat, 'user_lng': userLng},
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchTrendingStore(
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_trending_store',
        params: {
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<StoreModel> fetchStoreWithId(
    int currentStoreId,
    double userLat,
    double userLng,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_with_id',
        params: {
          'user_lat': userLat,
          'user_lng': userLng,
          'current_store_id': currentStoreId,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return StoreModel.fromJson(stores.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreAroundLocation(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_around_location',
        params: {'lat': lat, 'lng': lng, 'radius_km': radiusKm},
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByAllFilter(
    String category,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final day = date.weekday + 1;
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
        'get_store_by_all_filter',
        params: {
          'filter': category,
          'day': day,
          'input_start_time': start,
          'input_end_time': end,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByFilter(
    String filter,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_by_filter',
        params: {
          'filter': filter,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByCategory(
    String category,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_by_category',
        params: {
          'category': category,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByDateTime(
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
        'get_store_by_date_time',
        params: {
          'day': date.weekday + 1,
          'input_start_time': start,
          'input_end_time': end,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByDate(
    DateTime date,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final response = await _supabase.rpc(
        'get_store_by_date',
        params: {
          'day': date.weekday + 1,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByTime(
    TimeOfDay startTime,
    TimeOfDay endTime,
    double userLat,
    double userLng,
    double radiusKm,
  ) async {
    try {
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
        'get_store_by_time',
        params: {
          'input_start_time': start,
          'input_end_time': end,
          'user_lat': userLat,
          'user_lng': userLng,
          'radius_km': radiusKm,
        },
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<CategoryModel>> fetchCategorys(int storeId) async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*')
          .eq('store_id', storeId);

      return response.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ServiceModel>> fetchServices(int categoryId) async {
    try {
      final response = await _supabase
          .from('services')
          .select('*')
          .eq('category_id', categoryId);

      return response.map((item) => ServiceModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreWorkingHourModel>> fetchOpeningHours(int storeId) async {
    try {
      final response = await _supabase
          .from('store_working_hours')
          .select('*')
          .eq('store_id', storeId);

      return response
          .map((item) => StoreWorkingHourModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ReviewModel>> fetchReviews(int storeId) async {
    try {
      final response = await _supabase
          .rpc('get_reviews_with_customer_info', params: {
            'c_store_id' : storeId
          });

      final reviews = List<Map<String, dynamic>>.from(response);

      return reviews.map((item) => ReviewModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<FavoriteStoreModel?> fetchFavoriteStore(String userId, int storeId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('*')
          .eq('user_id', userId)
          .eq('store_id', storeId);

      if(response.isEmpty){
        return null;
      } else{
        return FavoriteStoreModel.fromJson(response.first);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<FavoriteStoreModel>> fetchFavoriteStores(String userId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('*')
          .eq('user_id', userId);

      return response.map((item) => FavoriteStoreModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> insertFavoriteStore(String userId, int storeId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'store_id': storeId,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteFavoriteStore(String userId, int storeId) async {
    try {
      await _supabase.from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('store_id', storeId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<TeamMemberModel>> fetchTeamMembersByService(int serviceId) async {
    try {
      final result = await _supabase.rpc('get_team_member_by_service', params: {
        'c_service_id' : serviceId
      });
      final members = List<Map<String, dynamic>>.from(result);

      return members.map((item) => TeamMemberModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
