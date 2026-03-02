import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationToken {
  final AuthRepository repository;

  ResendVerificationToken(this.repository);

  Future<ResendResponse> call(String email) async{
    return await repository.resendVerificationToken(email);
  }
}