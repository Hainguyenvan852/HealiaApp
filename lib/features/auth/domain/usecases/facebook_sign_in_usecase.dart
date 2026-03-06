import 'package:gotrue/gotrue.dart';

import '../repositories/auth_repository.dart';

class FacebookSignInUseCase {
  final AuthRepository repository;

  FacebookSignInUseCase(this.repository);

  Future<AuthResponse> call() async{
    return await repository.signInWithFacebook();
  }
}