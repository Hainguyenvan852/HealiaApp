import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/explore/presentation/blocs/e_store_bloc.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/explore/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/injector/dependency_injector.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/store_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

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

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      AuthChangeEvent event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.passwordRecovery) {
        _appRouter.route.go('/reset-password');
      } else if (event == AuthChangeEvent.signedIn) {
        inj<AuthBloc>().add(AuthChecked());

        if (session?.user != null) {
          inj<UserAddressBloc>().add(GetUserAddress(userId: session!.user.id));

          final storeInfoCubit = inj<StoreInfomationCubit>();
          final storeState = storeInfoCubit.state;

          if(storeState.currentStore != null){
            storeInfoCubit.reloadFavoriteStore(storeState.currentStore!, session.user.id);
          }
        }

        Future.delayed(const Duration(milliseconds: 400), () {
          final router = _appRouter.route;
          final currentPath = router.routerDelegate.currentConfiguration.uri.toString();

          router.go(currentPath);

          // if (currentPath.contains('/login')) {
          //   if (router.canPop()) {
          //     router.pop('login_success');
          //   }
          // } else if (!currentPath.contains('/profile')) {
          //   router.go('/profile');
          // }
        });
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
        BlocProvider(create: (context) => inj<AuthBloc>()),
        BlocProvider(create: (context) => inj<StoreBloc>()),
        BlocProvider(create: (context) => inj<EStoreBloc>()),
        BlocProvider(create: (context) => inj<UserAddressBloc>()),
        BlocProvider(create: (context) => inj<SearchFilterCubit>()),
        BlocProvider(create: (context) => inj<StoreInfomationCubit>()),
        BlocProvider(create: (context) => inj<BookingCubit>()),
      ],
      child: MaterialApp.router(
        supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
        routerConfig: _appRouter.route,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        title: 'Healio App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            ThemeData.light().textTheme,
          ),
        ),
      ),
    );
  }
}
