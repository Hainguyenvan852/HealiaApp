import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LocationSearchCard extends StatelessWidget {
  const LocationSearchCard({super.key, required this.onTap, required this.iconData, required this.title, required this.iconColor, required this.backgroundColor});
  final VoidCallback onTap;
  final PhosphorIconData iconData;
  final String title;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          spacing: 15,
          children: [
            Container(
              height: 40,
              width: 40,
              child: PhosphorIcon(iconData, size: 21, color: iconColor,),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 17
              ),
            )
          ],
        ),
      ),
    );
  }
}
