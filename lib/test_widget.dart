import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/presentation/widgets/store_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

void main() {
  const uiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,

    systemNavigationBarContrastEnforced: false,

    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  );

  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
      value: uiStyle,
      child: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    super.dispose();
  }
  
  List<StoreModel> stores = [
    StoreModel(id: '0', name: 'Beautymaster Spa', email: '', address: 'CT8 E2, Ngõ 180 Đường Đình Thôn', ward: 'Mỹ Đình 1', district: 'Từ Liêm', city: 'Hà Nội', country: 'Viet Nam', introduction: '', managerId: '', phoneNumber: '', isActive: true, latitude: '', longitude: ''),
    StoreModel(id: '1', name: 'Dao\'s Care Spa - Ba Đình', email: '', address: '351 Hoàng Hoa Thám', ward: 'Ngọc Hồ', district: 'Ba Đình', city: 'Hà Nội', country: 'Viet Nam', introduction: '', managerId: '', phoneNumber: '', isActive: true, latitude: '', longitude: ''),
    StoreModel(id: '2', name: 'Lá Spa 65 - Gội Đầu Dưỡng Sinh Massage', email: '', address: '65 Hàng Cót, Phố Cổ Hà Nội', ward: 'Hàng Mã', district: 'Hoàn Kiếm', city: 'Hà Nội', country: 'Viet Nam', introduction: '', managerId: '', phoneNumber: '', isActive: true, latitude: '', longitude: ''),
    StoreModel(id: '3', name: 'Nu Clinic', email: '', address: '95 Phố Nguyễn Đình Thi', ward: 'Thụy Khuê', district: 'Tây Hồ', city: 'Hà Nội', country: 'Viet Nam', introduction: '', managerId: '', phoneNumber: '', isActive: true, latitude: '', longitude: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('For you', style: GoogleFonts.quicksand(
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
                ),
                const SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Recently viewed',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return StoreCard(store: stores[index]);
                        },
                        separatorBuilder:(context, index){
                          return SizedBox(width: 10,);
                        },
                        itemCount: stores.length
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Recommended',
                    style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return StoreCard(store: stores[index]);
                        },
                        separatorBuilder:(context, index){
                          return SizedBox(width: 10,);
                        },
                        itemCount: stores.length
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'New to Healia',
                    style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return StoreCard(store: stores[index]);
                        },
                        separatorBuilder:(context, index){
                          return SizedBox(width: 10,);
                        },
                        itemCount: stores.length
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Trending',
                    style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return StoreCard(store: stores[index]);
                        },
                        separatorBuilder:(context, index){
                          return SizedBox(width: 10,);
                        },
                        itemCount: stores.length
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Explore',
                        style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'See all',
                          style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            color: Colors.deepPurpleAccent
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2,
                      mainAxisExtent: 120
                    ),
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Positioned.fill(
                            child: GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.asset('assets/images/hair-salon-banner.jpeg', fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 15,
                            bottom: 15,
                            child: Text(
                              'Hair salons',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          )
                        ]
                      ),
                      Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset('assets/images/barber-banner.jpg', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              bottom: 15,
                              child: Text(
                                'Barbers',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ]
                      ),
                      Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset('assets/images/nail-banner.jpg', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              bottom: 15,
                              child: Text(
                                'Nails',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ]
                      ),
                      Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset('assets/images/massage-banner.png', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              bottom: 15,
                              child: Text(
                                'Massage',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ]
                      ),
                      Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset('assets/images/medspa-banner.webp', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              bottom: 15,
                              child: Text(
                                'Medspa',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ]
                      ),
                      Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset('assets/images/spa-banner.webp', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 15,
                              bottom: 15,
                              child: Text(
                                'Spa & sauna',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ]
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top categories',
                        style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'See all',
                          style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurpleAccent
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          crossAxisCount: 3,
                          mainAxisExtent: 150
                      ),
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/aesthetic.png', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Aesthetics',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/barbering.png', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Barbering',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/body.png', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Body',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/hair-and-styling.webp', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: 90,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                'Hair and styling',
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/makeup.jpg', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Makeup',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/massage.jpg', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Massage',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/nail.jpeg', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Nail',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/spa.png', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: 90,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                'Spa and sauna',
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('assets/images/tattoo.png', fit: BoxFit.cover, height: 90, width: 90,),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              'Tattoo',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ]
                  )
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}

