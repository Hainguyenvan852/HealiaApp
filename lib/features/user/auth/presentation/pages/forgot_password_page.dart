import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submitResetPasswordRequest() {
    if (_passwordKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ResetPasswordRequested(email: _passwordCtrl.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, OAuthState>(
      listenWhen: (current, previous) => current != previous,
      listener: (context, state) {
        if (state is ResetPasswordRequestSuccess) {
          SnackBarHelper.showSuccess(
            AppLocalizations.of(context)!.sendSuccessNotification,
          );
        }
        if (state is AuthError) {
          SnackBarHelper.showError(state.errorMsg);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthReset());
                context.pop();
              },
              icon: Icon(Icons.arrow_back_rounded, size: 25),
            ),
            shape: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.sendPasswordResetInstructions,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w600),
                      controller: _passwordCtrl,
                      key: _passwordKey,
                      cursorColor: Colors.black,
                      validator: emailValidation,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        hintText: AppLocalizations.of(context)!.enterEmail,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: FilledButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                      _submitResetPasswordRequest();
                    },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
                maximumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: state is AuthLoading
                  ? Center(
                      child: LoadingAnimationWidget.progressiveDots(
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.resetPassword,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        );
      },
    );
  }
}
