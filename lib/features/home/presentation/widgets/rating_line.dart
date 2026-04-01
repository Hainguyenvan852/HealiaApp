import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          store.rating.toStringAsFixed(1),
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black
          ),
        ),
        const SizedBox(width: 5,),

        double.parse(store.rating.toStringAsFixed(1)) > 0.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20,)
          : (store.rating == 0.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: 20,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: 20,)
            ),
         
        double.parse(store.rating.toStringAsFixed(1)) > 1.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20,)
          : (store.rating == 1.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: 20,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: 20,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 2.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20,)
          : (store.rating == 2.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: 20,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: 20,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 3.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20,)
          : (store.rating == 3.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: 20,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: 20,)
            ),

        double.parse(store.rating.toStringAsFixed(1)) > 4.5
          ? Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20,)
          : (store.rating == 4.5
              ? Icon(Icons.star_half_rounded, color: Colors.orangeAccent, size: 20,)
              : Icon(Icons.star_outline_rounded, color: Colors.orangeAccent, size: 20,)
            ),
            
        const SizedBox(width: 5,),
        Text(
            '(${store.ratingNumber.toString()})',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.deepPurpleAccent
            ),
        ),
      ],
    );
  }
}