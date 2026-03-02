import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn(String email, String password);
  Future<AuthResponse> signUp(String email, String password, String userName);
  Future<void> signOut();
  Future<AuthResponse> verifyUserAccount(String email, String token);
  Future<ResendResponse> resendVerificationToken(String email);
  Future<AuthResponse> signInWithGoogle();
  Future<bool> signInWithFacebook();
  Future<bool> isEmailExist(String email);
  Future<void> resetPassword(String email);
  Future<UserResponse> updatePassword(String newPassword);
  String? getCurrentUserEmail();
  Session? checkUserSession();
}