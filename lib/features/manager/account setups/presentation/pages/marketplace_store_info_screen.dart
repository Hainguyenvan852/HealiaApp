import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';
import 'marketplace_step2_intro_screen.dart';

class MarketplaceStoreInfoScreen extends StatefulWidget {
  final Map<String, dynamic> store;
  const MarketplaceStoreInfoScreen({super.key, required this.store});

  @override
  State<MarketplaceStoreInfoScreen> createState() =>
      _MarketplaceStoreInfoScreenState();
}

class _MarketplaceStoreInfoScreenState
    extends State<MarketplaceStoreInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.store['name']?.toString() ?? '',
    );
    _emailController = TextEditingController(
      text: widget.store['email']?.toString() ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.store['phone_number']?.toString() ?? '',
    );
    _addressController = TextEditingController(
      text: widget.store['address']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      // Save to Cubit
      context.read<MarketplaceSetupCubit>().updateBasicInfo(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      // Navigate to Step 2 Intro Screen
      final cubit = context.read<MarketplaceSetupCubit>();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: const MarketplaceStep2IntroScreen(),
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
          currentStep: 1,
          totalSteps: 3,
          padding: EdgeInsets.zero,
        ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.businessInformation,
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.pleaseProvideBasicInfo,
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        label: AppLocalizations.of(context)!.businessName,
                        hint: AppLocalizations.of(context)!.enterBusinessName,
                        icon: PhosphorIcons.storefront(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterBusinessName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: AppLocalizations.of(context)!.enterEmailAddress,
                        icon: PhosphorIcons.envelopeSimple(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterEmail;
                          }
                          final emailRegExp = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegExp.hasMatch(value)) {
                            return AppLocalizations.of(context)!.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Phone Field
                      _buildTextField(
                        controller: _phoneController,
                        label: AppLocalizations.of(context)!.phoneNumber,
                        hint: AppLocalizations.of(context)!.enterPhoneNumber,
                        icon: PhosphorIcons.phone(),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterPhoneNumber;
                          }
                          final phoneRegExp = RegExp(r'^\d{9,11}$');
                          if (!phoneRegExp.hasMatch(
                            value.replaceAll(' ', ''),
                          )) {
                            return AppLocalizations.of(context)!.invalidPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Address Field
                      _buildTextField(
                        controller: _addressController,
                        label: AppLocalizations.of(context)!.address,
                        hint: AppLocalizations.of(context)!.enterAddress,
                        icon: PhosphorIcons.mapPin(),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterAddress;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
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
                    AppLocalizations.of(context)!.saveAndContinue,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
