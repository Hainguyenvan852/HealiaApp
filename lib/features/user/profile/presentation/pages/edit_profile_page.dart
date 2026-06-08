import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_info_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../domain/usecases/save_user_avatar_usecase.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dayController;
  late TextEditingController _yearController;

  final _formKey = GlobalKey<FormState>();
  String? _dobError;
  Object? imageSource;

  String? _selectedMonth;
  String? _selectedGender;
  bool isSaving = false;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  int _stringToInt(String month) {
    switch (month) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'June':
        return 6;
      case 'July':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 0;
    }
  }

  String _intToString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  bool isChange() {
    String originalDay = widget.user.dateOfBirth?.day.toString() ?? '';
    String originalMonth = widget.user.dateOfBirth != null
        ? _intToString(widget.user.dateOfBirth!.month)
        : '';
    String originalYear = widget.user.dateOfBirth?.year.toString() ?? '';
    String rawPhone = widget.user.phoneNumber ?? '';
    return _fullNameController.text != widget.user.fullName ||
        _phoneController.text != rawPhone ||
        _dayController.text != originalDay ||
        (_selectedMonth ?? '') != originalMonth ||
        _yearController.text != originalYear ||
        _selectedGender != intGenderToString(widget.user.gender) ||
        imageSource != widget.user.avatarUrl;
  }

  bool _validateDateOfBirth() {
    bool hasDay = _dayController.text.trim().isNotEmpty;
    bool hasMonth = _selectedMonth != null;
    bool hasYear = _yearController.text.trim().isNotEmpty;

    int filledCount = (hasDay ? 1 : 0) + (hasMonth ? 1 : 0) + (hasYear ? 1 : 0);

    if (filledCount > 0 && filledCount < 3) {
      setState(() {
        _dobError = AppLocalizations.of(context)!.invalidDateFormat;
      });
      return false;
    }

    setState(() {
      _dobError = null;
    });
    return true;
  }

  String intGenderToString(int gender) {
    if (gender == 1) {
      return "Male";
    } else if (gender == 2) {
      return "Female";
    } else {
      return "Other";
    }
  }

  int stringGenderToInt(String gender) {
    if (gender == 'Male') {
      return 1;
    } else if (gender == "Female") {
      return 2;
    } else {
      return 3;
    }
  }

  void _onOpenImagePicker() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      final File file = File(selectedImage.path);

      setState(() {
        imageSource = file;
      });
    }
  }

  Future<void> _updateUserInfo() async {
    bool isFormValid = _formKey.currentState!.validate();
    bool isDobValid = _validateDateOfBirth();
    if (isFormValid && isDobValid && isChange()) {
      setState(() {
        isSaving = true;
      });
      String? avatarUrl = widget.user.avatarUrl;
      if (imageSource is File) {
        try {
          avatarUrl = await inj<SaveUserAvatarUseCase>().call(
            '${widget.user.id}_avatar.jpg',
            imageSource as File,
          );
        } catch (e) {
          debugPrint('Error uploading avatar: $e');
        }
      }
      DateTime? dob;
      if (_dayController.text.isNotEmpty &&
          _selectedMonth != null &&
          _yearController.text.isNotEmpty) {
        dob = DateTime(
          int.parse(_yearController.text),
          _stringToInt(_selectedMonth!),
          int.parse(_dayController.text),
        );
      }
      int? gender;
      if (_selectedGender != null) {
        gender = stringGenderToInt(_selectedGender!);
      }
      await inj<UpdateUserInfoUsecase>().call(
        userId: widget.user.id,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        dob: dob,
        gender: gender,
        avatarUrl: avatarUrl,
      );
      if (mounted) {
        context.read<UserInfoCubit>().updateUser(widget.user.id);
        setState(() {
          isSaving = false;
        });
        context.pop();
      }
    }
  }

  @override
  void initState() {
    imageSource = widget.user.avatarUrl;
    super.initState();

    String firstName = widget.user.fullName;

    String rawPhone = widget.user.phoneNumber ?? '';
    if (rawPhone.startsWith('+84')) {
      rawPhone = rawPhone.replaceFirst('+84', '').trim();
    }

    _fullNameController = TextEditingController(text: firstName);
    _phoneController = TextEditingController(text: rawPhone);
    _emailController = TextEditingController(text: widget.user.email);
    _dayController = TextEditingController(
      text: widget.user.dateOfBirth != null
          ? widget.user.dateOfBirth!.day.toString()
          : null,
    );
    _selectedMonth = widget.user.dateOfBirth != null
        ? _intToString(widget.user.dateOfBirth!.month)
        : null;
    _yearController = TextEditingController(
      text: widget.user.dateOfBirth != null
          ? widget.user.dateOfBirth!.year.toString()
          : null,
    );
    _selectedGender = intGenderToString(widget.user.gender);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const PhosphorIcon(
              PhosphorIconsRegular.x,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.editProfileDetails,
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _onOpenImagePicker(),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        imageSource != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: imageSource is String
                                    ? CachedNetworkImage(
                                        width: 120,
                                        height: 120,
                                        filterQuality: FilterQuality.high,
                                        imageUrl: widget.user.avatarUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Shimmer(
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      )
                                    : Image.file(
                                        imageSource as File,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/user-avatar-default.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: PhosphorIcon(
                              PhosphorIconsRegular.pencilSimple,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildLabel(AppLocalizations.of(context)!.fullName),
              _buildTextField(
                controller: _fullNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.fullNameCannotBeEmpty;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel(AppLocalizations.of(context)!.mobileNumber),
              _buildTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final isValidPhone = RegExp(
                      r'^(0\d{9,10}|84\d{8,9})$',
                    ).hasMatch(value.trim());
                    if (!isValidPhone) {
                      return AppLocalizations.of(
                        context,
                      )!.invalidPhoneNumberFormat;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel(AppLocalizations.of(context)!.emailAddress),
              _buildTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                isEnable: false,
              ),
              const SizedBox(height: 20),

              _buildLabel(AppLocalizations.of(context)!.dateOfBirth),
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _dayController,
                        hint: AppLocalizations.of(context)!.day,
                        keyboardType: TextInputType.number,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildDropdown(
                        hint: AppLocalizations.of(context)!.month,
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (val) =>
                            setState(() => _selectedMonth = val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _yearController,
                        hint: AppLocalizations.of(context)!.year,
                        keyboardType: TextInputType.number,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_dobError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    _dobError!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              _buildLabel(AppLocalizations.of(context)!.gender),
              _buildDropdown(
                hint: AppLocalizations.of(context)!.selectOption,
                value: _selectedGender,
                items: _genders,
                onChanged: (val) => setState(() => _selectedGender = val),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
          ),
          child: ElevatedButton(
            onPressed: isSaving ? null : () => _updateUserInfo(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 54),
              maximumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: isSaving
                ? Center(
                    child: LoadingAnimationWidget.waveDots(
                      color: Colors.white,
                      size: 30,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.quicksand(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool isEnable = true,
    String? Function(String?)? validator,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: isEnable,
      validator: validator,
      style: GoogleFonts.quicksand(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.quicksand(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w600,
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5B45FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuMaxHeight: 250,
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.quicksand(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          isExpanded: true,
          icon: const PhosphorIcon(
            PhosphorIconsRegular.caretDown,
            size: 16,
            color: Colors.grey,
          ),
          style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
