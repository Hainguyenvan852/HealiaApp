import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../l10n/app_localizations.dart';

class EditStaffPage extends StatefulWidget {
  const EditStaffPage({super.key, required this.isEdit, this.staff});
  final bool isEdit;
  final StaffModel? staff;

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthdayDateController;
  late final TextEditingController _birthdayYearController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _startDateController;
  late final TextEditingController _startYearController;
  late final TextEditingController _endDateController;
  late final TextEditingController _endYearController;
  late final TextEditingController _staffIdController;
  late final TextEditingController _notesController;

  final _formKey = GlobalKey<FormState>();
  int _notesLength = 0;
  bool _isLoading = false;
  File? _avatarFile;
  String? _avatarUrl;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      setState(() {
        _avatarFile = File(selectedImage.path);
      });
    }
  }

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String fullName = _fullNameController.text.trim();
      final String email = _emailController.text.trim();
      final String phoneNumber = _phoneController.text.trim();
      final String jobTitle = _jobTitleController.text.trim();
      final String notes = _notesController.text.trim();

      DateTime? birthDay;
      if (_birthdayDateController.text.isNotEmpty &&
          _birthdayYearController.text.isNotEmpty) {
        birthDay = DateFormat('dd/MM/yyyy').parse(
          '${_birthdayDateController.text}/${_birthdayYearController.text}',
        );
      }

      DateTime startDate = DateTime.now();
      if (_startDateController.text.isNotEmpty &&
          _startYearController.text.isNotEmpty) {
        startDate = DateFormat(
          'dd/MM/yyyy',
        ).parse('${_startDateController.text}/${_startYearController.text}');
      }

      DateTime? endDate;
      if (_endDateController.text.isNotEmpty &&
          _endYearController.text.isNotEmpty) {
        endDate = DateFormat(
          'dd/MM/yyyy',
        ).parse('${_endDateController.text}/${_endYearController.text}');
      }

      String? uploadedAvatarUrl = _avatarUrl;

      if (_avatarFile != null) {
        final String fileExtension = _avatarFile!.path.split('.').last;
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_staff_avatar.$fileExtension';
        uploadedAvatarUrl = await inj<StoreDatasource>().uploadStaffAvatar(
          fileName,
          _avatarFile!,
        );
      }

      if (widget.isEdit && widget.staff != null) {
        await inj<StoreDatasource>().updateStaff(
          staffId: widget.staff!.id,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          jobTitle: jobTitle.isEmpty ? null : jobTitle,
          birthDay: birthDay,
          startDate: startDate,
          endDate: endDate,
          notes: notes.isEmpty ? null : notes,
          avatarUrl: uploadedAvatarUrl,
        );
      } else {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final storeId = await inj<ReportDatasource>().getManagerStoreId(
            user.id,
          );
          if (storeId != null) {
            await inj<StoreDatasource>().addStaff(
              storeId: storeId,
              fullName: fullName,
              email: email,
              phoneNumber: phoneNumber,
              jobTitle: jobTitle.isEmpty ? null : jobTitle,
              birthDay: birthDay,
              startDate: startDate,
              endDate: endDate,
              notes: notes.isEmpty ? null : notes,
              avatarUrl: uploadedAvatarUrl,
            );
          }
        }
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(
    TextEditingController dateCtrl,
    TextEditingController yearCtrl,
  ) async {
    DateTime initialDate = DateTime.now();
    if (dateCtrl.text.isNotEmpty && yearCtrl.text.isNotEmpty) {
      try {
        initialDate = DateFormat(
          'dd/MM/yyyy',
        ).parse('${dateCtrl.text}/${yearCtrl.text}');
      } catch (e) {
        // ignore
      }
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateCtrl.text = DateFormat('dd/MM').format(picked);
        yearCtrl.text = DateFormat('yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.staff?.avatarUrl;
    _fullNameController = widget.isEdit
        ? TextEditingController(text: widget.staff?.fullName ?? '')
        : TextEditingController();
    _emailController = widget.isEdit
        ? TextEditingController(text: widget.staff?.email ?? '')
        : TextEditingController();
    _phoneController = widget.isEdit
        ? TextEditingController(text: widget.staff?.phoneNumber ?? '')
        : TextEditingController();
    _birthdayDateController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? (widget.staff!.birthDay != null
                      ? DateFormat("dd/MM").format(widget.staff!.birthDay!)
                      : '')
                : '',
          )
        : TextEditingController();
    _birthdayYearController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? (widget.staff!.birthDay != null
                      ? DateFormat("yyyy").format(widget.staff!.birthDay!)
                      : '')
                : '',
          )
        : TextEditingController();
    _jobTitleController = widget.isEdit
        ? TextEditingController(text: widget.staff?.jobTitle ?? '')
        : TextEditingController();
    _startDateController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? DateFormat("dd/MM").format(widget.staff!.startDate)
                : '',
          )
        : TextEditingController();
    _startYearController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? DateFormat("yyyy").format(widget.staff!.startDate)
                : '',
          )
        : TextEditingController();
    _endDateController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? (widget.staff!.endDate != null
                      ? DateFormat("dd/MM").format(widget.staff!.endDate!)
                      : '')
                : '',
          )
        : TextEditingController();
    _endYearController = widget.isEdit
        ? TextEditingController(
            text: widget.staff != null
                ? (widget.staff!.endDate != null
                      ? DateFormat("yyyy").format(widget.staff!.endDate!)
                      : '')
                : '',
          )
        : TextEditingController();
    _staffIdController = widget.isEdit
        ? TextEditingController(text: '88')
        : TextEditingController();
    _notesController = widget.isEdit
        ? TextEditingController(text: widget.staff?.notes ?? '')
        : TextEditingController();
    _notesController.addListener(() {
      setState(() => _notesLength = _notesController.text.length);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayDateController.dispose();
    _birthdayYearController.dispose();
    _jobTitleController.dispose();
    _startDateController.dispose();
    _startYearController.dispose();
    _endDateController.dispose();
    _endYearController.dispose();
    _staffIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.isEdit ? AppLocalizations.of(context)!.editStaff : AppLocalizations.of(context)!.addStaff,
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.profile,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.managingEmployeeRecords,
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _avatarFile != null
                          ? Container(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _avatarFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : (_avatarUrl != null
                                ? Container(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: _avatarUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF2EFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: widget.staff == null
                                          ? PhosphorIcon(
                                              PhosphorIcons.user(),
                                              color: const Color(0xFF5B45FF),
                                            )
                                          : Text(
                                              widget.staff!.fullName[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF5B45FF),
                                              ),
                                            ),
                                    ),
                                  )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: const PhosphorIcon(
                        PhosphorIconsRegular.pencilSimple,
                        size: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        AppLocalizations.of(context)!.fullNameRequired,
                        _fullNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.fullNameIsRequiredError;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email
                _buildTextField(
                  AppLocalizations.of(context)!.emailRequired,
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.emailIsRequiredError;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return AppLocalizations.of(context)!.enterValidEmailError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Số điện thoại
                _buildLabel(AppLocalizations.of(context)!.phoneNumber),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Phone Number
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _inputDecoration(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildLabel(AppLocalizations.of(context)!.country),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          'Vietnam',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.birthDay,
                        _birthdayDateController,
                        hint: AppLocalizations.of(context)!.date,
                        suffixIcon: _birthdayDateController.text.isNotEmpty
                            ? Icons.close
                            : PhosphorIconsRegular.calendarBlank,
                        onSuffixTap: _birthdayDateController.text.isNotEmpty
                            ? () => setState(() {
                                _birthdayDateController.clear();
                                _birthdayYearController.clear();
                              })
                            : () => _selectDate(
                                _birthdayDateController,
                                _birthdayYearController,
                              ),
                        readOnly: true,
                        onTap: () => _selectDate(
                          _birthdayDateController,
                          _birthdayYearController,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.year,
                        _birthdayYearController,
                        hint: AppLocalizations.of(context)!.year,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        onTap: () => _selectDate(
                          _birthdayDateController,
                          _birthdayYearController,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  AppLocalizations.of(context)!.jobTitle,
                  _jobTitleController,
                  helperText: AppLocalizations.of(context)!.displayToOnlineCustomers,
                ),
                const SizedBox(height: 32),
                Divider(color: Colors.grey.shade200, thickness: 1),
                const SizedBox(height: 32),

                Text(
                  AppLocalizations.of(context)!.jobDetails,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.manageEmployeeJobDetails,
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.startDate,
                        _startDateController,
                        hint: AppLocalizations.of(context)!.date,
                        suffixIcon: PhosphorIconsRegular.calendarBlank,
                        readOnly: true,
                        onTap: () => _selectDate(
                          _startDateController,
                          _startYearController,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.year,
                        _startYearController,
                        hint: AppLocalizations.of(context)!.year,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        onTap: () => _selectDate(
                          _startDateController,
                          _startYearController,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.endDate,
                        _endDateController,
                        hint: AppLocalizations.of(context)!.date,
                        suffixIcon: PhosphorIconsRegular.calendarBlank,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(_endDateController, _endYearController),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        AppLocalizations.of(context)!.year,
                        _endYearController,
                        hint: AppLocalizations.of(context)!.year,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(_endDateController, _endYearController),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel(AppLocalizations.of(context)!.notes),
                    Text(
                      '$_notesLength/1000',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLength: 1000,
                  maxLines: 4,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _inputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.addPersonalNotesDesc,
                  ).copyWith(counterText: ""),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveStaff,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? LoadingAnimationWidget.progressiveDots(
                        color: Colors.white,
                        size: 30,
                      )
                    : Text(
                        AppLocalizations.of(context)!.save,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    String? helperText,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration(hintText: hint).copyWith(
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap ?? onTap,
                    child: Icon(
                      suffixIcon,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.quicksand(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.all(16),
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
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }
}
