import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/presentation/widgets/image_slide.dart';
import 'package:healio_app/features/home/presentation/widgets/rating_line.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('vi', 'VN'),
        ],
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            return StoreDetailPage(store: StoreModel(id: 0, name: 'Beautymaster Spa', email: 'beautymaster@gmail.com', address: 'Chung cư The Emerald - CT8, Mỹ Đình', district: 'Từ Liêm', province: 'Hà Nội', introduction: 'Nằm giữa lòng Hà Nội, Beautymaster Spa mang đến cho khách hàng những trải nghiệm thư giãn tuyệt vời với các dịch vụ chăm sóc sắc đẹp chuyên biệt. Từ liệu trình Collagen 90 phút đến các liệu pháp nâng cơ và trẻ hóa làn da, mọi dịch vụ đều sử dụng sản phẩm hữu cơ, thân thiện với môi trường. Với không gian ấm cúng và đội ngũ nhân viên tận tâm, đây chính là điểm đến lý tưởng cho những ai tìm kiếm sự thư giãn và làm đẹp.', phoneNumber: '0967113893', ratingNumber: 0, imageUrl: 'https://cuscgyubgzsejppmkcif.supabase.co/storage/v1/object/public/store%20images/beauty-master-1.avif', rating: 4.5, distance: 5.3, primaryCategory: 'Spa', longitude: 1, latitude: 1),);
          }
        )
    );
  }
}

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key, required this.store});
  final StoreModel store;
  

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> with TickerProviderStateMixin{

  bool isFavorite = false;
  bool showLottie = false;
  late AnimationController _lottieController;
  late final TabController _tabController;
  final tabs = [
    'Recovery', 'Body', 'Hair'
  ];

  @override
  void initState() {
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Thời gian chạy animation
    );

    _tabController = TabController(length: 3, vsync: this);

    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          showLottie = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

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
                      child: StoreImageSlider(store: widget.store)
                    ),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black.withValues(alpha: 0.3))
                          ),
                          child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 22,),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 55,
                      right: 10,
                      child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){},
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black.withValues(alpha: 0.3))
                                  ),
                                  child: PhosphorIcon(PhosphorIcons.shareNetwork(), size: 22,),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!isFavorite) {
                                      isFavorite = true;
                                      showLottie = true;
                                      _lottieController.forward();
                                    } else {
                                      isFavorite = false;
                                      _lottieController.reverse();
                                    }
                                  });
                                },
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.black.withValues(alpha: 0.3))
                                        ),
                                      ),
                                      showLottie
                                        ? SizedBox(
                                            height: 55,
                                            width: 55,
                                            child: Lottie.asset(
                                              'assets/animations/like.json',
                                              controller: _lottieController,
                                              fit: BoxFit.cover,
                                            )
                                          )
                                          : PhosphorIcon(PhosphorIcons.heart(), size: 22),
                                    ],
                                  ),
                                ),
                              ),
                              
                            ],
                          )
                    )
                  ],
                ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Text(
                    widget.store.name,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                  const SizedBox(height: 5,),
                  widget.store.rating == 0
                  ? Text(
                    'No rating yet',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54
                    ),
                  )
                  : RatingLine(store: widget.store),
                  const SizedBox(height: 2,),
                  Row(
                    children: [
                      Text(
                        widget.store.distance.toString() + 'km',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Icon(
                        Icons.fiber_manual_record,
                        size: 5,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        widget.store.address,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    'Open until 9:00 PM',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Text(
                    'Services',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                  ),
                  const SizedBox(height: 30,),

                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    dividerHeight: 0,
                    splashFactory: NoSplash.splashFactory,
                    splashBorderRadius: BorderRadius.circular(25),
                    indicatorColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    labelPadding: EdgeInsets.zero,
                    onTap: (index) => setState(() {}),
                    tabs: tabs.map(
                      (tab) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: tabs.indexOf(tab) == _tabController.index ? Colors.black : Colors.white
                        ),
                        child: Text(
                          tab,
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: tabs.indexOf(tab) == _tabController.index ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )).toList()
                  ),

                  const SizedBox(height: 20,),
                  // TabBarView(
                  //   controller: _tabController,
                  //   children: [

                  //   ]
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}