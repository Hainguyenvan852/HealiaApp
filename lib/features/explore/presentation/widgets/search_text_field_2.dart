import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextField2 extends StatelessWidget {
  const SearchTextField2({super.key, required this.content, this.onTap, required this.iconWidget, this.secondContent});
  final String content;
  final String? secondContent;
  final Widget iconWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Colors.black.withValues(alpha: 0.3)
            )
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            iconWidget,
            const SizedBox(width: 15,),
            Text(
              content,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 17
              ),
            ),
            if(secondContent != null && secondContent!.isNotEmpty)
              const SizedBox(width: 5,),
            if(secondContent != null && secondContent!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.fiber_manual_record,
                  size: 5,
                  color: Colors.black,
                ),
              ),
            if(secondContent != null && secondContent!.isNotEmpty)
              const SizedBox(width: 5,),
            if(secondContent != null && secondContent!.isNotEmpty)
              Text(
                secondContent!,
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                ),
              ),
          ],
        ),
      ),
    );
  }
}
