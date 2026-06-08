import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class StoreDetailPageShimmer extends StatelessWidget {
  const StoreDetailPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Shimmer(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      )
                    ), 
                  ),
                  Positioned(
                    top: 60,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        context.read<StoreInfomationCubit>().clearState();
                        context.pop();
                      },
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer(
                      child: Container(
                        width: 200,
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Shimmer(
                      child: Container(
                        width: 120,
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 50,),
                  Shimmer(
                      child: Container(
                        width: 90,
                        height: 16,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 20,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Shimmer(
                      child: Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 30,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 20,),
                  Shimmer(
                      child: Container(
                        width: double.infinity,
                        height: 1.5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 30,),
                  Shimmer(
                      child: Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 30,),
                  Shimmer(
                      child: Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 20,),
                  Shimmer(
                      child: Container(
                        width: double.infinity,
                        height: 1.5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Shimmer(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(25)
                          ),
                        )
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

