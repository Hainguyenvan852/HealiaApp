import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback onTryAgain;

  const NoInternetPage({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/no-internet-icon.png', height: 100),
              const SizedBox(height: 24),

              Text(
                'No internet connection',
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "It looks like you're offline. Please check your\ninternet connection and try again.",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              OutlinedButton(
                onPressed: onTryAgain,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(color: Colors.black26),
                ),
                child: Text(
                  'Try again',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
