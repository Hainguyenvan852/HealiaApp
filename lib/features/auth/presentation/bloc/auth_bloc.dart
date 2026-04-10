import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/auth/data/models/user_model.dart';
import 'package:healio_app/features/auth/domain/usecases/facebook_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_info_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/verify_user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/validators/supabase_auth_exception_handler.dart';
import '../../domain/usecases/check_email_exist_usecase.dart';
import '../../domain/usecases/check_user_session_usecase.dart';
import '../../domain/usecases/get_user_email_usecase.dart';
import '../../domain/usecases/resend_verification_token_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, OAuthState> {
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
  final VerifyUserAccountUseCase verifyUserAccountUseCase;
  final ResendVerificationTokenUseCase resendVerificationTokenUseCase;
  final GetUserInfoUseCase getUserInfoUseCase;


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
    required this.checkUserSessionUseCase,
    required this.verifyUserAccountUseCase,
    required this.resendVerificationTokenUseCase,
    required this.getUserInfoUseCase,
  }) : super(AuthInitial()) {

    on<AuthChecked>((event, emit) async{
      final session = checkUserSessionUseCase.call();
      if(session != null){
        final user = await getUserInfoUseCase.call(session.user.id);
        emit(AuthSuccess(user));
      } else{
        emit(UnAuthenticated());
      }
    });

    on<AuthReset>((event, emit) {
      emit(UnAuthenticated());
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
        final response = await verifyUserAccountUseCase.call(event.email, event.token);
        final user = await getUserInfoUseCase.call(response.user!.id);
        emit(AuthSuccess(user));
      } catch(e){
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<ResendTokenRequest>((event, emit) {
      emit(AuthLoading());
      try{
        resendVerificationTokenUseCase.call(event.email);
      } catch(e){
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
      }
    });

    on<UserSignedIn>((event, emit) {
      emit(AuthLoading());
      try {
        signInUserUseCase.call(event.email, event.password);
        // final user = await getUserInfoUseCase.call(response.user!.id);
        // emit(AuthSuccess(user));
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

    on<GoogleSignInRequested>((event, emit) {
      emit(AuthLoading());

      try {
        signInWithGoogleUseCase.call();
        // final user = await getUserInfoUseCase.call(response.user!.id);
        // emit(AuthSuccess(user));
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

      } catch (e) {
        emit(AuthError(errorMsg: SupabaseAuthExceptionHandler.parse(e)));
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

        final session = Supabase.instance.client.auth.currentSession;
        if(session != null){
          await signOutUserUseCase.call();
        }
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

    //Kiểm tra xem còn phiên đăng nhập cũ không
    add(AuthChecked());
  }


}