import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../core/validators/text_field_validation.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../user/auth/presentation/bloc/auth_bloc.dart';
import '../../../../user/auth/presentation/widgets/auth_text_button.dart';
import '../../../../user/auth/presentation/widgets/login_textfield.dart';
import '../../../../user/auth/presentation/widgets/oauth_button.dart';

class ProfessionalLoginPage extends StatefulWidget {
  const ProfessionalLoginPage({super.key});

  @override
  State<ProfessionalLoginPage> createState() => _ProfessionalLoginPageState();
}

class _ProfessionalLoginPageState extends State<ProfessionalLoginPage> {
  final logInFormKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _logIn() {
    if (logInFormKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text.trim();

      context.read<AuthBloc>().add(
        UserSignedIn(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, OAuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AuthError) {
            SnackBarHelper.showError(state.errorMsg);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: logInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),

                  Text(
                    AppLocalizations.of(context)!.forProfessionals,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    AppLocalizations.of(context)!.loginToManageBusiness,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  LoginTextField(
                    title: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.email,
                    isPassword: false,
                    validator: emailValidation,
                    controller: _emailCtrl,
                  ),
                  const SizedBox(height: 20),
                  LoginTextField(
                    title: AppLocalizations.of(context)!.password,
                    hint: AppLocalizations.of(context)!.password,
                    isPassword: true,
                    controller: _passwordCtrl,
                    validator: emptyPasswordValidation,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: state is AuthLoading ? null : () => _logIn(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
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
                  const SizedBox(height: 20),
                  AuthTextButton(
                    onTap: state is AuthLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(AuthReset());
                            context.pushNamed('signup', extra: 'manager');
                          },
                    title: AppLocalizations.of(context)!.signUp,
                    content: AppLocalizations.of(context)!.dontHaveAccount,
                  ),
                  // const SizedBox(height: 32),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(color: Colors.grey[300], thickness: 1),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         AppLocalizations.of(context)!.or,
                  //         style: GoogleFonts.quicksand(
                  //           color: Colors.grey[500],
                  //           fontSize: 13,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Divider(color: Colors.grey[300], thickness: 1),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 32),

                  // OAuthButton(
                  //   title: AppLocalizations.of(context)!.withGoogle,
                  //   onPressed: state is AuthLoading
                  //       ? () => null
                  //       : () {
                  //           context.read<AuthBloc>().add(
                  //             GoogleSignInRequested(role: 'manager'),
                  //           );
                  //         },
                  //   imageAsset: 'assets/icons/google-icon-logo.svg',
                  // ),

                  // const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
