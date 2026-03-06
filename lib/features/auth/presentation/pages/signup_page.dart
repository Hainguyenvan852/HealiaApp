import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/auth/presentation/widgets/signup_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  bool _isChecked = false;

  void _signUp(){
    if(signUpFormKey.currentState!.validate() && _isChecked){
      final userName = emailController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      context.read<AuthBloc>().add(UserSignedUp(email: email, password: password, userName: userName),);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<AuthBloc, OAuthState>(
      listenWhen: (previous, current) => previous != current,
        listener: (context, state){
          if(state is EmailVerificationRequired){
            context.pushNamed(
              'verify-email',
              pathParameters: {'email': state.email},
            );
          }
        },
        builder: (context, state){
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Form(
              key: signUpFormKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Thu nhỏ Logo khi bàn phím mở
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: isKeyboardOpen ? 200 : 300,
                          child: Image.asset('assets/images/logo-healio-app-2.png', width: 300,),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isKeyboardOpen ? 20 : 40,
                          child: const SizedBox(height: 40,),
                        ),
                        const Text('Register your account', style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                        ),),
                        const SizedBox(height: 30,),
                        SignupTextField(
                          hintText: 'Full name',
                          isPassword: false,
                          prefixIcon: Icons.person_outlined,
                          controller: nameController,
                          validator: emptyValidation,
                        ),
                        const SizedBox(height: 15,),
                        SignupTextField(
                          hintText: 'Email',
                          isPassword: false,
                          prefixIcon: Icons.email_outlined,
                          controller: emailController,
                          validator: emailValidation,
                        ),
                        const SizedBox(height: 15,),
                        SignupTextField(
                          hintText: 'Password',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          controller: passwordController,
                          validator: emptyValidation,
                        ),
                        const SizedBox(height: 15,),
                        SignupTextField(
                          hintText: 'Confirmed password',
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          controller: cPasswordController,
                          validator: (value){
                            return confirmPasswordValidation(value, passwordController);
                          },
                        ),
                        const SizedBox(height: 15,),
                        FormField(
                            initialValue: _isChecked,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(value == false){
                                return 'Please accept the terms and policies';
                              }
                              return null;
                            },
                            builder: (state){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: state.value,
                                        onChanged: (value){
                                          state.didChange(value);
                                          setState(() {
                                            _isChecked = value!;
                                          });
                                        },
                                        checkColor: Colors.white,
                                        activeColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 1.2,
                                        ),
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'I have read and agree to Healio\'s ',
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: 'terms of service',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                          text: ' and ',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: 'privacy policy.',
                                                              style: TextStyle(
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            )
                                                          ]
                                                      )
                                                    ]
                                                )
                                              ]
                                          ),
                                          maxLines: 2,
                                        ),
                                      )
                                    ],
                                  ),
                                  if (state.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        state.errorText!,
                                        style: TextStyle(color: ThemeData.light().colorScheme.error, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    )
                                ],
                              );
                            }
                        ),
                        const SizedBox(height: 20,),
                        FilledButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () => _signUp(),
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: Size(double.infinity, 50)
                            ),
                            child: state is AuthLoading
                                ? Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.white, size: 30))
                                : const Text('Sign up', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),)
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You already have an account?',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(width: 5,),
                            GestureDetector(
                              onTap: state is AuthLoading
                                  ? null
                                  : () => context.pop(),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        )
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
