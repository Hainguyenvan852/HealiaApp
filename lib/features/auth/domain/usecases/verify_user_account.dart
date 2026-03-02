import 'package:gotrue/gotrue.dart';

import '../repositories/auth_repository.dart';

class VerifyUserAccount {
  final AuthRepository repository;

  VerifyUserAccount(this.repository);

  Future<AuthResponse> call(String email, String token) async {
    return await repository.verifyUserAccount(email, token);
  }
}