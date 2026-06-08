import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    this.onTap,
    required this.iconData,
    required this.title,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.menuButton,
    required this.content,
  });
  final VoidCallback? onTap;
  final PhosphorIconData iconData;
  final String title;
  final String content;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Widget? menuButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  spacing: 15,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: PhosphorIcon(iconData, size: 21, color: iconColor),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withValues(alpha: 0.5),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ?menuButton,
        ],
      ),
    );
  }
}
