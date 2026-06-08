import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class DeleteUserAvatarUsecase {
  final UserRepository repository;

  DeleteUserAvatarUsecase(this.repository);

  Future<void> call(String filePath){
    return repository.delteUserAvatar(filePath);
  }
}