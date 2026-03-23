import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HeaderShimmer extends StatelessWidget {
  const HeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(
                  child: Container(
                      width: 200,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.4),
                      )
                  )
              ),
              const SizedBox(height: 10,),
              Shimmer(
                  child: Container(
                      width: 140,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.4),
                      )
                  )
              ),
            ],
          ),
          Shimmer(
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      shape: BoxShape.circle
                  )
              )
          )
        ],
      ),
    );
  }
}
