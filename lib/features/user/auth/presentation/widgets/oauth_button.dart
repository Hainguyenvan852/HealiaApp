import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OAuthButton extends StatelessWidget {
  final String title;
  final String imageAsset;
  final VoidCallback onPressed;
  const OAuthButton({super.key, required this.title, required this.onPressed, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onPressed(),
      icon: SvgPicture.asset(imageAsset, height: 24,),
      label: Text(title, style: TextStyle(
          fontWeight: FontWeight.w600
      ),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: Size(double.infinity, 60),
      ),
    );
  }
}
