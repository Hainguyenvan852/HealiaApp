import 'package:gotrue/gotrue.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationTokenUseCase {
  final AuthRepository repository;

  ResendVerificationTokenUseCase(this.repository);

  Future<ResendResponse> call(String email) async{
    return await repository.resendVerificationToken(email);
  }
}