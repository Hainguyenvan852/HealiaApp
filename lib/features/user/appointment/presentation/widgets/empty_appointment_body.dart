import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';

class EmptyAppointmentBody extends StatelessWidget {
  const EmptyAppointmentBody({super.key});

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
          Image.asset('assets/icons/calendar-icon.png', height: 80),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.noAppointments,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.noAppointmentsMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          OutlinedButton(
            onPressed: () {
              context.go('/explore');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
            ),
            child: Text(
              AppLocalizations.of(context)!.search,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
