import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class UpdateUserInfoUsecase {
  final UserRepository repository;

  UpdateUserInfoUsecase(this.repository);

  Future<UserModel> call({required String userId, String? fullName, String? phoneNumber, DateTime? dob, int? gender, String? avatarUrl, bool? verifyStore}) async{
    return await repository.updateUserInfo(userId: userId, fullName: fullName, phoneNumber: phoneNumber, dob: dob, gender: gender, avatarUrl: avatarUrl, verifyStore: verifyStore);
  }
}