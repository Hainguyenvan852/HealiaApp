part of 'auth_bloc.dart';

abstract class OAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends OAuthState {}

final class AuthLoading extends OAuthState {}

final class AuthError extends OAuthState {
  final String errorMsg;

  AuthError({required this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}

final class AuthSuccess extends OAuthState {
  final UserModel user;

  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class UnAuthenticated extends OAuthState {}

final class AuthEmailSuccess extends OAuthState {
  final String email;

  AuthEmailSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

// final class AuthFacebookSignInSuccess extends OAuthState {}
//
// final class AuthGoogleSignInSuccess extends OAuthState {
//   final User user;
//
//   AuthGoogleSignInSuccess(this.user);
//
//   @override
//   List<Object?> get props => [user];
// }

final class AuthSignedOutSuccess extends OAuthState {}

class EmailVerificationRequired extends OAuthState {
  final String email;

  EmailVerificationRequired(this.email);
}

class ResetPasswordRequestSuccess extends OAuthState {}

class UpdatePasswordSuccess extends OAuthState {}

class CheckUserSessionSuccess extends OAuthState {
  final User user;

  CheckUserSessionSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class CheckUserSessionNotFound extends OAuthState {}