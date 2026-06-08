import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onPressed, this.titleButton});
  final String title;
  final String? titleButton;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
              fontSize: 19,
              fontWeight: FontWeight.bold
          ),
        ),
        if (onPressed != null && titleButton != null)
          GestureDetector(
            onTap: onPressed,
            child: Text(
              titleButton!,
              style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurpleAccent
              ),
            ),
          )
      ],
    );
  }
}
