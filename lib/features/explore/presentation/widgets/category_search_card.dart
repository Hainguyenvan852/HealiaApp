import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/screen_helper.dart';

class CategorySearchCard extends StatelessWidget {
  const CategorySearchCard({super.key, required this.title, required this.prefixIcon, required this.onTap});
  final String title;
  final Widget prefixIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenHelper.getScreenSize(context).width - 40,
        color: Colors.transparent,
        child: Row(
          spacing: 15,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Center(child: prefixIcon),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.6),
                  width: 0.7,
                ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
