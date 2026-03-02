import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('For you', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),),
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey
                          )
                      ),
                      child: Icon(FontAwesomeIcons.search, color: Colors.black, size: 18,)
                  )
                ],
              ),
              const SizedBox(height: 40,),
              Shimmer(
                  child: Container(
                    width: 230,
                    height: 12,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)
                    ),
                  )
              ),
              const SizedBox(height: 10,),
              Shimmer(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40,),
                          Container(
                            width: 60,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25)
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            width: 180,
                            height: 11,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25)
                            ),
                          ),
                          const SizedBox(height: 50,),
                          Container(
                            width: 110,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25)
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            width: 130,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25)
                            ),
                          ),
                          const SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 120,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25)
                                ),
                              ),
                              Container(
                                width: 55,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25)
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25,)
                        ],
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 50,),
              Shimmer(
                  child: Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)
                    ),
                  )
              ),
              const SizedBox(height: 15,),
              Shimmer(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            Container(
                              width: 60,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              width: 180,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              width: 110,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                            ),
                            const SizedBox(height: 50,),
                            Container(
                              width: 130,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                            ),
                            const SizedBox(height: 25,)
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 50,),
              Shimmer(
                  child: Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25)
                    ),
                  )
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: 150,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

