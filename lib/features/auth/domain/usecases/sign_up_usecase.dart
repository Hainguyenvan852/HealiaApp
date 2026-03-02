import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<AuthResponse> call(String email, String password, String userName) async{
    return await repository.signUp(email, password, userName);
  }
}