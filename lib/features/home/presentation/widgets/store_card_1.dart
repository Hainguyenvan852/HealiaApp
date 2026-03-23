import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class StoreCard1 extends StatelessWidget {
  const StoreCard1({super.key, required this.store, required this.onTap});
  final StoreModel store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: CachedNetworkImage(
              width: 220,
              height: 145,
              fit: BoxFit.cover,
              imageUrl: store.imageUrl,
              placeholder: (context, url){
                return Shimmer(
                    child: Container(
                      height: 130,
                      width: 230,
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                );
              },
              errorWidget: (context, url, error){
                return Center(
                  child: PhosphorIcon(
                    PhosphorIcons.imageBroken(),
                    size: 25,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: 220,
            child: Text(
              overflow: TextOverflow.ellipsis,
              store.name,
              style: GoogleFonts.quicksand(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          store.ratingNumber == 0
          ? Text('No rating yet', style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black.withValues(alpha: 0.5)
          ),)
          : Row(
              children: [
                Icon(Icons.star_rate_rounded, size: 23, color: Colors.orangeAccent,),
                RichText(
                    text: TextSpan(
                        text: store.rating.toString(),
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                        children: [
                          TextSpan(
                              text: ' (${store.ratingNumber})',
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withValues(alpha: 0.5)
                              )
                          )
                        ]
                    )
                )
              ],
          ),
          SizedBox(
            width: 220,
            child: Text(
              overflow: TextOverflow.ellipsis,
              store.address,
              style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.5)
              ),
            ),
          ),
          Text(
            store.primaryCategory,
            style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.5)
            ),
          ),
        ],
      ),
    );;
  }
}
