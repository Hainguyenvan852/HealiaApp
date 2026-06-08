import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<AuthResponse> call(String email, String password) async{
    return await repository.signIn(email, password);
  }
}