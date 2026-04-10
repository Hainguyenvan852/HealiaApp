import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchBarShimmer extends StatelessWidget {
  const SearchBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: (){},
            icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20,),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer(
                      child: Container(
                        width: 100,
                        height: 8,
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
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                ],
              )
          ),
          IconButton.outlined(
            onPressed: (){
            },
            icon: Icon(FontAwesomeIcons.list, size: 20,),
          ),
        ],
      ),
    );
  }
}

class SlidingUpShimmer extends StatefulWidget {
  const SlidingUpShimmer({super.key, required this.panelCtrl, required this.panelPositionNotifier});
  final PanelController panelCtrl;
  final ValueNotifier<double> panelPositionNotifier;

  @override
  State<SlidingUpShimmer> createState() => _SlidingUpShimmerState();
}

class _SlidingUpShimmerState extends State<SlidingUpShimmer> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: 480,
      minHeight: 80,
      controller: widget.panelCtrl,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      defaultPanelState: PanelState.OPEN,
      onPanelSlide: (double pos) {
        setState(() {
          widget.panelPositionNotifier.value = pos;
        });
      },
      header: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Shimmer(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(25)
                  ),
                )
            ),
            const SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Shimmer(
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(width: 10,),
                  Shimmer(
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(width: 10,),
                  Shimmer(
                      child: Container(
                        width: 110,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                  const SizedBox(width: 10,),
                  Shimmer(
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25)
                        ),
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      panelBuilder: (ScrollController scrollController){
        return StoreListShimmer(controller: scrollController);
      },
    );
  }
}

class StoreListShimmer extends StatelessWidget {
  const StoreListShimmer({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 15, right: 15),
        child: CustomScrollView(
          controller: controller,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 10,),
            ),
            SliverToBoxAdapter(
              child: Shimmer(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        shape: BoxShape.circle
                    ),
                  )
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            SliverList.separated(
              itemCount: 2,
              itemBuilder: (context, i){
                return Column(
                  children: [
                    Shimmer(
                        child: Container(
                          width: double.infinity,
                          height: 210,
                          decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        )
                    ),
                    const SizedBox(height: 25,),
                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Shimmer(
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              )
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Shimmer(
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer(
                            child: Container(
                              width: 130,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            )
                        ),
                        const SizedBox()
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 70,);
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
          ],
        )
    );
  }
}

