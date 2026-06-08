import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/user/auth/presentation/widgets/auth_text_button.dart';
import 'package:healio_app/features/user/auth/presentation/widgets/signup_textfield.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.role});
  final String role;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  bool _isChecked = false;

  void _signUp() {
    if (signUpFormKey.currentState!.validate() && _isChecked) {
      final userName = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (widget.role == 'customer') {
        context.read<AuthBloc>().add(
          UserSignedUp(
            email: email,
            password: password,
            userName: userName,
            role: 'customer',
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          UserSignedUp(
            email: email,
            password: password,
            userName: userName,
            role: 'manager',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<AuthBloc, OAuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is EmailVerificationRequired) {
          context.pushNamed(
            'verify-email',
            pathParameters: {'email': state.email},
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: widget.role == 'customer'
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Form(
            key: signUpFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    left: 20,
                    top: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isKeyboardOpen ? 200 : 300,
                        child: Image.asset(
                          'assets/images/logo-healio-app-2.png',
                          width: 300,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: isKeyboardOpen ? 20 : 40,
                        child: const SizedBox(height: 40),
                      ),
                      Text(
                        AppLocalizations.of(context)!.registerYourAccount,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SignupTextField(
                        hintText: AppLocalizations.of(context)!.fullName,
                        isPassword: false,
                        prefixIcon: Icons.person_outlined,
                        controller: nameController,
                        validator: emptyValidation,
                      ),
                      const SizedBox(height: 15),
                      SignupTextField(
                        hintText: AppLocalizations.of(context)!.email,
                        isPassword: false,
                        prefixIcon: Icons.email_outlined,
                        controller: emailController,
                        validator: emailValidation,
                      ),
                      const SizedBox(height: 15),
                      SignupTextField(
                        hintText: AppLocalizations.of(context)!.password,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        controller: passwordController,
                        validator: passwordValidation,
                      ),
                      const SizedBox(height: 15),
                      SignupTextField(
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        controller: cPasswordController,
                        validator: (value) {
                          return confirmPasswordValidation(
                            value,
                            passwordController,
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      FormField(
                        initialValue: _isChecked,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == false) {
                            return AppLocalizations.of(context)!.acceptTerms;
                          }
                          return null;
                        },
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: state.value,
                                    onChanged: (value) {
                                      state.didChange(value);
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1.2,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: AppLocalizations.of(
                                          context,
                                        )!.agreeToTerms1,
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.agreeToTerms2,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.agreeToTerms3,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.agreeToTerms4,
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color:
                                          ThemeData.light().colorScheme.error,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () => _signUp(),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: state is AuthLoading
                            ? Center(
                                child: LoadingAnimationWidget.progressiveDots(
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                      const SizedBox(height: 30),
                      if (widget.role == 'customer')
                        AuthTextButton(
                          onTap: state is AuthLoading
                              ? null
                              : () => context.pop(),
                          title: AppLocalizations.of(context)!.logIn,
                          content: AppLocalizations.of(
                            context,
                          )!.alreadyHaveAccount,
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
