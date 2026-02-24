import 'package:flutter/material.dart';
import 'package:healio_app/features/auth/presentation/pages/auth_callback_handle_page.dart';
import 'package:healio_app/features/home/presentation/pages/home_page.dart';
import 'package:healio_app/features/landing/landing_page.dart';
import 'package:healio_app/features/landing/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRetryPoint extends StatelessWidget {
  const AppRetryPoint({super.key});

  Future<Widget> _decidePage() async{
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final session = Supabase.instance.client.auth.currentSession;

    if(isFirstLaunch){
      await prefs.setBool('isFirstLaunch', false);
      return const LandingPage();
    } else if(session != null){
      return const HomePage();
    } else{
      return AuthCallbackHandlePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _decidePage(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return SplashScreen();
          }

          return snapshot.data!;
        }
    );
  }

}