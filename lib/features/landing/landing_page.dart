import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main(){
  runApp(MaterialApp(
    home: LandingPage(),
  ));
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(20),
                width: 380,
                height: 380,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAC898),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "App Name",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      "App Tagline",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const SlideButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideButton extends StatefulWidget {
  const SlideButton({super.key});

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.5, 0.0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onHorizontalDragStart: (_) {
          _animationController.forward();
        },
        onTap: () {
          _animationController.reset();
          context.go('/auth-gate');
        },
        onHorizontalDragEnd: (_) {
          _animationController.reset();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SlideTransition(
                  position: _offsetAnimation,
                  child: const Row(
                    children: [
                      Text(
                        'Slide to Start',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.amber),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}