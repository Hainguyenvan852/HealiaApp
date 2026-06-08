import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';

class UnauthenticatedBody extends StatelessWidget {
  const UnauthenticatedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/calendar-icon.png', height: 100),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.manageAppointments,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.go('/explore');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text(
              AppLocalizations.of(context)!.search,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text(
              AppLocalizations.of(context)!.loginSignUp,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
