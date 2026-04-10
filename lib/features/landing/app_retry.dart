import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/landing/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRetryPoint extends StatefulWidget {
  const AppRetryPoint({super.key});

  @override
  State<AppRetryPoint> createState() => _AppRetryPointState();
}

class _AppRetryPointState extends State<AppRetryPoint> {

  Future<Widget> _decidePage() async{
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if(isFirstLaunch){
      await prefs.setBool('isFirstLaunch', false);
      return const LandingPage();
    }
    else{
      context.go('/home');
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _decidePage(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
              body: Center(child: CircularProgressIndicator())
            );
          }

          return snapshot.data!;
        }
    );
  }
}