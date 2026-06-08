import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/manager/options/presentation/pages/business_detail_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/business_location_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/business_schedule_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/store_pictures_page.dart';
import '../../../../../../l10n/app_localizations.dart';

class BusinessSetupPage extends StatelessWidget {
  const BusinessSetupPage({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.businessSetup,
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    title: AppLocalizations.of(context)!.businessDetails,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessDetailsPage(),
                      ),
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

                  _buildMenuItem(
                    title: AppLocalizations.of(context)!.locations,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationsPage()),
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

                  _buildMenuItem(
                    title: AppLocalizations.of(context)!.schedules,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessSchedulePage(),
                      ),
                    ),
                  ),

                  if (isActive == true) ...[
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade100,
                    ),
                    _buildMenuItem(
                      title: AppLocalizations.of(context)!.storePictures,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorePicturesPage(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54, size: 24),
          ],
        ),
      ),
    );
  }
}
