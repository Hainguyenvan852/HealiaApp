import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goong Sample',
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
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
                        icon: Icon(FontAwesomeIcons.search, size: 20,),
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
                                        color: Colors.grey.withOpacity(0.2),
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
                                        color: Colors.grey.withOpacity(0.2),
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
                ),
              ),
              const SizedBox(height: 200,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12,),
                      Shimmer(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
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
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            Shimmer(
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            Shimmer(
                                child: Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            Shimmer(
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Shimmer(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle
                            ),
                          )
                      ),
                      const SizedBox(height: 25,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Shimmer(
                            child: Container(
                              width: double.infinity,
                              height: 210,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            )
                        ),
                      ),
                      const SizedBox(height: 25,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Shimmer(
                                  child: Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
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
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer(
                                child: Container(
                                  width: 130,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                )
                            ),
                            const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(height: 45,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Shimmer(
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            )
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

