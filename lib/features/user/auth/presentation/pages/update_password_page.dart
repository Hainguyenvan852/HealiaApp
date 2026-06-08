import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_info_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../widgets/custom_textfield.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        UpdatePasswordRequested(newPassword: _newPasswordCtrl.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, OAuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBarHelper.showError(state.errorMsg);
        }
        if (state is UpdatePasswordSuccess) {
          SnackBarHelper.showSuccess(
            AppLocalizations.of(context)!.passwordUpdateSuccess,
          );
          context.pop();
        }
      },
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.changePassword,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.pleaseEnterNewPassword,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black45,
                      ),
                    ),
                    BlocBuilder<UserInfoCubit, UserInfoState>(
                      builder: (context, userState) {
                        if (userState.isLoading) {
                          return Shimmer(
                            child: Text(
                              'Loading...',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          );
                        }
                        return Text(
                          userState.user?.email ?? '',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Text(
                      AppLocalizations.of(context)!.enterCurrentPassword,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isPassword: true,
                      controller: _currentPasswordCtrl,
                      isFinalField: false,
                      validator: emptyPasswordValidation,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      AppLocalizations.of(context)!.enterNewPassword,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isPassword: true,
                      controller: _newPasswordCtrl,
                      isFinalField: false,
                      validator: passwordValidation,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      AppLocalizations.of(context)!.confirmNewPassword,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      isPassword: true,
                      controller: _confirmPasswordCtrl,
                      isFinalField: true,
                      validator: (value) =>
                          confirmPasswordValidation(value, _newPasswordCtrl),
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: authState is AuthLoading
                          ? null
                          : () => _submitRequest(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.submit,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(
                          context,
                        )!.forgotPasswordOption1,
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(
                              context,
                            )!.forgotPasswordOption2,
                            style: TextStyle(color: Color(0xFF6236FF)),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
