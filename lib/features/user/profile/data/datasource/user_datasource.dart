import 'dart:io';

import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDatasource {
  final SupabaseClient supabase;

  UserDatasource({required this.supabase});

  Future<UserModel> getUserInfo(String userId) async {
    final jsonResult = await supabase
        .from('profiles')
        .select()
        .filter('id', 'eq', userId)
        .single();

    return UserModel.fromJson(jsonResult);
  }

  Future<UserModel> updateUserInfo({
    required String userId,
    String? fullName,
    String? phoneNumber,
    DateTime? dob,
    int? gender,
    String? avatarUrl,
    bool? verifyStore
  }) async {
    try {
      Map<String, dynamic> userData = {
        'updated_at': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };
      if (fullName != null) {
        userData.addAll({'full_name': fullName});
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userData.addAll({'phone_number': phoneNumber});
      }
      if (dob != null) {
        String dobString = DateFormat('yyyy-MM-dd').format(dob);
        userData.addAll({'date_of_birth': dobString});
      }
      if (gender != null) {
        userData.addAll({'gender': gender});
      }
      if (avatarUrl != null) {
        userData.addAll({'avatar_url': avatarUrl});
      }
      if (verifyStore != null) {
        userData.addAll({'verify_store': verifyStore});
      }

      final jsonResult = await supabase
          .from('profiles')
          .update(userData)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(jsonResult);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> uploadImageFileToStorage(String fileName, File file) async {
    try {
      await supabase.storage
          .from('user avatars')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = supabase.storage
          .from('user avatars')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<void> deleteAvaterImageFromStorage(String fileName) async {
    try {
      final isExist = await supabase.storage
          .from('user avatars')
          .exists(fileName);

      if (isExist) {
        await supabase.storage.from('user avatars').remove([fileName]);
      }
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<bool> fetchUserSetting(String userId) async {
    try {
      final jsonResult = await supabase
        .from('user_settings')
        .select(
          'id, user_id, receive_notifications',
        )
        .eq('user_id', userId)
        .single();

    return jsonResult['receive_notifications'] as bool;
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<void> insertUserSetting(String userId) async {
    try {
      await supabase
        .from('user_settings')
        .insert({
          'user_id' : userId,
          'receive_notifications' : true
        });
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<void> updateUserSetting(String userId, bool isAllowed) async {
    try {
      await supabase
        .from('user_settings')
        .update({
          'receive_notifications' : isAllowed,
          'updated_at' : DateTime.now().toIso8601String()
        })
        .eq('user_id', userId);
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }
}
