import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/manager/account setups/data/datasources/account_setup_datasource.dart';
import '../../features/manager/account setups/data/repositories/account_setup_repository_impl.dart';
import '../../features/manager/account setups/domain/usecases/add_category_usecase.dart';
import '../../features/manager/account setups/domain/usecases/add_service_usecase.dart';
import '../../features/manager/account setups/domain/usecases/add_staff_usecase.dart';
import '../../features/manager/account setups/domain/usecases/add_store_usecase.dart';
import '../../features/manager/account setups/domain/usecases/add_working_hour_usecase.dart';
import '../../features/manager/options/data/datasources/report_datasource.dart';
import '../../features/user/appointment/data/datasource/appointment_datasource.dart';
import '../../features/user/appointment/data/irepositories/appointment_repository.dart';
import '../../features/user/appointment/domain/usecases/add_new_review_usecase.dart';
import '../../features/user/appointment/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/user/appointment/domain/usecases/create_new_appointment_usecase.dart';
import '../../features/user/appointment/domain/usecases/get_review_by_apm_usecase.dart';
import '../../features/user/appointment/domain/usecases/get_user_appointment_by_day_usecase.dart';
import '../../features/user/appointment/domain/usecases/get_user_appointment_usecase.dart';
import '../../features/user/appointment/domain/usecases/request_cancel_appointment_usecase.dart';
import '../../features/user/appointment/domain/usecases/update_appointment_usecase.dart';
import '../../features/user/auth/data/datasource/auth_datasource.dart';
import '../../features/user/auth/data/irepositories/iauth_repository.dart';
import '../../features/user/auth/domain/repositories/auth_repository.dart';
import '../../features/user/auth/domain/usecases/check_current_user_usecase.dart';
import '../../features/user/auth/domain/usecases/check_email_exist_usecase.dart';
import '../../features/user/auth/domain/usecases/check_user_session_usecase.dart';
import '../../features/user/auth/domain/usecases/facebook_sign_in_usecase.dart';
import '../../features/user/auth/domain/usecases/get_user_email_usecase.dart';
import '../../features/user/auth/domain/usecases/google_sign_in_usecase.dart';
import '../../features/user/auth/domain/usecases/resend_verification_token_usecase.dart';
import '../../features/user/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/user/auth/domain/usecases/save_fcm_token_usecase.dart';
import '../../features/user/auth/domain/usecases/set_role_manager_usacase.dart';
import '../../features/user/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/user/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/user/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/user/auth/domain/usecases/update_password_usecase.dart';
import '../../features/user/auth/domain/usecases/verify_user_account.dart';
import '../../features/user/auth/presentation/bloc/auth_bloc.dart';
import '../../features/user/explore/data/datasources/store_datasource.dart';
import '../../features/user/explore/data/irepositories/i_store_repository.dart';
import '../../features/user/explore/domain/repositories/store_repository.dart';
import '../../features/user/explore/domain/usecases/delete_favorite_store_usecase.dart';
import '../../features/user/explore/domain/usecases/get_favorite_store_usecase.dart';
import '../../features/user/explore/domain/usecases/get_favorite_stores_usecase.dart';
import '../../features/user/explore/domain/usecases/get_store_image_usecase.dart';
import '../../features/user/explore/domain/usecases/get_team_member_by_service_usecase.dart';
import '../../features/user/explore/domain/usecases/insert_favorite_store_usecase.dart';
import '../../features/user/explore/domain/usecases/load_newly_store_usecase.dart';
import '../../features/user/explore/domain/usecases/load_recently_store_usecase.dart';
import '../../features/user/explore/domain/usecases/load_recommend_store_usecase.dart';
import '../../features/user/explore/domain/usecases/load_store_with_distance_usecase.dart';
import '../../features/user/explore/domain/usecases/load_store_with_id_usecase.dart';
import '../../features/user/explore/domain/usecases/load_trending_store_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_all_filter_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_category_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_date_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_datetime_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_filter_usecase.dart';
import '../../features/user/explore/domain/usecases/search_by_time_usecase.dart';
import '../../features/user/explore/domain/usecases/search_store_around_location_usecase.dart';
import '../../features/user/explore/presentation/blocs/e_store_bloc.dart';
import '../../features/user/explore/presentation/blocs/search_cubit.dart';
import '../../features/user/home/domain/usecases/get_categories_usecase.dart';
import '../../features/user/home/domain/usecases/get_opening_hours_usecase.dart';
import '../../features/user/home/domain/usecases/get_reviews_usecase.dart';
import '../../features/user/home/domain/usecases/get_services_usecase.dart';
import '../../features/user/home/presentation/bloc/booking_cubit.dart';
import '../../features/user/home/presentation/bloc/store_bloc.dart';
import '../../features/user/home/presentation/bloc/store_infomation_cubit.dart';
import '../../features/user/profile/data/datasource/user_address_datasource.dart';
import '../../features/user/profile/data/datasource/user_datasource.dart';
import '../../features/user/profile/data/irepositories/i_user_address_repository.dart';
import '../../features/user/profile/data/irepositories/i_user_repository.dart';
import '../../features/user/profile/domain/repositories/user_address_repository.dart';
import '../../features/user/profile/domain/repositories/user_repository.dart';
import '../../features/user/profile/domain/usecases/add_user_address_usecase.dart';
import '../../features/user/profile/domain/usecases/delete_user_address_usecase.dart';
import '../../features/user/profile/domain/usecases/delete_user_avatar_usecase.dart';
import '../../features/user/profile/domain/usecases/get_user_address_usecase.dart';
import '../../features/user/profile/domain/usecases/get_user_info_usecase.dart';
import '../../features/user/profile/domain/usecases/get_user_settings_usecase.dart';
import '../../features/user/profile/domain/usecases/insert_user_settings_usecase.dart';
import '../../features/user/profile/domain/usecases/save_user_avatar_usecase.dart';
import '../../features/user/profile/domain/usecases/update_user_address_usecase.dart';
import '../../features/user/profile/domain/usecases/update_user_info_usecase.dart';
import '../../features/user/profile/domain/usecases/update_user_settings_usecase.dart';
import '../../features/user/profile/presentation/blocs/favorite_store_cubit.dart';
import '../../features/user/profile/presentation/blocs/user_address_bloc.dart';
import '../../features/user/profile/presentation/blocs/user_info_cubit.dart';
import '../../router/router.dart';
import '../../shared/datasource/client_datasource.dart';
import '../../shared/datasource/notification_datasource.dart';
import '../../shared/datasource/transaction_datasource.dart';
import '../blocs/language_cubit.dart';
import '../services/network_manager.dart';

