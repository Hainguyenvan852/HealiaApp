import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo-healio-app.png',),
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: Color(0xFFF48FB1),
                strokeWidth: 3
              ),
            ),
          ],
        ),
      ),
    );
  }
}