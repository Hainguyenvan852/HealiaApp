import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/manager/account%20setups/domain/usecases/add_category_usecase.dart';
import 'package:healio_app/features/manager/account%20setups/domain/usecases/add_service_usecase.dart';
import 'package:healio_app/features/manager/account%20setups/domain/usecases/add_staff_usecase.dart';
import 'package:healio_app/features/manager/account%20setups/domain/usecases/add_store_usecase.dart';
import 'package:healio_app/features/manager/account%20setups/domain/usecases/add_working_hour_usecase.dart';
import 'package:healio_app/features/manager/account%20setups/presentation/blocs/account_setup_cubit.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/injector/dependency_injector.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../user/profile/data/models/user_model.dart';
import '../../../../user/profile/domain/usecases/get_user_info_usecase.dart';
import '../../../widgets/step_progress_bar.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String? selectedSource;
  bool isLoading = false;

  final List<String> sources = [
    "Recommended by a friend",
    "Search engine (e.g. Google, Bing)",
    "Social media",
    "Advert in the mail",
    "Magazine ad",
    "Ratings website (e.g. Capterra, Trustpilot)",
    "AI Chatbot (e.g. ChatGPT, Gemini, DeepSeek)",
    "Other",
  ];

  String serviceByCategory(String category) {
    switch (category) {
      case 'Hair & styling':
        return 'Wash & Scalp Massage';
      case 'Nails':
        return 'Basic Manicure';
      case 'Eyebrows & lashes':
        return 'Eyebrow Shaping';
      case 'Barber':
        return 'Cut & Style';
      case 'Massage':
        return 'Body Massage';
      case 'Spa & sauna':
        return 'Facial skincare';
      case 'Tattooing & piercing':
        return 'Custom Tattoo';
      case 'Makeup':
        return 'Office Makeup';
      case 'Facial & skincare':
        return 'Basic Facial';
      case 'Aesthetic':
        return 'Skin Rejuvenation & Restoration';
      default:
        return '';
    }
  }

  void setUpStore() async {
    setState(() {
      isLoading = true;
    });
    try {
      final settingState = context.read<AccountSetupCubit>().state;
      final user = inj<CheckCurrentUserUseCase>().call();

      final storeJson = {
        'name': settingState.businessName,
        'email': user!.email!,
        'manager_id': user.id,
        'province': settingState.province,
        'address': settingState.address,
        'primary_category': settingState.primaryCategory,
        'location': 'POINT(${settingState.lng} ${settingState.lat})',
        'store_type': settingState.accountType == 1 ? 'independent' : 'team',
      };

      final store = await inj<AddStoreUsecase>().call(storeJson);

      if (settingState.accountType == 2) {
        final staffJson = {'full_name': 'Wendy', 'store_id': store.id};

        await inj<AddStaffUsecase>().call(staffJson);
      }

      final primaryCategory = {
        'name': settingState.primaryCategory,
        'store_id': store.id,
      };

      if (settingState.secondaryCategory != null) {
        final secondCategory = {
          'name': settingState.secondaryCategory,
          'store_id': store.id,
        };
        final futures = await Future.wait([
          inj<AddCategoryUsecase>().call(primaryCategory),
          inj<AddCategoryUsecase>().call(secondCategory),
        ]);

        final category1 = futures[0];
        final category2 = futures[1];

        final serviceData1 = {
          'name': serviceByCategory(settingState.primaryCategory!),
          'price': 100000,
          'duration_minutes': 60,
          'category_id': category1.id,
        };

        final serviceData2 = {
          'name': serviceByCategory(settingState.secondaryCategory!),
          'price': 100000,
          'duration_minutes': 60,
          'category_id': category2.id,
        };

        await Future.wait([
          inj<AddServiceUsecase>().call(serviceData1),
          inj<AddServiceUsecase>().call(serviceData2),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 2,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 3,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 4,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 5,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 6,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 7,
            'start_time': '08:00:00',
            'end_time': '17:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 8,
            'start_time': '08:00:00',
            'end_time': '17:00:00',
          }),
          inj<UpdateUserInfoUsecase>().call(userId: user.id, verifyStore: true),
        ]);
      } else {
        final category = await inj<AddCategoryUsecase>().call(primaryCategory);
        final serviceData = {
          'name': serviceByCategory(settingState.primaryCategory!),
          'price': 60,
          'duration_minutes': 60,
          'category_id': category.id,
        };

        await Future.wait([
          inj<AddServiceUsecase>().call(serviceData),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 2,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 3,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 4,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 5,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 6,
            'start_time': '08:00:00',
            'end_time': '19:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 7,
            'start_time': '08:00:00',
            'end_time': '17:00:00',
          }),
          inj<AddWorkingHourUsecase>().call({
            'store_id': store.id,
            'day_of_week': 8,
            'start_time': '08:00:00',
            'end_time': '17:00:00',
          }),
          inj<UpdateUserInfoUsecase>().call(userId: user.id, verifyStore: true),
        ]);
      }

      setState(() {
        isLoading = false;
      });

      UserModel userInfo = await inj<GetUserInfoUseCase>().call(user.id);

      context.go('/manager-navigator', extra: userInfo);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackBarHelper.showError('An error occurred' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !isLoading
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const StepProgressBar(currentStep: 5, totalSteps: 5),
              titleSpacing: 0,
            )
          : null,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.accountSetup,
                        style: GoogleFonts.quicksand(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.howDidYouHearAboutFresha,
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),

                      ...sources.map((source) => _buildRadioOption(source)),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: selectedSource == null
                        ? null
                        : (isLoading ? null : () => setUpStore()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.done,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: ColorTheme.mainAppColor(),
                        size: 50,
                      ),
                      Text(
                        AppLocalizations.of(context)!.storeIsBeingSetUp,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorTheme.mainAppColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    bool isSelected = selectedSource == title;
    return InkWell(
      onTap: () {
        setState(() {
          selectedSource = title;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6246EA)
                      : Colors.grey.shade300,
                  width: isSelected ? 7 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
