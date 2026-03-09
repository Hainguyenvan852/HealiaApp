import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: CachedNetworkImage(
            width: 220,
            height: 145,
            fit: BoxFit.cover,
            imageUrl: 'https://a.storyblok.com/f/97382/2000x1500/bed8bd4c9c/pre-and-post-massage-rituals-cover.png/m/1168x946/smart/filters:quality(65)',
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
        Row(
          children: [
            Icon(Icons.star_rate_rounded, size: 23, color: Colors.orangeAccent,),
            RichText(
                text: TextSpan(
                    text: '4.9',
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    children: [
                      TextSpan(
                          text: ' (4,170)',
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
          'Barber',
          style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5)
          ),
        ),
      ],
    );;
  }
}
