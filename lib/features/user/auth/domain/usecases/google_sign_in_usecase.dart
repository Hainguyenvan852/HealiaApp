import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<AuthResponse> call() async {
    return await repository.signInWithGoogle();
  }
}
