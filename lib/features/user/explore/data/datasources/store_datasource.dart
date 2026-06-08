import 'package:flutter/material.dart';
import 'package:healio_app/core/utils/location_helper.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/favorite_store_model.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class StoreDatasource {
  final SupabaseClient _supabase;

  StoreDatasource(this._supabase);

  Future<List<StoreModel>> fetchRecommendStore(String? userId) async {
    try {
      final response = await _supabase.rpc(
        'get_smart_recommendations',
        params: {'current_user_id': userId},
      );
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchNewlyStore() async {
    try {
      final response = await _supabase.rpc('get_newly_store');
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchStoreWithDistance() async {
    try {
      final response = await _supabase.rpc('get_store_with_distance');
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StoreModel>> fetchTrendingStore() async {
    try {
      final response = await _supabase.rpc('get_trending_store');
      final stores = List<Map<String, dynamic>>.from(response);

      return stores.map((store) => StoreModel.fromJson(store)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<StoreModel> fetchStoreWithId(int currentStoreId) async {
    try {
      final response = await _supabase.rpc(
        'get_store_with_id',
        params: {'current_store_id': currentStoreId},
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
          .eq('store_id', storeId)
          .eq('is_active', true);

      return response.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<CategoryModel>> fetchCategoriesWithServices(int storeId) async {
    try {
      final response = await _supabase
          .from('categories')
          .select('*, services(*)')
          .eq('services.is_active', true)
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('id', ascending: true);

      return response.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateCategory(
    int categoryId,
    String name,
    String description,
  ) async {
    try {
      await _supabase
          .from('categories')
          .update({'name': name, 'description': description})
          .eq('id', categoryId);
    } catch (e) {
      throw Exception('Lỗi cập nhật danh mục: $e');
    }
  }

  Future<void> addCategory({
    required String name,
    String? description,
    required int storeId,
  }) async {
    try {
      await _supabase.from('categories').insert({
        'name': name,
        'description': description,
        'store_id': storeId,
      });
    } catch (e) {
      throw Exception('Lỗi cập nhật danh mục: $e');
    }
  }

  Future<void> deleteCategory({required int categoryId}) async {
    try {
      await _supabase
          .from('categories')
          .update({'is_active': false})
          .eq('id', categoryId);
    } catch (e) {
      throw Exception('Lỗi xóa danh mục: $e');
    }
  }

  Future<void> deleteService(int serviceId) async {
    try {
      await _supabase
          .from('services')
          .update({'is_active': false})
          .eq('id', serviceId);
    } catch (e) {
      throw Exception('Lỗi xóa dịch vụ: $e');
    }
  }

  Future<void> addService({
    required String name,
    required String description,
    required int durationMinutes,
    required double price,
    required int categoryId,
  }) async {
    try {
      await _supabase.from('services').insert({
        'name': name,
        'description': description,
        'duration_minutes': durationMinutes,
        'price': price,
        'category_id': categoryId,
      });
    } catch (e) {
      throw Exception('Lỗi thêm dịch vụ: $e');
    }
  }

  Future<List<ServiceModel>> fetchServices(int categoryId) async {
    try {
      final response = await _supabase
          .from('services')
          .select('*')
          .eq('is_active', true)
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
          .eq('store_id', storeId)
          .order('day_of_week', ascending: true);

      return response
          .map((item) => StoreWorkingHourModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ReviewModel>> fetchReviews(int storeId) async {
    try {
      final response = await _supabase.rpc(
        'get_reviews_with_customer_info',
        params: {'c_store_id': storeId},
      );

      final reviews = List<Map<String, dynamic>>.from(response);

      return reviews.map((item) => ReviewModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<FavoriteStoreModel?> fetchFavoriteStore(
    String userId,
    int storeId,
  ) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('*')
          .eq('user_id', userId)
          .eq('store_id', storeId);

      if (response.isEmpty) {
        return null;
      } else {
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
      await _supabase.from('favorites').upsert({
        'user_id': userId,
        'store_id': storeId,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteFavoriteStore(String userId, int storeId) async {
    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('store_id', storeId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Bỏ hàm này
  Future<List<StaffModel>> fetchTeamMembersByService(int serviceId) async {
    try {
      final result = await _supabase.rpc(
        'get_team_member_by_service',
        params: {'c_service_id': serviceId},
      );
      final members = List<Map<String, dynamic>>.from(result);

      return members.map((item) => StaffModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ImageModel>> fetchStoreImages(int storeId) async {
    try {
      final response = await _supabase
          .from('store_images')
          .select()
          .eq('store_id', storeId);

      return response.map((item) => ImageModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StaffModel>> fetchTeamMembersByStore(int storeId) async {
    try {
      final response = await _supabase
          .from('members')
          .select()
          .eq('store_id', storeId)
          .order('id', ascending: true);

      return response.map((item) => StaffModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addStaff({
    required int storeId,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? jobTitle,
    DateTime? birthDay,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
    String? avatarUrl,
  }) async {
    try {
      await _supabase.from('members').insert({
        'store_id': storeId,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'job_title': jobTitle,
        'birth_day': birthDay?.toIso8601String(),
        'start_date': startDate.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'notes': notes,
        'avatar_url': avatarUrl,
        'is_active': true,
      });
    } catch (e) {
      throw Exception('Lỗi thêm nhân viên: $e');
    }
  }

  Future<void> updateStaff({
    required int staffId,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? jobTitle,
    DateTime? birthDay,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
    String? avatarUrl,
  }) async {
    try {
      await _supabase
          .from('members')
          .update({
            'full_name': fullName,
            'email': email,
            'phone_number': phoneNumber,
            'job_title': jobTitle,
            'birth_day': birthDay?.toIso8601String(),
            'start_date': startDate.toIso8601String(),
            'end_date': endDate?.toIso8601String(),
            'notes': notes,
            'avatar_url': avatarUrl,
          })
          .eq('id', staffId);
    } catch (e) {
      throw Exception('Lỗi cập nhật nhân viên: $e');
    }
  }

  Future<void> deleteStaff({required int staffId}) async {
    try {
      await _supabase
          .from('members')
          .update({
            'is_active': false,
            'end_date': DateTime.now().toIso8601String(),
          })
          .eq('id', staffId);
    } catch (e) {
      throw Exception('Lỗi xóa nhân viên: $e');
    }
  }

  Future<String> uploadStaffAvatar(String fileName, File file) async {
    try {
      await _supabase.storage
          .from('user avatars')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = _supabase.storage
          .from('user avatars')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<StoreModel> getStoreByMangerId(String managerId) async {
    try {
      final response = await _supabase
          .from('stores')
          .select()
          .eq('manager_id', managerId)
          .single();

      final location = LocationHelper.parseSupabaseHexLocation(
        response['location'],
      );

      return StoreModel.fromJson2(response, location);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateStoreInfo({
    required int storeId,
    required String name,
    required String email,
    required String phoneNumber,
    required String introduction,
  }) async {
    try {
      await _supabase
          .from('stores')
          .update({
            'name': name,
            'email': email,
            'phone_number': phoneNumber,
            'introduction': introduction,
          })
          .eq('id', storeId);
    } catch (e) {
      throw Exception('Lỗi cập nhật thông tin cửa hàng: $e');
    }
  }

  Future<void> updateStoreLocation({
    required int storeId,
    required String address,
    required String province,
  }) async {
    try {
      await _supabase
          .from('stores')
          .update({'address': address, 'province': province})
          .eq('id', storeId);
    } catch (e) {
      throw Exception('Lỗi cập nhật địa chỉ cửa hàng: $e');
    }
  }
}
