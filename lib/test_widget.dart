import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';
import 'package:healio_app/features/home/data/models/review_model.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';
import 'package:healio_app/features/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/home/presentation/widgets/category_tabbar_view.dart';
import 'package:healio_app/features/home/presentation/widgets/image_slide.dart';
import 'package:healio_app/features/home/presentation/widgets/rating_line.dart';
import 'package:healio_app/features/home/presentation/widgets/store_card_1.dart';
import 'package:healio_app/features/home/presentation/widgets/store_horizontal_list.dart';
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  const uiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,

    systemNavigationBarContrastEnforced: false,

    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  );

  runApp(AnnotatedRegion<SystemUiOverlayStyle>(value: uiStyle, child: MyApp()));
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
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      scaffoldMessengerKey: SnackBarHelper.messengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          return StoreDetailPage(
            store: StoreModel(
              id: 0,
              name: 'Beautymaster Spa',
              email: 'beautymaster@gmail.com',
              address: 'Chung cư The Emerald - CT8, Mỹ Đình',
              district: 'Từ Liêm',
              province: 'Hà Nội',
              introduction:
                  'Nằm giữa lòng Hà Nội, Beautymaster Spa mang đến cho khách hàng những trải nghiệm thư giãn tuyệt vời với các dịch vụ chăm sóc sắc đẹp chuyên biệt. Từ liệu trình Collagen 90 phút đến các liệu pháp nâng cơ và trẻ hóa làn da, mọi dịch vụ đều sử dụng sản phẩm hữu cơ, thân thiện với môi trường. Với không gian ấm cúng và đội ngũ nhân viên tận tâm, đây chính là điểm đến lý tưởng cho những ai tìm kiếm sự thư giãn và làm đẹp.',
              phoneNumber: '0967113893',
              ratingNumber: 0,
              imageUrl:
                  'https://cuscgyubgzsejppmkcif.supabase.co/storage/v1/object/public/store%20images/beauty-master-1.avif',
              rating: 4.5,
              distance: 5.3,
              primaryCategory: 'Spa',
              longitude: 105.79552386382404,
              latitude: 21.01015465538361,
            ),
          );
        },
      ),
    );
  }
}

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key, required this.store});
  final StoreModel store;

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage>
    with TickerProviderStateMixin {
  bool isFavorite = false;
  bool showLottie = false;
  late AnimationController _lottieController;

  final categories = [
    CategoryModel(
      id: 0,
      name: 'Recovery',
      description: '',
      storeId: 1,
      services: [
        ServiceModel(
          id: 1,
          name: 'Tiêm trẻ hóa, đầy sẹo Collagen Linerase 1',
          description: '',
          duration: 60,
          price: 12990000,
          priceType: 'fix',
          categoryId: 0,
          treatmentId: 0,
        ),
        ServiceModel(
          id: 2,
          name: 'Tiêm trẻ hóa Collagen Linerase 2',
          description: '',
          duration: 60,
          price: 2000000,
          priceType: 'from',
          categoryId: 0,
          treatmentId: 0,
        ),
      ],
    ),
    CategoryModel(
      id: 1,
      name: 'Hair',
      description: '',
      storeId: 1,
      services: [
        ServiceModel(
          id: 1,
          name: 'Dưỡng tóc',
          description: '',
          duration: 60,
          price: 12990000,
          priceType: 'fix',
          categoryId: 0,
          treatmentId: 0,
        ),
        ServiceModel(
          id: 2,
          name: 'Gội đầu massage',
          description: '',
          duration: 90,
          price: 2000000,
          priceType: 'from',
          categoryId: 0,
          treatmentId: 0,
        ),
      ],
    ),
    CategoryModel(id: 2, name: 'Body', description: '', storeId: 1),
  ];

  final openingTimes = [
    StoreWorkingHourModel(
      id: 0,
      dayOfWeek: 2,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 1,
      dayOfWeek: 3,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 2,
      dayOfWeek: 4,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 3,
      dayOfWeek: 5,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 4,
      dayOfWeek: 6,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 5,
      dayOfWeek: 7,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: false,
      storeId: 1,
    ),
    StoreWorkingHourModel(
      id: 6,
      dayOfWeek: 8,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0),
      isDayOff: true,
      storeId: 1,
    ),
  ];

  @override
  void initState() {
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Thời gian chạy animation
    );

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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            stretch: true,
            pinned: true,
            backgroundColor: Colors.white,
            leadingWidth: 50,
            scrolledUnderElevation: 0,
            leading: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 22),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: PhosphorIcon(PhosphorIcons.shareNetwork(), size: 22),
                ),
              ),
              const SizedBox(width: 5),
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
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
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
                              ),
                            )
                          : PhosphorIcon(PhosphorIcons.heart(), size: 22),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;
                final collapsedHeight =
                    MediaQuery.of(context).padding.top + kToolbarHeight + 50;
                final isCollapsed = top <= collapsedHeight;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        widget.store.name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  // Hình ảnh nền sẽ tự động bị ẩn/che đi khi cuộn lên nhờ FlexibleSpaceBar
                  background: StoreImageSlider(store: widget.store),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoreHeader(store: widget.store),
                  BuildCategoryList(categories: categories),
                  BuildReviewList(reviews: [], store: widget.store),
                  BuildStoreIntro(store: widget.store),
                  const SizedBox(height: 30),
                  BuildOpenTime(times: openingTimes),
                  const SizedBox(height: 30),
                  BuildAddInformation(store: widget.store),
                  const SizedBox(height: 50),
                  Text(
                    'Other locations',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StoreHorizontalList(stores: [widget.store, widget.store]),
                  const SizedBox(height: 30),
                  Text(
                    'Venues nearby',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StoreHorizontalList(stores: [widget.store, widget.store]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStoreHeader({required StoreModel store}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Text(
        store.name,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      const SizedBox(height: 5),
      store.rating == 0
          ? Text(
              'No rating yet',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black54,
              ),
            )
          : Row(
              children: [
                Text(
                  store.rating.toStringAsFixed(1),
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                RatingLine(store: store, iconSize: 20),
                const SizedBox(width: 5),
                Text(
                  '(${store.ratingNumber.toString()})',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
      const SizedBox(height: 2),
      Row(
        children: [
          Text(
            store.distance.toString() + 'km',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 5),
          Icon(Icons.fiber_manual_record, size: 5, color: Colors.black45),
          const SizedBox(width: 5),
          Text(
            store.address,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Text(
        'Open until 9:00 PM',
        style: GoogleFonts.quicksand(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

class BuildCategoryList extends StatefulWidget {
  const BuildCategoryList({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  State<BuildCategoryList> createState() => _BuildCategoryListState();
}

class _BuildCategoryListState extends State<BuildCategoryList>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'Services',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 30),

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
          tabs: widget.categories
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        widget.categories.indexOf(item) == _tabController.index
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Text(
                    item.name,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color:
                          widget.categories.indexOf(item) ==
                              _tabController.index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 30),
        CategoryTabBarView(
          services: widget.categories[_tabController.index].services,
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'See all',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildReviewList extends StatefulWidget {
  const BuildReviewList({
    super.key,
    required this.reviews,
    required this.store,
  });

  final List<ReviewModel> reviews;
  final StoreModel store;

  @override
  State<BuildReviewList> createState() => _BuildReviewListState();
}

class _BuildReviewListState extends State<BuildReviewList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text(
          'Reviews',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        RatingLine(store: widget.store, iconSize: 40),
        const SizedBox(height: 10),
        Text(
          widget.store.rating.toString() + ' (${widget.store.ratingNumber})',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, color: Colors.black.withValues(alpha: 0.15)),
        ListView.separated(
          padding: EdgeInsets.only(top: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl:
                            'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Center(
                            child: Icon(Icons.error, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lại Thanh H',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Mon, Sep 11. 2023 at 9:44 PM',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RatingLine(store: widget.store, iconSize: 20),
                const SizedBox(height: 10),
                Text(
                  'Great',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 30);
          },
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'See all',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildStoreIntro extends StatefulWidget {
  const BuildStoreIntro({super.key, required this.store});
  final StoreModel store;

  @override
  State<BuildStoreIntro> createState() => _BuildStoreIntroState();
}

class _BuildStoreIntroState extends State<BuildStoreIntro> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'About',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        !isReadMore
            ? Text(
                '\"${widget.store.introduction}\"',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black,
                ),
              )
            : Text(
                '\"${widget.store.introduction}\"',
                textAlign: TextAlign.justify,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
        !isReadMore
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isReadMore = true;
                  });
                },
                child: Text(
                  'Read more',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class BuildOpenTime extends StatelessWidget {
  const BuildOpenTime({super.key, required this.times});
  final List<StoreWorkingHourModel> times;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening times',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: times.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 18,
                      color: times[index].isDayOff
                          ? Colors.black.withValues(alpha: 0.15)
                          : const Color.fromARGB(255, 93, 214, 97),
                    ),
                    Text(
                      DateTimeHelper.intToDayOfWeek(times[index].dayOfWeek),
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateTimeHelper.transformTime24To12(
                        times[index].startTime.hour,
                        times[index].startTime.minute,
                      ) +
                      ' - ' +
                      DateTimeHelper.transformTime24To12(
                        times[index].endTime.hour,
                        times[index].endTime.minute,
                      ),
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 15);
          },
        ),
      ],
    );
  }
}

class BuildAddInformation extends StatelessWidget {
  const BuildAddInformation({super.key, required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final tileKey = dotenv.env['GOONG_MAP_TILE_KEY'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional information',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Icon(Icons.check_rounded, size: 20),
            Text(
              'Instant confirmation',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 230, // Chiều cao của Card
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: MapLibreMap(
                    styleString:
                        "https://tiles.goong.io/assets/goong_map_web.json?api_key=$tileKey",
                    initialCameraPosition: CameraPosition(
                      target: LatLng(store.latitude, store.longitude),
                      zoom: 13.0,
                    ),
                    compassEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                  ),
                ),

                CustomPaint(
                  size: const Size(40, 50),
                  painter: RatingMarkerPainter(
                    rating: store.rating.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          store.address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Get directions',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class RatingMarkerPainter extends CustomPainter {
  final String rating;

  RatingMarkerPainter({required this.rating});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. CẤU HÌNH KÍCH THƯỚC
    const double width = 80 / 2;
    const double height = 50 / 2;
    const double tailHeight = 15 / 2;
    const double tailWidth = 18 / 2;
    const double cornerRadius = 25.0 / 2;

    const double shadowBlur = 8.0 / 2;
    const double shadowOffset = 5.0 / 2;

    // Dịch bút vẽ vào trong để chừa lề cho bóng đổ
    canvas.translate(shadowBlur, shadowBlur);

    // 2. KHỞI TẠO BÚT VẼ (Đã đổi thành nền Đen)
    final Paint mainPaint = Paint()..color = Colors.black;

    // Bút vẽ bóng đổ
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // 3. VẼ ĐƯỜNG BAO (PATH)
    final Path path = Path();
    path.moveTo(cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(
      const Offset(width, cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(
      const Offset(width - cornerRadius, height),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(width / 2 + tailWidth / 2, height);
    path.lineTo(width / 2, height + tailHeight); // Mũi nhọn đuôi
    path.lineTo(width / 2 - tailWidth / 2, height);
    path.lineTo(cornerRadius, height);
    path.arcToPoint(
      const Offset(0, height - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      const Offset(cornerRadius, 0),
      radius: const Radius.circular(cornerRadius),
    );
    path.close();

    // 4. THỰC HIỆN VẼ
    canvas.drawPath(path.shift(const Offset(0, shadowOffset)), shadowPaint);
    canvas.drawPath(path, mainPaint);

    // 5. VẼ CHỮ (Đã đổi thành chữ Trắng)
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: rating,
        style: const TextStyle(
          color: Colors.white, // Chữ màu trắng
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Căn giữa chữ
    final double textX = (width - textPainter.width) / 2;
    final double textY = (height - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Nếu điểm đánh giá thay đổi thì mới cần vẽ lại
    if (oldDelegate is RatingMarkerPainter) {
      return oldDelegate.rating != rating;
    }
    return false;
  }
}

class StoreHorizontalList extends StatelessWidget {
  const StoreHorizontalList({super.key, required this.stores});
  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return StoreCard1(store: stores[index], onTap: () {
              },);
            },
            separatorBuilder:(context, index){
              return SizedBox(width: 15,);
            },
            itemCount: stores.length
        ),
      );
  }
}
