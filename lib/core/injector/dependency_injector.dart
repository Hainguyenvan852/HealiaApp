import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:healio_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:healio_app/features/auth/data/irepositories/iauth_repository.dart';
import 'package:healio_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:healio_app/features/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/check_email_exist_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/facebook_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_email_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_info_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/resend_verification_token_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/verify_user_account.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/features/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/explore/data/datasources/user_address_datasource.dart';
import 'package:healio_app/features/explore/data/irepositories/i_store_repository.dart';
import 'package:healio_app/features/explore/data/irepositories/i_user_address_repository.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';
import 'package:healio_app/features/explore/domain/usecases/add_user_address_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/delete_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/delete_user_address_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/get_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/get_favorite_stores_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/get_team_member_by_service_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/get_user_address_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/insert_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_newly_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_recently_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_recommend_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_store_with_distance_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_store_with_id_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/load_trending_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_all_filter_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_category_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_date_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_datetime_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_filter_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_time_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_store_around_location_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/update_user_address_usecase.dart';
import 'package:healio_app/features/explore/presentation/blocs/e_store_bloc.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/explore/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_opening_hours_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_reviews_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_services_usecase.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/features/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final inj = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  final SupabaseClient supabase = Supabase.instance.client;

  //Router
  inj.registerLazySingleton<AppRouter>(() => AppRouter());

  //Datasource
  inj.registerLazySingleton<AuthDataSource>(() => AuthDataSource(supabase));
  inj.registerLazySingleton<StoreDatasource>(() => StoreDatasource(supabase));
  inj.registerLazySingleton<UserAddressDatasource>(
    () => UserAddressDatasource(supabase),
  );

  //Repositories
  inj.registerLazySingleton<AuthRepository>(
    () => IAuthRepository(inj<AuthDataSource>()),
  );
  inj.registerLazySingleton<StoreRepository>(
    () => IStoreRepository(inj<StoreDatasource>()),
  );
  inj.registerLazySingleton<UserAddressRepository>(
    () => IUserAddressRepository(inj<UserAddressDatasource>()),
  );

  //Use Cases
  inj.registerLazySingleton<CheckEmailExistUseCase>(
    () => CheckEmailExistUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<CheckUserSessionUseCase>(
    () => CheckUserSessionUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<CheckCurrentUserUseCase>(
    () => CheckCurrentUserUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<FacebookSignInUseCase>(
    () => FacebookSignInUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<GetUserEmailUseCase>(
    () => GetUserEmailUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<VerifyUserAccountUseCase>(
    () => VerifyUserAccountUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<ResendVerificationTokenUseCase>(
    () => ResendVerificationTokenUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(inj<AuthRepository>()),
  );
  
  inj.registerLazySingleton<LoadRecentlyStoreUseCase>(
    () => LoadRecentlyStoreUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<LoadTrendingStoreUseCase>(
    () => LoadTrendingStoreUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<LoadNewlyStoreUseCase>(
    () => LoadNewlyStoreUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<LoadStoreWithIdUseCase>(
    () => LoadStoreWithIdUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<LoadStoreWithDistanceUseCase>(
    () => LoadStoreWithDistanceUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<LoadRecommendStoreUseCase>(
    () => LoadRecommendStoreUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByAllFilterUseCase>(
    () => SearchByAllFilterUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByFilterUseCase>(
    () => SearchByFilterUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByCategoryUseCase>(
    () => SearchByCategoryUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByDateTimeUseCase>(
    () => SearchByDateTimeUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByDateUseCase>(
    () => SearchByDateUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchByTimeUseCase>(
    () => SearchByTimeUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<SearchStoreAroundLocationUseCase>(
    () => SearchStoreAroundLocationUseCase(inj<StoreRepository>()),
  );

  inj.registerLazySingleton<GetUserAddressUseCase>(
    () => GetUserAddressUseCase(inj<UserAddressRepository>()),
  );
  inj.registerLazySingleton<AddUserAddressUseCase>(
    () => AddUserAddressUseCase(inj<UserAddressRepository>()),
  );
  inj.registerLazySingleton<DeleteUserAddressUseCase>(
    () => DeleteUserAddressUseCase(inj<UserAddressRepository>()),
  );
  inj.registerLazySingleton<UpdateUserAddressUseCase>(
    () => UpdateUserAddressUseCase(inj<UserAddressRepository>()),
  );
  inj.registerLazySingleton<GetCategoriesUsecase>(
    () => GetCategoriesUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetServicesUsecase>(
    () => GetServicesUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetReviewsUsecase>(
    () => GetReviewsUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetOpeningHoursUsecase>(
    () => GetOpeningHoursUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetFavoriteStoreUsecase>(
    () => GetFavoriteStoreUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetFavoriteStoresUsecase>(
    () => GetFavoriteStoresUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<InsertFavoriteStoreUsecase>(
    () => InsertFavoriteStoreUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<DeleteFavoriteStoreUsecase>(
    () => DeleteFavoriteStoreUsecase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetTeamMemberByServiceUseCase>(
    () => GetTeamMemberByServiceUseCase(inj<StoreRepository>()),
  );
  
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
    ),
  );
  inj.registerLazySingleton<StoreBloc>(
    () => StoreBloc(
      loadRecommendStoreUseCase: inj<LoadRecommendStoreUseCase>(),
      loadNewlyStoreUseCase: inj<LoadNewlyStoreUseCase>(),
      loadStoreWithDistanceUseCase: inj<LoadStoreWithDistanceUseCase>(),
      loadRecentlyStoreUseCase: inj<LoadRecentlyStoreUseCase>(),
      loadTrendingStoreUseCase: inj<LoadTrendingStoreUseCase>(),
      checkUserSessionUseCase: inj<CheckUserSessionUseCase>(),
    ),
  );
  inj.registerLazySingleton<EStoreBloc>(
    () => EStoreBloc(
      loadStoreWithDistanceUseCase: inj<LoadStoreWithDistanceUseCase>(),
      searchByAllFilterUseCase: inj<SearchByAllFilterUseCase>(),
      searchByCategoryUseCase: inj<SearchByCategoryUseCase>(),
      searchByFilterUseCase: inj<SearchByFilterUseCase>(),
      searchByDateTimeUseCase: inj<SearchByDateTimeUseCase>(),
      searchByDateUseCase: inj<SearchByDateUseCase>(),
      searchByTimeUseCase: inj<SearchByTimeUseCase>(),
      searchStoreAroundLocationUseCase: inj<SearchStoreAroundLocationUseCase>(),
    ),
  );
  inj.registerLazySingleton<UserAddressBloc>(
    () => UserAddressBloc(
      getUserAddressUseCase: inj<GetUserAddressUseCase>(),
      addAddressUseCase: inj<AddUserAddressUseCase>(),
      checkCurrentUserUseCase: inj<CheckCurrentUserUseCase>(),
      deleteUserAddressUseCase: inj<DeleteUserAddressUseCase>(),
      updateUserAddressUseCase: inj<UpdateUserAddressUseCase>(),
    ),
  );
  
  inj.registerLazySingleton<SearchFilterCubit>(() => SearchFilterCubit());
  inj.registerLazySingleton<StoreInfomationCubit>(
    () => StoreInfomationCubit(
      getCategoriesUsecase: inj<GetCategoriesUsecase>(),
      getServicesUsecase: inj<GetServicesUsecase>(),
      getReviewsUsecase: inj<GetReviewsUsecase>(),
      getOpeningHoursUsecase: inj<GetOpeningHoursUsecase>(), 
      searchStoreAroundLocationUseCase: inj<SearchStoreAroundLocationUseCase>(), 
      getFavoriteStoreUsecase: inj<GetFavoriteStoreUsecase>(), 
      insertFavoriteStoreUsecase: inj<InsertFavoriteStoreUsecase>(), 
      deleteFavoriteStoreUsecase: inj<DeleteFavoriteStoreUsecase>(), 
    ),
  );
  inj.registerLazySingleton<BookingCubit>(() => BookingCubit());
}
