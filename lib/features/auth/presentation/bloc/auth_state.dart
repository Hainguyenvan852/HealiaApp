part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String errorMsg;

  AuthError({required this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthEmailSuccess extends AuthState {
  final String email;

  AuthEmailSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

final class AuthFacebookSignInSuccess extends AuthState {}

final class AuthGoogleSignInSuccess extends AuthState {
  final User user;

  AuthGoogleSignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthSignedOutSuccess extends AuthState {}

class EmailVerificationRequired extends AuthState {
  final String email;

  EmailVerificationRequired(this.email);
}

class ResetPasswordRequestSuccess extends AuthState {}

class UpdatePasswordSuccess extends AuthState {}

class CheckUserSessionSuccess extends AuthState {
  final User user;

  CheckUserSessionSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class CheckUserSessionNotFound extends AuthState {}