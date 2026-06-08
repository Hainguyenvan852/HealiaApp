part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthChecked extends AuthEvent {}

class UserSignedIn extends AuthEvent {
  final String email;
  final String password;

  UserSignedIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserSignedUp extends AuthEvent {
  final String email;
  final String password;
  final String userName;
  final String role;

  UserSignedUp({
    required this.email,
    required this.password,
    required this.userName,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password];
}

class VerifyEmailRequest extends AuthEvent {
  final String email;
  final String token;

  VerifyEmailRequest({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}

class ResendTokenRequest extends AuthEvent {
  final String email;

  ResendTokenRequest({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthReset extends AuthEvent {}

class UserSignedOutRequested extends AuthEvent {}

class GetCurrentUserEmail extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {
  final String role;
  GoogleSignInRequested({required this.role});
}

class FacebookSignInRequested extends AuthEvent {
  FacebookSignInRequested();
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  ResetPasswordRequested({required this.email});
}

class UpdatePasswordRequested extends AuthEvent {
  final String newPassword;
  UpdatePasswordRequested({required this.newPassword});
}

class CheckUserSessionRequested extends AuthEvent {}
