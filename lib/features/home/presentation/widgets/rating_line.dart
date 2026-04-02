import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.store, required this.iconSize});
  final StoreModel store;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        double.parse(store.rating.toStringAsFixed(1)) > 0.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (store.rating == 0.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),
         
        double.parse(store.rating.toStringAsFixed(1)) > 1.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (store.rating == 1.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 2.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (store.rating == 2.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 3.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (store.rating == 3.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 4.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: iconSize,)
          : (store.rating == 4.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: iconSize,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: iconSize,)
            ),
      ],
    );
  }
}