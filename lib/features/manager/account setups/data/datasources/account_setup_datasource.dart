import 'dart:typed_data';

import 'package:healio_app/core/utils/location_helper.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSetupDatasource {
  final SupabaseClient _supabase;

  AccountSetupDatasource(this._supabase);


  Future<StoreModel> addStore(Map<String, dynamic> storeData) async {
    try {
      final json = await _supabase
          .from('stores')
          .insert(storeData)
          .select()
          .single();

      final location = LocationHelper.parseSupabaseHexLocation(json['location']);

      return StoreModel.fromJson2(json, location);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addStaff(Map<String, dynamic> staffData) async {
    try {
      await _supabase.from('members').insert(staffData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> categoryData) async {
    try {
      final json = await _supabase
          .from('categories')
          .insert(categoryData)
          .select()
          .single();
      return CategoryModel.fromJson(json);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addService(Map<String, dynamic> serviceData) async {
    try {
      await _supabase.from('services').insert(serviceData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addStoreWorkingHour(Map<String, dynamic> workingHourData) async {
    try {
      await _supabase.from('store_working_hours').insert(workingHourData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
