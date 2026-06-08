import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';
import 'marketplace_store_photos_screen.dart';

class MarketplacePhotoGuidelinesScreen extends StatelessWidget {
  const MarketplacePhotoGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const StepProgressBar(
          currentStep: 2,
          totalSteps: 3,
          padding: EdgeInsets.zero,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      AppLocalizations.of(context)!.guideToLocationImages,
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(
                              context,
                            )!.highQualityImagesDescription,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Acceptable section
                    Text(
                      AppLocalizations.of(context)!.acceptable,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGuidelineImage(
                      isAcceptable: false,
                      imageUrl:
                          'https://static.dezeen.com/uploads/2020/10/shen-beauty-brooklyn-shop-interiors-plywood-mythology-new-york_dezeen_2364_col_5.jpg',
                    ),
                    const SizedBox(height: 16),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.clearImagesInterior,
                      isAcceptable: true,
                    ),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.atLeast3Images,
                      isAcceptable: true,
                    ),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.highResolutionImages,
                      isAcceptable: true,
                    ),
                    const SizedBox(height: 32),

                    // Unacceptable section
                    Text(
                      AppLocalizations.of(context)!.unacceptable,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGuidelineImage(
                      isAcceptable: true,
                      imageUrl:
                          'https://static.wixstatic.com/media/a66cba_b245ea92895b459f9363914260de90d9~mv2.png/v1/fill/w_980,h_551,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/a66cba_b245ea92895b459f9363914260de90d9~mv2.png',
                    ),

                    const SizedBox(height: 16),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.stockPhotos,
                      isAcceptable: false,
                    ),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.brandLogosAndImages,
                      isAcceptable: false,
                    ),
                    _buildGuidelineTextItem(
                      text: AppLocalizations.of(context)!.closeUpPhotos,
                      isAcceptable: false,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final cubit = context.read<MarketplaceSetupCubit>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: const MarketplaceStorePhotosScreen(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continuee,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineImage({
    required bool isAcceptable,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildGuidelineTextItem({
    required String text,
    required bool isAcceptable,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isAcceptable ? Colors.green : Colors.red,
                width: 1.5,
              ),
            ),
            child: Icon(
              isAcceptable ? Icons.check : Icons.close,
              size: 14,
              color: isAcceptable ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
