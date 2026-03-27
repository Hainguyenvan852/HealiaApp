import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreDatasource {
  final SupabaseClient _supabase;

  StoreDatasource(this._supabase);

  Future<List<StoreModel>> fetchRecommendStore(String? userId, double userLat, double userLng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_smart_recommendations',
          params: {
            'current_user_id' : userId,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchNewlyStore(double userLat, double userLng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_newly_store',
          params: {
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreWithDistance(double userLat, double userLng) async{
    try{
      final response = await _supabase.rpc(
          'get_store_with_distance',
          params: {
            'user_lat' : userLat,
            'user_lng' : userLng,
          }
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchTrendingStore(double userLat, double userLng, double radiusKm) async{
    try{
    final response = await _supabase.rpc(
        'get_trending_store',
        params: {
          'user_lat' : userLat,
          'user_lng' : userLng,
          'radius_km' : radiusKm
        }
    );
    final stores = List<Map<String, dynamic>>.from(response);

    return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<StoreModel> fetchStoreWithId(int currentStoreId, double userLat, double userLng) async{
    try{
      final response = await _supabase.rpc(
          'get_store_with_id',
          params: {
            'user_lat' : userLat,
            'user_lng' : userLng,
            'current_store_id' : currentStoreId
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return StoreModel.fromJson(stores.first);
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreAroundLocation(double lat, double lng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_store_around_location',
          params: {
            'lat' : lat,
            'lng' : lng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByAllFilter(String category, TimeOfDay startTime, TimeOfDay endTime, DateTime date, double userLat, double userLng, double radiusKm) async{
    try{
      final day = date.weekday + 1;
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
          'get_store_by_all_filter',
          params: {
            'filter' : category,
            'day' : day,
            'input_start_time' : start,
            'input_end_time' : end,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByFilter(String filter, double userLat, double userLng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_store_by_filter',
          params: {
            'filter' : filter,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByCategory(String category, double userLat, double userLng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_store_by_category',
          params: {
            'category' : category,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByDateTime(DateTime date, TimeOfDay startTime, TimeOfDay endTime, double userLat, double userLng, double radiusKm) async{
    try{
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
          'get_store_by_date_time',
          params: {
            'day' : date.weekday + 1,
            'input_start_time' : start,
            'input_end_time' : end,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByDate(DateTime date, double userLat, double userLng, double radiusKm) async{
    try{
      final response = await _supabase.rpc(
          'get_store_by_date',
          params: {
            'day' : date.weekday + 1,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreByTime(TimeOfDay startTime, TimeOfDay endTime, double userLat, double userLng, double radiusKm) async{
    try{
      final String start = '${startTime.hour}:${startTime.minute}';
      final String end = '${endTime.hour}:${endTime.minute}';

      final response = await _supabase.rpc(
          'get_store_by_time',
          params: {
            'input_start_time' : start,
            'input_end_time' : end,
            'user_lat' : userLat,
            'user_lng' : userLng,
            'radius_km' : radiusKm
          }
      );

      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch(e){
      throw Exception(e.toString());
    }
  }
}