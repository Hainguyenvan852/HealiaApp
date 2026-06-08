import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class UpdateUserSettingsUseCase {
  final UserRepository repository;

  UpdateUserSettingsUseCase(this.repository);

  Future<void> call(String userId, bool isAllowed){
    return repository.updateUserSetting(userId, isAllowed);
  }
}