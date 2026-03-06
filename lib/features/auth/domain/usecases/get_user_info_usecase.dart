import 'package:healio_app/features/auth/data/models/user_model.dart';

import '../repositories/auth_repository.dart';

class GetUserInfoUseCase {
  final AuthRepository repository;

  GetUserInfoUseCase(this.repository);

  Future<UserModel> call(String userId) async{
    return await repository.getUserInfo(userId);
  }
}