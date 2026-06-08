import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/shared/datasource/client_datasource.dart';
import '../../../../../l10n/app_localizations.dart';

class UpdateClientDetailPage extends StatefulWidget {
  const UpdateClientDetailPage({super.key, required this.client});
  final ClientModel client;

  @override
  State<UpdateClientDetailPage> createState() => _UpdateClientDetailPageState();
}

class _UpdateClientDetailPageState extends State<UpdateClientDetailPage> {
  String? _selectedGender;

  DateTime? _selectedDate;
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  int? genderByString(String? gender) {
    if (gender == 'Male') return 1;
    if (gender == 'Female') return 2;
    if (gender == 'Other') return 3;
    return null;
  }

  String? genderByInt(int? gender) {
    if (gender == 1) return 'Male';
    if (gender == 2) return 'Female';
    if (gender == 3) return 'Other';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedGender = genderByInt(widget.client.gender);
    _selectedDate = widget.client.dateOfBirth;
    _birthDayController.text = widget.client.dateOfBirth != null
        ? DateFormat('dd/MM').format(widget.client.dateOfBirth!)
        : '';
    _yearController.text = widget.client.dateOfBirth != null
        ? DateFormat('yyyy').format(widget.client.dateOfBirth!)
        : '';

    final nameParts = widget.client.fullName.split(' ');
    if (nameParts.length > 1) {
      _lastNameController.text = nameParts
          .sublist(0, nameParts.length - 1)
          .join(' ');
      _firstNameController.text = nameParts.last;
    } else {
      _firstNameController.text = widget.client.fullName;
    }
    _emailController.text = widget.client.email;
    _phoneController.text = widget.client.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _birthDayController.dispose();
    _yearController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
          AppLocalizations.of(context)!.editClientInfo,
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
                children: [
                  Expanded(
                    child: _buildTextField(
                      AppLocalizations.of(context)!.firstName,
                      'Eg: Hân',
                      controller: _firstNameController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please enter first name'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      AppLocalizations.of(context)!.lastName,
                      'Eg: Trần',
                      controller: _lastNameController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Please enter second name'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField(
                'Email',
                'example@domain.com',
                controller: _emailController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty)
                    return AppLocalizations.of(context)!.pleaseEnterEmail;
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val))
                    return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildPhoneField(
                controller: _phoneController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty)
                    return AppLocalizations.of(context)!.pleaseEnterPhoneNumber;
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDatePickerField(
                      label: AppLocalizations.of(context)!.birthday,
                      hint: AppLocalizations.of(context)!.date,
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
                      label: AppLocalizations.of(context)!.year,
                      hint: AppLocalizations.of(context)!.year,
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
                      label: AppLocalizations.of(context)!.gender,
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
            onPressed: _isSaving
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() {
                      _isSaving = true;
                    });
                    try {
                      final fullName =
                          '${_lastNameController.text.trim()} ${_firstNameController.text.trim()}'
                              .trim();
                      final updates = {
                        'full_name': fullName,
                        'email': _emailController.text.trim(),
                        'phone_number': _phoneController.text.trim(),
                        'date_of_birth': _selectedDate?.toIso8601String(),
                        'gender': genderByString(_selectedGender),
                      };
                      final updatedClient = await inj<ClientDatasource>()
                          .updateClient(widget.client.id, updates);
                      if (mounted) {
                        SnackBarHelper.showSuccess(
                          'Client updated successfully',
                        );
                        Navigator.pop(context, updatedClient);
                      }
                    } catch (e) {
                      if (mounted) {
                        SnackBarHelper.showError('Error updating client: $e');
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isSaving = false;
                        });
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.save,
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
        TextFormField(
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
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
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
    String hint, {
    Widget? suffixIcon,
    TextEditingController? controller,
    String? Function(String?)? validator,
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
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
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

  Widget _buildPhoneField({
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.phone,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.egPhone2,
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
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
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
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
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
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
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
