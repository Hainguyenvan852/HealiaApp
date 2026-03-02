import '../repositories/auth_repository.dart';

class FacebookSignInUseCase {
  final AuthRepository repository;

  FacebookSignInUseCase(this.repository);

  Future<bool> call() async{
    return await repository.signInWithFacebook();
  }
}