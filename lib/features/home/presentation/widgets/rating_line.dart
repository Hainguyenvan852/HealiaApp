import 'package:flutter/material.dart';

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.rating, required this.iconSize});
  final double rating;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        double.parse(rating.toStringAsFixed(1)) > 0.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (rating == 0.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),
         
        double.parse(rating.toStringAsFixed(1)) > 1.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (rating == 1.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(rating.toStringAsFixed(1)) > 2.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (rating == 2.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(rating.toStringAsFixed(1)) > 3.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (rating == 3.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(rating.toStringAsFixed(1)) > 4.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (rating == 4.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),
      ],
    );
  }
}