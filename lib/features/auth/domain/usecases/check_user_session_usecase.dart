import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class CheckUserSessionUseCase {
  final AuthRepository repository;

  CheckUserSessionUseCase(this.repository);

  Session? call() {
    return repository.checkUserSession();
  }
}