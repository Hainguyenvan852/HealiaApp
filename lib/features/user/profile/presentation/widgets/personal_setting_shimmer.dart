import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PersonalSettingShimmer extends StatelessWidget {
  const PersonalSettingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildHeaderShimmer(),

        const SizedBox(height: 50),

        _buildCardShimmer(4),
        const SizedBox(height: 20),

        _buildCardShimmer(2),
        const SizedBox(height: 20),

        _buildCardShimmer(1),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderShimmer() {
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
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Shimmer(
                child: Container(
                  width: 140,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
          Shimmer(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardShimmer(int itemCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Shimmer(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Shimmer(
                  child: Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withValues(alpha: 0.4),
                    ),
                  ),
                ),

                const Spacer(),

                Shimmer(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
