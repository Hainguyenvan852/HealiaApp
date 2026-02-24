import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:healio_app/features/auth/presentation/pages/signup_page.dart';
import 'package:healio_app/features/auth/presentation/widgets/login_textfield.dart';
import 'package:healio_app/features/auth/presentation/widgets/oauth_button.dart';

import '../../../landing/splash_screen.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final uiStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent
  );

  runApp(AnnotatedRegion(
    value: uiStyle,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      themeAnimationStyle: AnimationStyle(
        curve: Curves.linearToEaseOut
      ),

      theme: ThemeData(
          textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme)
      ),
      home: LoginPage(),
    ),
  ));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10,),
                    GestureDetector(
                      child: Icon(Icons.close, color: Colors.black,),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Log in with one of the following to book and manage your appointments',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 30,),
                OAuthButton(
                    title: 'With Google',
                    onPressed: (){},
                    imageAsset: 'assets/icons/google-icon-logo.svg'
                ),
                const SizedBox(height: 20,),
                OAuthButton(
                    title: 'With Facebook',
                    onPressed: (){},
                    imageAsset: 'assets/icons/facebook-logo-icon.svg'
                ),
                const SizedBox(height: 30,),
                const Row(
                  children: [
                    Flexible(
                      child: Divider(
                        height: 0.5,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                    Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
                    Flexible(
                      child: Divider(
                        height: 0.5,
                        indent: 8,
                        endIndent: 8,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                const LoginTextField(
                  title: 'Email',
                  hint: 'Email',
                  isPassword: false,
                ),
                const SizedBox(height: 20,),
                const LoginTextField(
                  title: 'Password',
                  hint: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage())),
                      child: Text('Forgot Password', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                FilledButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SplashScreen()));
                    },
                    style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(30)
                        ),
                      backgroundColor: Colors.black
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'First time here?',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupPage())),
                      child: Text(
                        'Sign up for free',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15
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
