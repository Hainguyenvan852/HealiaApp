import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VenueSearchCard extends StatelessWidget {
  const VenueSearchCard({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        Container(
          height: 40,
          width: 40,
          child: Center(
            child: CachedNetworkImage(
              width: 220,
              height: 145,
              fit: BoxFit.cover,
              imageUrl: store.primaryImageUrl,
              placeholder: (context, url) {
                return Shimmer(
                  child: Container(
                    height: 130,
                    width: 230,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.6),
              width: 0.7,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  Text(
                    store.primaryCategory,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                  Icon(
                    Icons.fiber_manual_record,
                    size: 4,
                    color: Colors.grey.shade700,
                  ),
                  Expanded(
                    child: Text(
                      store.address,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
