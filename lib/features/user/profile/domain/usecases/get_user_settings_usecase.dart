import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class GetUserSettingsUseCase {
  final UserRepository repository;

  GetUserSettingsUseCase(this.repository);

  Future<bool> call(String userId){
    return repository.getUserSetting(userId);
  }
}