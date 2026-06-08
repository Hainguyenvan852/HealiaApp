import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';

import 'marketplace_step3_intro_screen.dart';

class MarketplaceStoreDescriptionScreen extends StatefulWidget {
  const MarketplaceStoreDescriptionScreen({super.key});

  @override
  State<MarketplaceStoreDescriptionScreen> createState() =>
      _MarketplaceStoreDescriptionScreenState();
}

class _MarketplaceStoreDescriptionScreenState
    extends State<MarketplaceStoreDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initialDesc = context.read<MarketplaceSetupCubit>().state.description;
    _descriptionController.text = initialDesc;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      context.read<MarketplaceSetupCubit>().updateDescription(
        _descriptionController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<MarketplaceSetupCubit>(),
            child: const MarketplaceStep3IntroScreen(),
          ),
        ),
      );
    }
  }

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tellUsAboutThisPlace,
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.effectiveDescriptions,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.descriptionLabel,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _descriptionController,
                          builder: (context, child) {
                            return Text(
                              '${_descriptionController.text.length}/1200',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 8,
                      maxLength: 1200,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.provideShortDescription,
                        hintStyle: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        contentPadding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          64,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6246EA),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 200) {
                          return AppLocalizations.of(
                            context,
                          )!.minimum200Characters;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.minimum200Characters,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
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
                onPressed: _onNext,
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
    );
  }
}
