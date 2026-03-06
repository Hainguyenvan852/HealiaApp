import 'package:flutter/material.dart';
import 'package:healio_app/features/landing/splash_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {



  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}


