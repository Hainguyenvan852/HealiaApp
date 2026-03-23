import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: onTap,
              child: Icon(Icons.close, color: Colors.black,),
            ),
          ],
        ),

        const SizedBox(height: 20,),
        Text(
          'Welcome back',
          style: GoogleFonts.quicksand(
              fontSize: 27,
              fontWeight: FontWeight.bold
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
      ],
    );
  }
}
