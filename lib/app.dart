import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/blocs/language_cubit.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/save_fcm_token_usecase.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/e_store_bloc.dart';
import 'package:healio_app/features/user/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/domain/usecases/get_user_info_usecase.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/favorite_store_cubit.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_info_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:healio_app/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/injector/dependency_injector.dart';
import 'features/user/auth/presentation/bloc/auth_bloc.dart';
import 'features/user/home/presentation/bloc/store_bloc.dart';

class App extends StatefulWidget {
  const App({super.key, required this.initialLanguage});
  final initialLanguage;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<AuthState> _authSub;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _appRouter = inj<AppRouter>();

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) async {
      AuthChangeEvent event = data.event;
      final session = data.session;
      // if (event == AuthChangeEvent.initialSession) {
      //   final router = _appRouter.route;

      //   final prefs = await SharedPreferences.getInstance();
      //   final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      //   if (isFirstLaunch) {
      //     await prefs.setBool('isFirstLaunch', false);
      //     router.go('/landing');
      //     return;
      //   }

      //   final session = inj<CheckUserSessionUseCase>().call();
      //   if (session != null) {
      //     UserModel userInfo = await inj<GetUserInfoUseCase>().call(
      //       session.user.id,
      //     );
      //     if (userInfo.role == 'manager') {
      //       if (userInfo.verifyStore != null && userInfo.verifyStore!) {
      //         router.go('/manager-navigator', extra: userInfo);
      //       } else {
      //         router.go('/incomplete-registration');
      //       }
      //     } else {
      //       router.go('/home');
      //     }
      //   } else {
      //     router.go('/home');
      //   }
      // } else
      if (event == AuthChangeEvent.passwordRecovery) {
        final router = _appRouter.route;
        final state = router.routerDelegate.currentConfiguration;

        final String? email = state.uri.queryParameters['email'];

        _appRouter.route.pushNamed('reset-password', extra: email);
      } else if (event == AuthChangeEvent.signedIn) {
        inj<AuthBloc>().add(AuthChecked());

        if (session?.user != null) {
          inj<SaveFcmTokenUseCase>().call(session!.user.id);
          inj<UserAddressBloc>().add(GetUserAddress(userId: session.user.id));

          final storeInfoCubit = inj<StoreInfomationCubit>();
          final storeState = storeInfoCubit.state;

          if (storeState.currentStore != null) {
            storeInfoCubit.reloadFavoriteStore(
              storeState.currentStore!,
              session.user.id,
            );
          }

          UserModel userInfo = await inj<GetUserInfoUseCase>().call(
            session.user.id,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final router = _appRouter.route;
            final uri = router.state.uri.toString();
            final paths = uri.split('=');
            if (router.state.matchedLocation == '/home') return;

            if (paths.length >= 2) {
              String returnPath = paths.last;
              if (userInfo.role == 'customer') {
                if (returnPath == '/store-detail') {
                  final currentState = inj<StoreInfomationCubit>().state;
                  if (currentState.currentStore != null) {
                    inj<StoreInfomationCubit>().loadInfomationStore(
                      currentState.currentStore!,
                      session.user.id,
                    );
                  }
                  router.pop();
                } else if (returnPath == '/select-datetime') {
                  router.pop();
                } else {
                  router.pop();
                }
              } else {
                if (userInfo.verifyStore != null && userInfo.verifyStore!) {
                  router.go('/manager-navigator', extra: userInfo);
                } else {
                  router.go('/incomplete-registration');
                }
              }
            } else {
              if (userInfo.role == 'customer') {
                router.pop();
              } else {
                if (userInfo.verifyStore != null && userInfo.verifyStore!) {
                  router.go('/manager-navigator', extra: userInfo);
                } else {
                  router.go('/incomplete-registration');
                }
              }
            }
          });
        }
      } else if (event == AuthChangeEvent.signedOut) {
        inj<UserAddressBloc>().add(ClearUserAddress());

        Future.delayed(Duration(milliseconds: 300), () {
          _appRouter.route.go('/home');
        });
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              inj<LanguageCubit>()..loadLanguage(widget.initialLanguage),
        ),
        BlocProvider(create: (context) => inj<AuthBloc>()),
        BlocProvider(create: (context) => inj<StoreBloc>()),
        BlocProvider(create: (context) => inj<EStoreBloc>()),
        BlocProvider(create: (context) => inj<UserAddressBloc>()),
        BlocProvider(create: (context) => inj<SearchFilterCubit>()),
        BlocProvider(create: (context) => inj<StoreInfomationCubit>()),
        BlocProvider(create: (context) => inj<BookingCubit>()),
        BlocProvider(create: (context) => inj<UserInfoCubit>()),
        BlocProvider(create: (context) => inj<FavoriteStoreCubit>()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: 'Healia App',
            locale: localeState,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _appRouter.route,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: SnackBarHelper.messengerKey,
            theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.quicksandTextTheme(
                ThemeData.light().textTheme,
              ),
            ),
          );
        },
      ),
    );
  }
}
