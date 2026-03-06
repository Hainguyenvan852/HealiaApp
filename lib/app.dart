import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
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
import 'package:healio_app/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/injector/dependency_injector.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  final appRouter = AppRouter();
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data){
      AuthChangeEvent event = data.event;

      if(event == AuthChangeEvent.passwordRecovery){
        appRouter.route.go('/reset-password');
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
            create: (context) => AuthBloc(
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
        ),

      ],
      child: MaterialApp.router(
        routerConfig: appRouter.route,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        title: 'Healio App',
        theme: ThemeData(
            textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme)
        ),
      ),
    );
  }
}


