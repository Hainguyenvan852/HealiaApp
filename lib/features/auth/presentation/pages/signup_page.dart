import 'package:flutter/material.dart';
import 'package:healio_app/features/auth/presentation/widgets/signup_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
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
                const SizedBox(height: 15,),
                SignupTextField(hintText: 'Full name', isPassword: false, prefixIcon: Icons.person_outlined,),
                const SizedBox(height: 12,),
                SignupTextField(hintText: 'Email', isPassword: false, prefixIcon: Icons.email_outlined,),
                const SizedBox(height: 12,),
                SignupTextField(hintText: 'Password', isPassword: true, prefixIcon: Icons.lock_outline, ),
                const SizedBox(height: 12,),
                SignupTextField(hintText: 'Confirmed password', isPassword: true, prefixIcon: Icons.lock_outline,),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    Checkbox(
                        value: _isChecked,
                        onChanged: (value){
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      checkColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)
                      ),
                      side: BorderSide(
                        color: Colors.pinkAccent,
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
                                color: Colors.pinkAccent,
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
                                          color: Colors.pinkAccent,
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
                const SizedBox(height: 20,),
                FilledButton(
                    onPressed: (){},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      minimumSize: Size(double.infinity, 50)
                    ),
                    child: const Text('Sign up')
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
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Sign in now',
                        style: TextStyle(
                            color: Colors.pinkAccent,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
