import 'package:gotrue/gotrue.dart';

import '../repositories/auth_repository.dart';

class CheckCurrentUserUseCase {
  final AuthRepository repository;

  CheckCurrentUserUseCase(this.repository);

  User? call() {
    return repository.checkCurrentUser();
  }
}