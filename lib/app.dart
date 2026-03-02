import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/auth/domain/usecases/check_email_exist_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/facebook_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/get_user_email_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/resend_verification_token.dart';
import 'package:healio_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:healio_app/features/auth/domain/usecases/verify_user_account.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/router/router.dart';

import 'core/injector/dependency_injector.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
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
                verifyUserAccount: inj<VerifyUserAccount>(),
                resendVerificationToken: inj<ResendVerificationToken>()
            )
        ),

      ],
      child: MaterialApp.router(
        routerConfig: appRouter.route,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        theme: ThemeData(
            textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme)
        ),
      ),
    );
  }
}


