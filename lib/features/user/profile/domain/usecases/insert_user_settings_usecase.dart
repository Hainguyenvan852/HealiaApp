import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class InsertUserSettingsUseCase {
  final UserRepository repository;

  InsertUserSettingsUseCase(this.repository);

  Future<void> call(String userId){
    return repository.insertUserSetting(userId);
  }
}