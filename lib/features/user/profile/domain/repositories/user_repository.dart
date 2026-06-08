import 'dart:io';

import 'package:healio_app/features/user/profile/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserInfo(String userId);
  Future<UserModel> updateUserInfo({required String userId, String? fullName, String? phoneNumber, DateTime? dob, int? gender, String? avatarUrl, bool? verifyStore});
  Future<String> saveUserAvatar(String fileName, File file);
  Future<void> delteUserAvatar(String fileName);
  Future<bool> getUserSetting(String userId);
  Future<void> insertUserSetting(String userId);
  Future<void> updateUserSetting(String userId, bool isAllowed);
}