import 'dart:io';

import 'package:healio_app/features/user/profile/domain/repositories/user_repository.dart';

class SaveUserAvatarUseCase {
  final UserRepository userRepository;

  SaveUserAvatarUseCase(this.userRepository);

  Future<String> call(String fileName, File file){
    return userRepository.saveUserAvatar(fileName, file);
  }
}