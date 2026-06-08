import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class StoreImageSlider extends StatefulWidget {
  const StoreImageSlider({super.key, required this.images});
  final List<String> images;

  @override
  State<StoreImageSlider> createState() => _StoreImageSliderState();
}

class _StoreImageSliderState extends State<StoreImageSlider> {

  final PageController _pageController = PageController();
  int currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index + 1;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: widget.images[index],
              errorWidget: (context, url, error){
                return const Icon(FontAwesomeIcons.solidImage);
              },
              placeholder: (context, url){
                return Shimmer(
                    child: Container(
                      color: Colors.white,
                      height: 230,
                      width: double.infinity,
                    )
                );
              },
            );
          },
          itemCount: widget.images.length,
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$currentPage/${widget.images.length}',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
              ),
            )
        )
      ]
    );
  }
}
