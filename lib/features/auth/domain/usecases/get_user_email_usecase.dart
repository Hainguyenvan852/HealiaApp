import '../repositories/auth_repository.dart';

class GetUserEmailUseCase {
  final AuthRepository repository;

  GetUserEmailUseCase(this.repository);

  String? call() {
    return repository.getCurrentUserEmail();
  }
}