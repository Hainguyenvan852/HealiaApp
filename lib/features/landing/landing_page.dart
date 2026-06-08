import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _lottieController1;
  late AnimationController _lottieController2;
  late AnimationController _lottieController3;
  late AnimationController _lottieController4;

  Timer? _timer;

  final int _numPages = 4;

  int _currentPage = 0;

  final List<Map<String, dynamic>> _pagesData = [];

  @override
  void initState() {
    super.initState();
    _lottieController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _lottieController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _lottieController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _lottieController4 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pagesData.addAll([
      {
        'title': 'Easy Search', //'Tìm kiếm Dễ dàng'
        'description':
            'Find spas, hair salons, nail salons,... near you.', //'Tìm spa, cắt tóc, nails... ngay gần bạn.'
        'animationPath': 'assets/animations/search-animation.json',
      },
      {
        'title': 'Complete Beauty Package', //'Làm đẹp Trọn gói'
        'description':
            'Book your nail, makeup, or tattoo appointment in an instant.', //'Đặt lịch làm nails, makeup, tattoo... trong nháy mắt.'
        'animationPath': 'assets/animations/girl-face-animation.json',
      },
      {
        'title': 'Beautiful Hair Every Day', //'Tóc Đẹp Mỗi Ngày'
        'description':
            'Haircut, shampoo, blow-dry... at trusted salons.', //'Cắt, gội, sấy... tại các salon uy tín.'
        'animationPath': 'assets/animations/hair-salon-animation.json',
      },
      {
        'title': 'Shine Brightly Now', //'Tỏa sáng Ngay'
        'description':
            'Start exploring and booking for yourself today.', //'Bắt đầu khám phá và đặt lịch cho bạn ngay hôm nay.'
        'animationPath': 'assets/animations/discovere-animation-2.json',
      },
    ]);

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _lottieController1.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _numPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 214, 36, 101),
            Color.fromARGB(255, 252, 114, 183),
            Color.fromARGB(255, 253, 208, 231),
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _numPages,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                    _restartTimer();
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildPageContent(
                        _pagesData[index],
                        _lottieController1,
                      );
                    } else if (index == 1) {
                      return _buildPageContent(
                        _pagesData[index],
                        _lottieController2,
                      );
                    } else if (index == 2) {
                      return _buildPageContent(
                        _pagesData[index],
                        _lottieController3,
                      );
                    } else {
                      return _buildPageContent(
                        _pagesData[index],
                        _lottieController4,
                      );
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _numPages,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey.shade300,
                        expansionFactor: 3,
                        spacing: 8,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 253, 208, 231),
                            Color.fromARGB(255, 252, 114, 183),
                            Color.fromARGB(255, 214, 36, 101),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.startExploring,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    Map<String, dynamic> data,
    AnimationController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            alignment: Alignment.center,
            child: Lottie.asset(
              data['animationPath'],
              controller: controller,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Lỗi Lottie: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 48),

          Text(
            data['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 36, 101),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            data['description'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Color.fromARGB(255, 214, 36, 101),
            ),
          ),
        ],
      ),
    );
  }
}
