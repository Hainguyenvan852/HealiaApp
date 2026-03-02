import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/auth/domain/usecases/facebook_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/verify_user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/validators/supabase_auth_exception_handler.dart';
import '../../domain/usecases/check_email_exist_usecase.dart';
import '../../domain/usecases/check_user_session_usecase.dart';
import '../../domain/usecases/get_user_email_usecase.dart';
import '../../domain/usecases/resend_verification_token.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUserUseCase;
  final SignUpUseCase signUpUserUseCase;
  final SignOutUseCase signOutUserUseCase;
  final GoogleSignInUseCase signInWithGoogleUseCase;
  final FacebookSignInUseCase signInWithFacebookUseCase;
  final CheckEmailExistUseCase checkEmailExistUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final GetUserEmailUseCase getUserEmailUseCase;
  final CheckUserSessionUseCase checkUserSessionUseCase;
  final VerifyUserAccount verifyUserAccount;
  final ResendVerificationToken resendVerificationToken;
  AuthBloc({
    required this.signInUserUseCase,
    required this.signUpUserUseCase,
    required this.signOutUserUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.checkEmailExistUseCase,
    required this.resetPasswordUseCase,
    required this.updatePasswordUseCase,
    required this.getUserEmailUseCase,
    required this.checkUserSessionUseCase, required this.verifyUserAccount,
    required this.resendVerificationToken,
  }) : super(AuthInitial()) {

    on<AuthChecked>((event, emit){
      final session = checkUserSessionUseCase.call();
      if(session != null){
        if(session.user.appMetadata['provider'] == 'email'){
          emit(AuthSuccess(session.user));
        } else if(session.user.appMetadata['provider'] == 'google'){
          emit(AuthGoogleSignInSuccess(session.user));
        } else if (session.user.appMetadata['provider'] == 'facebook'){
          emit(AuthFacebookSignInSuccess());
        }
      }
    });

    //Kiểm tra xem còn phiên đăng nhập cũ không
    add(AuthChecked());

    on<AuthReset>((event, emit) {
      emit(AuthInitial());
    });

    on<UserSignedUp>((event, emit) async {
      emit(AuthLoading());
      try {
        final isEmailAlreadyExist = await checkEmailExistUseCase.call(
          event.email,
        );

        if (isEmailAlreadyExist) {
          return emit(AuthError(errorMsg: "Email already exist!"));
        } else {
          await signUpUserUseCase.call(event.email, event.password, event.userName);
          emit(EmailVerificationRequired(event.email));
        }
      } catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<VerifyEmailRequest>((event, emit) async{
      emit(AuthLoading());
      try{
        final response = await verifyUserAccount.call(event.email, event.token);
        emit(AuthSuccess(response.user!));
      } catch(e){
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<ResendTokenRequest>((event, emit) async{
      emit(AuthLoading());
      try{
        final response = await resendVerificationToken.call(event.email);
      } catch(e){
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<UserSignedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await signInUserUseCase.call(event.email, event.password);
        emit(AuthSuccess(response.user!));
      } catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<UserSignedOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOutUserUseCase.call();
        emit(AuthSignedOutSuccess());
      } catch (e) {
        emit(AuthError(errorMsg: e.toString()));
      }
    });

    on<GetCurrentUserEmail>((event, emit) {
      emit(AuthLoading());
      final email = getUserEmailUseCase.call();

      if (email != null) {
        emit(AuthEmailSuccess(email));
      } else {
        emit(AuthError(errorMsg: "No user email found."));
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await signInWithGoogleUseCase.call();
        emit(AuthGoogleSignInSuccess(response.user!));
      } on AuthException catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e.message)));
      } catch (e){
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<FacebookSignInRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await signInWithFacebookUseCase.call();

        emit(AuthFacebookSignInSuccess());
      } catch (e) {
        emit(AuthError(errorMsg: e.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await resetPasswordUseCase.call(event.email);
        emit(ResetPasswordRequestSuccess());
      } catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<UpdatePasswordRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await updatePasswordUseCase.call(event.newPassword);
        emit(UpdatePasswordSuccess());
      } catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<CheckUserSessionRequested>((event, emit) {
      emit(AuthLoading());

      try {
        final session = checkUserSessionUseCase.call();
        if (session != null) {
          emit(CheckUserSessionSuccess(session.user));
        } else {
          emit(CheckUserSessionNotFound());
        }
      } catch (e) {
        emit(AuthError(errorMsg: e.toString()));
      }
    });
  }
}