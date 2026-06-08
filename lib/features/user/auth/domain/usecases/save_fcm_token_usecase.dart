import '../repositories/auth_repository.dart';

class SaveFcmTokenUseCase {
  final AuthRepository repository;

  SaveFcmTokenUseCase(this.repository);

  Future<void> call(String userId) async {
    return await repository.saveFcmToken(userId);
  }
}