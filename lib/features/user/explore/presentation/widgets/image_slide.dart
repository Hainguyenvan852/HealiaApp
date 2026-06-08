import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StoreImageSlider extends StatefulWidget {
  const StoreImageSlider({super.key, required this.store});
  final StoreModel store;

  @override
  State<StoreImageSlider> createState() => _StoreImageSliderState();
}

class _StoreImageSliderState extends State<StoreImageSlider> {

  // final PageController _pageController = PageController();

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: widget.store.primaryImageUrl,
                  errorWidget: (context, url, error){
                    return const Icon(FontAwesomeIcons.solidImage);
                  },
                  placeholder: (context, url){
                    return Shimmer(
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          width: 400,
                        )
                    );
                  },
                )
            // PageView.builder(
            //   controller: _pageController,
            //   itemBuilder: (BuildContext context, int index) {
            //     return CachedNetworkImage(
            //       height: 230,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //       imageUrl: widget.store.primaryImageUrl,
            //       errorWidget: (context, url, error){
            //         return const Icon(FontAwesomeIcons.solidImage);
            //       },
            //       placeholder: (context, url){
            //         return Shimmer(
            //             child: Container(
            //               color: Colors.white,
            //               height: 50,
            //               width: 400,
            //             )
            //         );
            //       },
            //     );
            //   },
            //   itemCount: 6,
            // ),
            // Positioned(
            //     bottom: 20,
            //     child: SmoothPageIndicator(
            //       controller: _pageController,
            //       count: 6,
            //       effect: ScrollingDotsEffect(
            //         dotColor: Colors.white54,
            //         activeDotColor: Colors.white,
            //         dotHeight: 7,
            //         dotWidth: 7,
            //         radius: 7,
            //         spacing: 12
            //       ),
            //     )
            // )
          ]
        ),
      ),
    );
  }
}
