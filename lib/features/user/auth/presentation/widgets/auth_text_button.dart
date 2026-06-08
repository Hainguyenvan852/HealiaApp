import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({super.key, required this.onTap, required this.title, required this.content});
  final String title;
  final String content;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          content,
          style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(width: 5,),
        GestureDetector(
          onTap: onTap,
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
