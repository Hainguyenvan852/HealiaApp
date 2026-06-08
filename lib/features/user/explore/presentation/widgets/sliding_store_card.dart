import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/l10n/app_localizations.dart';

import 'image_slide.dart';

class SlidingStoreCard extends StatelessWidget {
  const SlidingStoreCard({
    super.key,
    required this.onClose,
    required this.store,
    required this.onTap
  });
  final VoidCallback onClose;
  final StoreModel store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            StoreImageSlider(store: store),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onClose,
                child: Icon(Icons.cancel, size: 25, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      store.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      if(store.distance != null)
                        Text(
                          store.distance! > 5
                              ? '> 5 km'
                              : '${store.distance!.toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if(store.distance != null)
                        Icon(
                          Icons.fiber_manual_record,
                          size: 5,
                          color: Colors.grey.shade700,
                        ),
                      Text(
                        store.address,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              right: 15,
              child: store.ratingNumber == 0
                  ? Text(
                      AppLocalizations.of(context)!.noRatingYet,
                      style: TextStyle(color: Colors.grey.shade700),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 5,
                      children: [
                        const SizedBox(width: 115),
                        Icon(
                          FontAwesomeIcons.solidStar,
                          color: Colors.orange,
                          size: 14,
                        ),
                        Text(
                          store.rating.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          store.ratingNumber.toString(),
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
