import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/home/data/models/store_model.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),
                Row(
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
                const SizedBox(height: 25,),
                Text(
                  'Recently viewed',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),

              ]
            )
          ),
        ),
      ),
    );
  }
}

