import 'package:healio_app/features/home/data/models/store_model.dart';
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
}