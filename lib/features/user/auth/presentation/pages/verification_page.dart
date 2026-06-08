import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/auth/domain/usecases/sign_out_usecase.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/utils/snackbar_helper.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final pinputFocusNode = FocusNode();
  final GlobalKey<FormState> pinputKey = GlobalKey<FormState>();
  final TextEditingController pinputController = TextEditingController();

  void _verify() {
    pinputFocusNode.unfocus();
    if (pinputKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        VerifyEmailRequest(
          email: widget.email,
          token: pinputController.text.trim(),
        ),
      );
    }
  }

  void _resendToken() {
    context.read<AuthBloc>().add(ResendTokenRequest(email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, OAuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          await inj<SignOutUseCase>().call();
          SnackBarHelper.showSuccess(
            'Account created successfully. Please login to continue',
          );
          context.go('/home');
        }
        if (state is ResendVerificationTokenSuccess) {
          SnackBarHelper.showSuccess(
            'We have sent a new verification code to your email',
          );
        }
        if (state is AuthError) {
          if (state.errorMsg.toString().toLowerCase().contains('invalid')) {
            SnackBarHelper.showError(
              "Your verification code is invalid or has expired. Please click Resend Code to get a new one",
            );
          } else {
            SnackBarHelper.showError(state.errorMsg);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                      context.read<AuthBloc>().add(AuthReset());
                      context.pop();
                    },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.emailVerification,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.enterVerificationCode +
                      '${widget.email}',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 70),
                _buildPinput(
                  pinputFocusNode: pinputFocusNode,
                  piputKey: pinputKey,
                  controller: pinputController,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.didNotReceiveCode,
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _resendToken(),
                      child: Text(
                        AppLocalizations.of(context)!.resendCode,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: state is AuthLoading ? null : () => _verify(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: state is AuthLoading
                        ? Center(
                            child: LoadingAnimationWidget.progressiveDots(
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.verifyAccount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPinput({
    required FocusNode pinputFocusNode,
    required GlobalKey<FormState> piputKey,
    required TextEditingController controller,
  }) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(202, 204, 208, 1.0),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(103, 173, 239, 1.0), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Center(
      child: Form(
        key: piputKey,
        child: Pinput(
          focusNode: pinputFocusNode,
          length: 6,
          controller: controller,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.red,
          ),
          validator: (s) {
            if (s != null && s.length < 6) {
              return AppLocalizations.of(context)!.enterFullCode;
            } else {
              return null;
            }
          },
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) => print(pin),
        ),
      ),
    );
  }
}
