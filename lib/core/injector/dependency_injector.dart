import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:healio_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:healio_app/features/auth/data/irepositories/iauth_repository.dart';
import 'package:healio_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:healio_app/features/auth/domain/usecases/check_email_exist_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/facebook_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_email_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_info_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/resend_verification_token.dart';
import 'package:healio_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/verify_user_account.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final inj = GetIt.instance;

Future<void> initDependencies() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!
  );

  final SupabaseClient supabase = Supabase.instance.client;

  //Datasource
  inj.registerLazySingleton<AuthDataSource>(() => AuthDataSource(supabase));

  //Repositories
  inj.registerLazySingleton<AuthRepository>(() => IAuthRepository(inj<AuthDataSource>()));

  //Use Cases
  inj.registerLazySingleton<CheckEmailExistUseCase>(() => CheckEmailExistUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<CheckUserSessionUseCase>(() => CheckUserSessionUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<FacebookSignInUseCase>(() => FacebookSignInUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<GetUserEmailUseCase>(() => GetUserEmailUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<GoogleSignInUseCase>(() => GoogleSignInUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<SignInUseCase>(() => SignInUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<UpdatePasswordUseCase>(() => UpdatePasswordUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<VerifyUserAccountUseCase>(() => VerifyUserAccountUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<ResendVerificationTokenUseCase>(() => ResendVerificationTokenUseCase(inj<AuthRepository>()));
  inj.registerLazySingleton<GetUserInfoUseCase>(() => GetUserInfoUseCase(inj<AuthRepository>()));

  //Blocs
  inj.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        signInUserUseCase: inj<SignInUseCase>(),
        signUpUserUseCase: inj<SignUpUseCase>(),
        signOutUserUseCase: inj<SignOutUseCase>(),
        signInWithGoogleUseCase: inj<GoogleSignInUseCase>(),
        signInWithFacebookUseCase: inj<FacebookSignInUseCase>(),
        checkEmailExistUseCase: inj<CheckEmailExistUseCase>(),
        resetPasswordUseCase: inj<ResetPasswordUseCase>(),
        updatePasswordUseCase: inj<UpdatePasswordUseCase>(),
        getUserEmailUseCase: inj<GetUserEmailUseCase>(),
        checkUserSessionUseCase: inj<CheckUserSessionUseCase>(),
        verifyUserAccountUseCase: inj<VerifyUserAccountUseCase>(),
        resendVerificationTokenUseCase: inj<ResendVerificationTokenUseCase>(),
        getUserInfoUseCase: inj<GetUserInfoUseCase>(),
      )
  );


}