import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/presentation/widgets/image_slide.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StoreDetailPage extends StatelessWidget {
  const StoreDetailPage({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 320,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 60,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black.withValues(alpha: 0.3))
                      ),
                      child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25,),
                    ),
                  ),
                  Positioned.fill(
                    child: StoreImageSlider(store: store)
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}