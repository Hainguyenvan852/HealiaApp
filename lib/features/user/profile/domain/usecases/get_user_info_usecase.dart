import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class GetUserInfoUseCase {
  final UserRepository repository;

  GetUserInfoUseCase(this.repository);

  Future<UserModel> call(String userId) async{
    return await repository.getUserInfo(userId);
  }
}