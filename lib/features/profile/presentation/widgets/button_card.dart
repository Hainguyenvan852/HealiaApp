import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/profile/data/models/profile_button_model.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, required this.buttonList});
  final List<ProfileButtonModel> buttonList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.grey.withValues(alpha: 0.5),
              width: 0.8
          )
      ),
      child: Column(
        children: buttonList.map(
          (button) => FilledButton.icon(
            onPressed: button.onPress,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.only(),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            icon: button.icon,
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  button.title,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
              ],
            )
          ),
        ).toList()
      ),
    );
  }
}