final inj = GetIt.instance;
Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkManager.instance.init();
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
  inj.registerLazySingleton<UserDatasource>(
    () => UserDatasource(supabase: supabase),
  );
  inj.registerLazySingleton<AppointmentDatasource>(
    () => AppointmentDatasource(supabase),
  );
  inj.registerLazySingleton<AccountSetupDatasource>(
    () => AccountSetupDatasource(supabase),
  );
  inj.registerLazySingleton<TransactionDatasource>(
    () => TransactionDatasource(supabase),
  );
  inj.registerLazySingleton<ClientDatasource>(() => ClientDatasource(supabase));
  inj.registerLazySingleton<NotificationDatasource>(
    () => NotificationDatasource(supabase),
  );
  inj.registerLazySingleton<ReportDatasource>(() => ReportDatasource(supabase));
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
  inj.registerLazySingleton<UserRepository>(
    () => IUserRepository(userDatasource: inj<UserDatasource>()),
  );
  inj.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepository(dataSource: inj<AppointmentDatasource>()),
  );
  inj.registerLazySingleton<AccountSetupRepositoryImpl>(
    () => AccountSetupRepositoryImpl(inj<AccountSetupDatasource>()),
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
  inj.registerLazySingleton<SaveFcmTokenUseCase>(
    () => SaveFcmTokenUseCase(inj<AuthRepository>()),
  );
  inj.registerLazySingleton<SetRoleManagerUsacase>(
    () => SetRoleManagerUsacase(inj<AuthDataSource>()),
  );
  inj.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<UpdateUserInfoUsecase>(
    () => UpdateUserInfoUsecase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<SaveUserAvatarUseCase>(
    () => SaveUserAvatarUseCase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<DeleteUserAvatarUsecase>(
    () => DeleteUserAvatarUsecase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<GetUserSettingsUseCase>(
    () => GetUserSettingsUseCase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<InsertUserSettingsUseCase>(
    () => InsertUserSettingsUseCase(inj<UserRepository>()),
  );
  inj.registerLazySingleton<UpdateUserSettingsUseCase>(
    () => UpdateUserSettingsUseCase(inj<UserRepository>()),
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
  inj.registerLazySingleton<GetReviewsByStoreUsecase>(
    () => GetReviewsByStoreUsecase(inj<StoreRepository>()),
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
  inj.registerLazySingleton<GetStoreImageUseCase>(
    () => GetStoreImageUseCase(inj<StoreRepository>()),
  );
  inj.registerLazySingleton<GetUserAppointmentUsecase>(
    () => GetUserAppointmentUsecase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<GetUserAppointmentByDayUsecase>(
    () => GetUserAppointmentByDayUsecase(
      repository: inj<AppointmentRepository>(),
    ),
  );
  inj.registerLazySingleton<CreateNewAppointmentUseCase>(
    () => CreateNewAppointmentUseCase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<GetReviewByApmUsecase>(
    () => GetReviewByApmUsecase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<AddNewReviewUsecase>(
    () => AddNewReviewUsecase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<CancelAppointmentUsecase>(
    () => CancelAppointmentUsecase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<UpdateAppointmentUseCase>(
    () => UpdateAppointmentUseCase(repository: inj<AppointmentRepository>()),
  );
  inj.registerLazySingleton<RequestCancelAppointmentUseCase>(
    () => RequestCancelAppointmentUseCase(
      repository: inj<AppointmentRepository>(),
    ),
  );
  inj.registerLazySingleton<AddStoreUsecase>(
    () => AddStoreUsecase(inj<AccountSetupRepositoryImpl>()),
  );
  inj.registerLazySingleton<AddStaffUsecase>(
    () => AddStaffUsecase(inj<AccountSetupRepositoryImpl>()),
  );
  inj.registerLazySingleton<AddCategoryUsecase>(
    () => AddCategoryUsecase(inj<AccountSetupRepositoryImpl>()),
  );
  inj.registerLazySingleton<AddServiceUsecase>(
    () => AddServiceUsecase(inj<AccountSetupRepositoryImpl>()),
  );
  inj.registerLazySingleton<AddWorkingHourUsecase>(
    () => AddWorkingHourUsecase(inj<AccountSetupRepositoryImpl>()),
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
      setRoleManagerUsacase: inj<SetRoleManagerUsacase>(),
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
      getReviewsUsecase: inj<GetReviewsByStoreUsecase>(),
      getOpeningHoursUsecase: inj<GetOpeningHoursUsecase>(),
      searchStoreAroundLocationUseCase: inj<SearchStoreAroundLocationUseCase>(),
      getFavoriteStoreUsecase: inj<GetFavoriteStoreUsecase>(),
      insertFavoriteStoreUsecase: inj<InsertFavoriteStoreUsecase>(),
      deleteFavoriteStoreUsecase: inj<DeleteFavoriteStoreUsecase>(),
      getStoreImageUseCase: inj<GetStoreImageUseCase>(),
    ),
  );
  inj.registerLazySingleton<BookingCubit>(() => BookingCubit());
  inj.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(getUserInfoUseCase: inj<GetUserInfoUseCase>()),
  );
  inj.registerLazySingleton<FavoriteStoreCubit>(
    () => FavoriteStoreCubit(
      inj<GetFavoriteStoresUsecase>(),
      inj<LoadStoreWithIdUseCase>(),
      inj<InsertFavoriteStoreUsecase>(),
      inj<DeleteFavoriteStoreUsecase>(),
    ),
  );
  inj.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
}
