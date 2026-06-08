import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';

import 'marketplace_step1_intro_screen.dart';

class MarketplaceIntroScreen extends StatelessWidget {
  final Map<String, dynamic> store;
  const MarketplaceIntroScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final storeId = store['id'] as int?;
        return MarketplaceSetupCubit(storeId: storeId);
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: StepProgressBar(currentStep: 1, totalSteps: 3),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

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
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.quicksand(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.postedOn,
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.mostPopularMarketplace,
                                  style: GoogleFonts.quicksand(
                                    color: Color(0xFF6246EA),
                                  ), // Matching the color from step_progress_bar
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.toGrowYourBusiness,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Items
                          _buildFeatureItem(
                            stepNumber: '1',
                            title: AppLocalizations.of(
                              context,
                            )!.getToKnowBusiness,
                            description: AppLocalizations.of(
                              context,
                            )!.shareBasicInfo,
                            iconData: PhosphorIcons.storefront(
                              PhosphorIconsStyle.fill,
                            ),
                          ),
                          const Divider(
                            height: 48,
                            thickness: 1,
                            color: Color(0xFFEEEEEE),
                          ),

                          _buildFeatureItem(
                            stepNumber: '2',
                            title: AppLocalizations.of(
                              context,
                            )!.createOnlinePresence,
                            description: AppLocalizations.of(
                              context,
                            )!.addPhotosDescription,
                            iconData: PhosphorIcons.rocketLaunch(
                              PhosphorIconsStyle.fill,
                            ),
                          ),
                          const Divider(
                            height: 48,
                            thickness: 1,
                            color: Color(0xFFEEEEEE),
                          ),

                          _buildFeatureItem(
                            stepNumber: '3',
                            title: AppLocalizations.of(
                              context,
                            )!.startAcceptingOnlineAppointments,
                            description: AppLocalizations.of(
                              context,
                            )!.readyToAcceptAppointments,
                            iconData: PhosphorIcons.calendarCheck(
                              PhosphorIconsStyle.fill,
                            ),
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
                                child: MarketplaceStep1IntroScreen(
                                  store: store,
                                ),
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
        },
      ),
    );
  }

  Widget _buildFeatureItem({
    required String stepNumber,
    required String title,
    required String description,
    required IconData iconData,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepNumber,
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ), // Align with title text
                child: Text(
                  description,
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6246EA), Color(0xFFB4A4FF)], // Purple gradient
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Icon(iconData, color: Colors.white, size: 32)),
        ),
      ],
    );
  }
}
