import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecentLocationCard extends StatelessWidget {
  const RecentLocationCard({super.key, required this.mainText, required this.secondText, required this.onTap});
  final String mainText;
  final String secondText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        spacing: 15,
        children: [
          Container(
            height: 40,
            width: 40,
            child: PhosphorIcon(PhosphorIcons.mapPin(PhosphorIconsStyle.fill), size: 21, color: Colors.deepPurpleAccent,),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.12 ),
              shape: BoxShape.circle,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainText,
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                ),
              ),
              Text(
                secondText,
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black45
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
