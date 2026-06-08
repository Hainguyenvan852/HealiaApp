import 'dart:io';

import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/data/datasource/user_datasource.dart';
import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class IUserRepository extends UserRepository{

  final UserDatasource userDatasource;

  IUserRepository({required this.userDatasource});

  @override
  Future<UserModel> getUserInfo(String userId) {
    return userDatasource.getUserInfo(userId);
  }
  
  @override
  Future<UserModel> updateUserInfo({required String userId, String? fullName, String? phoneNumber, DateTime? dob, int? gender, String? avatarUrl, bool? verifyStore}) {
    return userDatasource.updateUserInfo(userId: userId, fullName: fullName, phoneNumber: phoneNumber, dob: dob, gender: gender, avatarUrl: avatarUrl, verifyStore: verifyStore);
  }

  @override
  Future<String> saveUserAvatar(String fileName, File file) {
    return userDatasource.uploadImageFileToStorage(fileName, file);
  }
  
  @override
  Future<void> delteUserAvatar(String fileName) {
    return userDatasource.deleteAvaterImageFromStorage(fileName);
  }
  
  @override
  Future<bool> getUserSetting(String userId) {
    return userDatasource.fetchUserSetting(userId);
  }
  
  @override
  Future<void> insertUserSetting(String userId) async {
    userDatasource.insertUserSetting(userId);
  }
  
  @override
  Future<void> updateUserSetting(String userId, bool isAllowed) async{
    userDatasource.updateUserSetting(userId, isAllowed);
  }
}