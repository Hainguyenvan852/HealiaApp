import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('For you', style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),),
          GestureDetector(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Icon(FontAwesomeIcons.search, color: Colors.black, size: 18,)
            ),
          )
        ],
      ),
    );
  }
}
