import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../l10n/app_localizations.dart';
import 'account_type_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/step_progress_bar.dart';
import '../blocs/account_setup_cubit.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String selectedCategories = '';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Hair & styling', 'icon': PhosphorIcons.hairDryer()},
    {'name': 'Nails', 'icon': PhosphorIcons.hand()},
    {'name': 'Eyebrows & lashes', 'icon': Icons.remove_red_eye_outlined},
    {'name': 'Barber', 'icon': Icons.content_cut},
    {'name': 'Massage', 'icon': Icons.airline_seat_flat_outlined},
    {'name': 'Spa & sauna', 'icon': Icons.hot_tub},
    {'name': 'Tattooing & piercing', 'icon': PhosphorIcons.asclepius()},
    {'name': 'Makeup', 'icon': PhosphorIcons.butterfly()},
    {'name': 'Facial & skincare', 'icon': PhosphorIcons.smiley()},
    {'name': 'Aesthetic', 'icon': PhosphorIcons.sparkle()},
  ];

  void toggleCategory(String name) {
    setState(() {
      selectedCategories = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: () => Navigator.pop(context),
        ),
        title: const StepProgressBar(currentStep: 2, totalSteps: 5),
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.accountSetup,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.selectCategoriesDescription,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.choosePrimaryAndRelated,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = selectedCategories.contains(
                        cat['name'],
                      );
                      final selectedIndex = selectedCategories.indexOf(
                        cat['name'],
                      );

                      return GestureDetector(
                        onTap: () => toggleCategory(cat['name']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF6246EA)
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      cat['icon'],
                                      size: 28,
                                      color: Colors.black87,
                                    ),
                                    const Spacer(),
                                    Text(
                                      cat['name'],
                                      style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: selectedIndex == 0
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          )
                                        : const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6246EA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      selectedIndex == 0
                                          ? AppLocalizations.of(
                                              context,
                                            )!.selected
                                          : '${selectedIndex + 1}',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Nút Continue
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedCategories.isNotEmpty
                    ? () {
                        final primary = selectedCategories;
                        context.read<AccountSetupCubit>().setCategories(
                          primary: primary,
                          secondary: null,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AccountSetupCubit>(),
                              child: const AccountTypeScreen(),
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.continuee,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
