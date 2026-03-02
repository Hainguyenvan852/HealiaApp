import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {
  final SupabaseClient _supabase;
  static final String _webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
  static final String _androidClientId = dotenv.env['GOOGLE_ANDROID_CLIENT_ID']!;

  AuthDataSource(this._supabase);

  Future<AuthResponse> signInWithEmailPassword(String email, String password) async{
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> signUpWithEmailPassword(String email, String password, String userName) async{
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        channel: OtpChannel.sms,
        emailRedirectTo: 'io.supabase.flutterapp://login-callback',
        data: {
          'full_name': userName
        }
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> verifyUserAccount(String email, String token) async{
    try {
      final AuthResponse res = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: token
      );
      return res;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ResendResponse> resendToken(String email){
    return _supabase.auth.resend(
        type: OtpType.signup,
        email: email
    );
  }

  Future<AuthResponse> signInWithGoogle() async{
    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;
    googleSignIn.initialize(
        clientId: _androidClientId,
        serverClientId: _webClientId
    );

    final googleUser = await googleSignIn.attemptLightweightAuthentication();
    if (googleUser == null) {
      throw AuthException('Failed to sign in with Google');
    }

    //Xin cấp quyền phạm vi truy cập
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }
    return await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
  }

  Future<bool> signInWithFacebook() async {
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: kIsWeb
          ? 'https://cuscgyubgzsejppmkcif.supabase.co/auth/v1/callback'
          : '<package-name>://auth-callback',
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  }

  Future<bool> isEmailExist(String email) async{
    try {
      final result = await _supabase.rpc(
        'check_user_exist',
        params: {'email_check': email},
      );
      return result as bool;
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutterapp://auth-callback?type=recovery',
      );
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      await googleSignIn.signOut();
    }

    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }

  Session? checkUserSession() {
    try {
      return _supabase.auth.currentSession;
    } catch (e) {
      throw Exception({e.toString()});
    }
  }
}