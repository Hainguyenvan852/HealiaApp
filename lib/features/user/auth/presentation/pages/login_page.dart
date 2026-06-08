import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/features/user/auth/presentation/widgets/login_header.dart';
import 'package:healio_app/features/user/auth/presentation/widgets/login_textfield.dart';
import 'package:healio_app/features/user/auth/presentation/widgets/oauth_button.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../core/validators/text_field_validation.dart';
import '../widgets/auth_text_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final logInFormKey = GlobalKey<FormState>();

  void _logIn() {
    if (logInFormKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      context.read<AuthBloc>().add(
        UserSignedIn(email: email, password: password),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, OAuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AuthError) {
          SnackBarHelper.showError(state.errorMsg);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SafeArea(
            child: Form(
              key: logInFormKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      LoginHeader(onTap: () => context.pop()),

                      const SizedBox(height: 30),
                      OAuthButton(
                        title: AppLocalizations.of(context)!.withGoogle,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            GoogleSignInRequested(role: 'customer'),
                          );
                        },
                        imageAsset: 'assets/icons/google-icon-logo.svg',
                      ),
                      // const SizedBox(height: 20),
                      // OAuthButton(
                      //   title: AppLocalizations.of(context)!.withFacebook,
                      //   onPressed: () {
                      //     isConnected
                      //         ? context.read<AuthBloc>().add(
                      //             FacebookSignInRequested(),
                      //           )
                      //         : SnackBarHelper.showError(
                      //             'No internet connection',
                      //           );
                      //   },
                      //   imageAsset: 'assets/icons/facebook-logo-icon.svg',
                      // ),
                      const SizedBox(height: 30),
                      const Row(
                        children: [
                          Flexible(
                            child: Divider(
                              height: 0.5,
                              indent: 8,
                              endIndent: 8,
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Divider(
                              height: 0.5,
                              indent: 8,
                              endIndent: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      LoginTextField(
                        title: AppLocalizations.of(context)!.email,
                        hint: AppLocalizations.of(context)!.email,
                        isPassword: false,
                        validator: emailValidation,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      LoginTextField(
                        title: AppLocalizations.of(context)!.password,
                        hint: AppLocalizations.of(context)!.password,
                        isPassword: true,
                        controller: passwordController,
                        validator: emptyPasswordValidation,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: state is AuthLoading
                                ? null
                                : () => context.push('/forgot-password'),
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: GoogleFonts.quicksand(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      FilledButton(
                        onPressed: state is AuthLoading ? null : () => _logIn(),
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(30),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: state is AuthLoading
                            ? Center(
                                child: LoadingAnimationWidget.progressiveDots(
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.logIn,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      AuthTextButton(
                        onTap: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(AuthReset());
                                context.push('/signup', extra: 'customer');
                              },
                        title: AppLocalizations.of(context)!.signUp,
                        content: AppLocalizations.of(context)!.dontHaveAccount,
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 0.5, indent: 8, endIndent: 8),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Are you a business manager in Healia?',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: state is AuthLoading
                              ? null
                              : () => context.push('/professional-login'),
                          child: Text(
                            'Switch to Helia for business',
                            style: GoogleFonts.quicksand(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
