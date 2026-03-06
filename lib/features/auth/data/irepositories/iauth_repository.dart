
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:healio_app/features/auth/data/models/user_model.dart';
import 'package:healio_app/features/auth/domain/repositories/auth_repository.dart';

class IAuthRepository implements AuthRepository{

  final AuthDataSource _authDatasource;

  IAuthRepository(this._authDatasource);

  @override
  Session? checkUserSession() {
    return _authDatasource.checkUserSession();
  }

  @override
  String? getCurrentUserEmail() {
    return _authDatasource.getCurrentUserEmail();
  }

  @override
  Future<bool> isEmailExist(String email) {
    return _authDatasource.isEmailExist(email);
  }

  @override
  Future<void> resetPassword(String email) {
    return _authDatasource.resetPassword(email);
  }

  @override
  Future<AuthResponse> signIn(String email, String password) {
    return _authDatasource.signInWithEmailPassword(email, password);
  }

  @override
  Future<AuthResponse> signInWithFacebook() {
    return _authDatasource.signInWithFacebook();
  }

  @override
  Future<AuthResponse> signInWithGoogle() {
    return _authDatasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _authDatasource.signOut();
  }

  @override
  Future<AuthResponse> signUp(String email, String password, String userName) {
    return _authDatasource.signUpWithEmailPassword(email, password, userName);
  }

  @override
  Future<UserResponse> updatePassword(String newPassword) {
    return _authDatasource.updatePassword(newPassword);
  }

  @override
  Future<AuthResponse> verifyUserAccount(String email, String token) {
    return _authDatasource.verifyUserAccount(email, token);
  }

  @override
  Future<ResendResponse> resendVerificationToken(String email) {
    return _authDatasource.resendToken(email);
  }

  @override
  Future<UserModel> getUserInfo(String userId) {
    return _authDatasource.getUserInfo(userId);
  }

}