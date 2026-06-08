import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
          Text(AppLocalizations.of(context)!.forYou, style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                shape: BoxShape.circle
              ),
              child: PhosphorIcon(PhosphorIcons.magnifyingGlass(), color: Colors.black, size: 24,)
            )
          )
        ],
      ),
    );
  }
}
