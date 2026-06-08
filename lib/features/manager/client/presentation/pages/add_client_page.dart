import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:healio_app/shared/datasource/client_datasource.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import '../../../../../l10n/app_localizations.dart';

class AddNewClientPage extends StatefulWidget {
  final int storeId;
  const AddNewClientPage({super.key, required this.storeId});

  @override
  State<AddNewClientPage> createState() => _AddNewClientPageState();
}

class _AddNewClientPageState extends State<AddNewClientPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  bool _isLoading = false;

  DateTime? _selectedDate;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B4EFF),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B4EFF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDayController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}";
        _yearController.text = picked.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.addNewClient,
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.profile,
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.managingClientPersonalProfile,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              _buildAvatarSection(),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      AppLocalizations.of(context)!.firstName,
                      'Eg: Hân',
                      _firstNameController,
                      validator: emptyValidation,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      AppLocalizations.of(context)!.lastName,
                      'Eg: Trần',
                      _lastNameController,
                      validator: emptyValidation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField(
                'Email',
                'example@domain.com',
                _emailController,
                validator: emailValidation,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _buildPhoneField(),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDatePickerField(
                      label: 'Birthday',
                      hint: 'Date',
                      controller: _birthDayController,
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: _buildDatePickerField(
                      label: 'Year',
                      hint: 'Year',
                      controller: _yearController,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Gender',
                      hint: 'Select one',
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      try {
                        final String fullName =
                            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                        final String phone = '${_phoneController.text.trim()}';

                        final newClient = ClientModel(
                          id: 0,
                          createdAt: DateTime.now(),
                          updatedAt: null,
                          storeId: widget.storeId,
                          isActive: true,
                          fullName: fullName,
                          email: _emailController.text.trim(),
                          phoneNumber: phone,
                          gender: _selectedGender == 'Male'
                              ? 1
                              : (_selectedGender == 'Female' ? 2 : 3),
                          dateOfBirth: _selectedDate,
                        );

                        await inj<ClientDatasource>().createClient(newClient);
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        setState(() => _isLoading = false);
                        SnackBarHelper.showError('Error: $e');
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: _isLoading
                ? LoadingAnimationWidget.waveDots(color: Colors.white, size: 30)
                : Text(
                    'Save',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 182, 169, 247),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.transparent),
      ),
      child: Center(
        child: Icon(
          PhosphorIcons.user(),
          size: 40,
          color: const Color(0xFF6B4EFF),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required VoidCallback onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: suffixIcon,
            errorStyle: GoogleFonts.quicksand(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: suffixIcon,
            errorStyle: GoogleFonts.quicksand(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone',
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                validator: emptyValidation,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.egPhone,
                  hintStyle: GoogleFonts.quicksand(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  errorStyle: GoogleFonts.quicksand(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6B4EFF),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 1),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
