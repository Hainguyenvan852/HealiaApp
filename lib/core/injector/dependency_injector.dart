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
import 'package:healio_app/features/home/data/datasources/store_datasource.dart';
import 'package:healio_app/features/home/data/irepositories/istore_repository.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/domain/usecases/load_newly_store_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/load_recently_store_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/load_recommend_store_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/load_store_with_distance_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/load_store_with_id_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/load_trending_store_usecase.dart';
import 'package:healio_app/features/home/presentation/bloc/e_store_bloc.dart';
import 'package:healio_app/features/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final inj = GetIt.instance;

Future<void> initDependencies() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!
  );

  final SupabaseClient supabase = Supabase.instance.client;

  //Router
  inj.registerLazySingleton<AppRouter>(() => AppRouter());

  //Datasource
  inj.registerLazySingleton<AuthDataSource>(() => AuthDataSource(supabase));
  inj.registerLazySingleton<StoreDatasource>(() => StoreDatasource(supabase));

  //Repositories
  inj.registerLazySingleton<AuthRepository>(() => IAuthRepository(inj<AuthDataSource>()));
  inj.registerLazySingleton<StoreRepository>(() => IStoreRepository(inj<StoreDatasource>()));

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

  inj.registerLazySingleton<LoadRecentlyStoreUseCase>(() => LoadRecentlyStoreUseCase(inj<StoreRepository>()));
  inj.registerLazySingleton<LoadTrendingStoreUseCase>(() => LoadTrendingStoreUseCase(inj<StoreRepository>()));
  inj.registerLazySingleton<LoadNewlyStoreUseCase>(() => LoadNewlyStoreUseCase(inj<StoreRepository>()));
  inj.registerLazySingleton<LoadStoreWithIdUseCase>(() => LoadStoreWithIdUseCase(inj<StoreRepository>()));
  inj.registerLazySingleton<LoadStoreWithDistanceUseCase>(() => LoadStoreWithDistanceUseCase(inj<StoreRepository>()));
  inj.registerLazySingleton<LoadRecommendStoreUseCase>(() => LoadRecommendStoreUseCase(inj<StoreRepository>()));

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

  inj.registerLazySingleton<StoreBloc>(
      () => StoreBloc(
        loadRecommendStoreUseCase: inj<LoadRecommendStoreUseCase>(),
        loadNewlyStoreUseCase: inj<LoadNewlyStoreUseCase>(),
        loadStoreWithDistanceUseCase: inj<LoadStoreWithDistanceUseCase>(),
        loadRecentlyStoreUseCase: inj<LoadRecentlyStoreUseCase>(),
        loadTrendingStoreUseCase: inj<LoadTrendingStoreUseCase>(),
        checkUserSessionUseCase: inj<CheckUserSessionUseCase>()
      )
  );

  inj.registerLazySingleton<EStoreBloc>(
      () => EStoreBloc(
        loadStoreWithDistanceUseCase: inj<LoadStoreWithDistanceUseCase>()
      )
  );

}