import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecentSearchCard extends StatelessWidget {
  const RecentSearchCard({super.key, required this.category, required this.location, required this.time, this.onTap, required this.date});
  final String category;
  final String location;
  final String date;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          spacing: 15,
          children: [
            Container(
              height: 40,
              width: 40,
              child: PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 21, color: Colors.deepPurpleAccent,),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.12 ),
                shape: BoxShape.circle,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      location,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black45
                      ),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 4,
                      color: Colors.black45,
                    ),
                    Text(
                      time,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black45
                      ),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 4,
                      color: Colors.black45,
                    ),
                    Text(
                      date,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black45
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
