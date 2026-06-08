import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class HelperCenterPage extends StatefulWidget {
  const HelperCenterPage({super.key});

  @override
  State<HelperCenterPage> createState() => _HelperCenterPageState();
}

class _HelperCenterPageState extends State<HelperCenterPage> {
  String? _selectedHelpOption;
  String? _selectedReasonOption1;
  String? _selectedBusinessOption;
  String? _selectedReasonOption2;
  final _emailContrl = TextEditingController();
  final _describeContrl = TextEditingController();
  final _fullNameContrl = TextEditingController();
  final _phoneContrl = TextEditingController();
  final _businessContrl = TextEditingController();
  final _needInfoContrl = TextEditingController();
  final _descriptionContrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

  void _showHelpOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.needSupport,
                  value: AppLocalizations.of(context)!.needSupport,
                  groupValue: _selectedHelpOption,
                  isHelp: 'help',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.joinBusiness,
                  value: AppLocalizations.of(context)!.joinBusiness,
                  groupValue: _selectedHelpOption,
                  isHelp: 'help',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.bookedAppointment,
                  value: AppLocalizations.of(context)!.bookedAppointment,
                  groupValue: _selectedHelpOption,
                  isHelp: 'help',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReasonOptionsDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.accountSetup,
                  value: AppLocalizations.of(context)!.accountSetup,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.addonsIntegrations,
                  value: AppLocalizations.of(context)!.addonsIntegrations,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.billingFees,
                  value: AppLocalizations.of(context)!.billingFees,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.paymentsPayouts,
                  value: AppLocalizations.of(context)!.paymentsPayouts,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.technicalSupport,
                  value: AppLocalizations.of(context)!.technicalSupport,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.other,
                  value: AppLocalizations.of(context)!.other,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason1',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReasonOptionsDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.myAppointments,
                  value: AppLocalizations.of(context)!.myAppointments,
                  groupValue: _selectedReasonOption1,
                  isHelp: 'reason2',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.paymentsPurchases,
                  value: AppLocalizations.of(context)!.paymentsPurchases,
                  groupValue: _selectedReasonOption2,
                  isHelp: 'reason2',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.reviews1,
                  value: AppLocalizations.of(context)!.reviews1,
                  groupValue: _selectedReasonOption2,
                  isHelp: 'reason2',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                // _buildRadioOption(
                //   text: 'Email notifications',
                //   value: 'Email notifications',
                //   groupValue: _selectedReasonOption2,
                //   isHelp: 'reason2',
                // ),
                // const Divider(
                //   height: 1,
                //   thickness: 1,
                //   color: Color(0xFFF0F0F0),
                // ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.deleteMyAccount,
                  value: AppLocalizations.of(context)!.deleteMyAccount,
                  groupValue: _selectedReasonOption2,
                  isHelp: 'reason2',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.other,
                  value: AppLocalizations.of(context)!.other,
                  groupValue: _selectedReasonOption2,
                  isHelp: 'reason2',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBusinessTypeOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.hairSalons,
                  value: AppLocalizations.of(context)!.hairSalons,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.nailSalon,
                  value: AppLocalizations.of(context)!.nailSalon,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.barbershop,
                  value: AppLocalizations.of(context)!.barbershop,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.spaAndSauna,
                  value: AppLocalizations.of(context)!.spaAndSauna,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.massage,
                  value: AppLocalizations.of(context)!.massage,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.eyebrowsAndEyelashes,
                  value: AppLocalizations.of(context)!.eyebrowsAndEyelashes,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.tattooAndPiercing,
                  value: AppLocalizations.of(context)!.tattooAndPiercing,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
                _buildRadioOption(
                  text: AppLocalizations.of(context)!.beautySalon,
                  value: AppLocalizations.of(context)!.beautySalon,
                  groupValue: _selectedBusinessOption,
                  isHelp: 'business',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<File?> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1064,
        maxWidth: 1064,
        imageQuality: 80,
      );

      if (image != null) {
        final byteSize = await image.length();
        double mbSize = byteSize / (1024 * 1024);
        if (mbSize > 10) {
          SnackBarHelper.showError(
            AppLocalizations.of(context)!.imageSizeExceeded,
          );
          return null;
        }

        return File(image.path);
      }
    } catch (error) {
      SnackBarHelper.showError(AppLocalizations.of(context)!.imageUploadError);
    }
    return null;
  }

  Future<void> _sendEmailWithAttachment() async {
    if (_selectedHelpOption == AppLocalizations.of(context)!.needSupport) {
      if (_formKey.currentState!.validate() &&
          _selectedImageFile != null &&
          _selectedReasonOption1 !=
              AppLocalizations.of(context)!.pleaseSelect) {
        try {
          final Email email = Email(
            body: _describeContrl.text.isEmpty
                ? AppLocalizations.of(context)!.needSupport +
                      ' about ${_selectedReasonOption1}'
                : _describeContrl.text,
            subject: AppLocalizations.of(context)!.businessSupport,
            recipients: ['helia@support.com'],
            attachmentPaths: [_selectedImageFile!.path],
            isHTML: false,
          );

          await FlutterEmailSender.send(email);
        } catch (error) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.emailAppError);
        }
      } else {
        if (_selectedImageFile == null) {
          SnackBarHelper.showError(
            AppLocalizations.of(context)!.noImageSelected,
          );
          return;
        }
        if (_selectedReasonOption1 ==
            AppLocalizations.of(context)!.pleaseSelect) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.selectReason);
          return;
        }
      }
    } else if (_selectedHelpOption ==
        AppLocalizations.of(context)!.joinBusiness) {
      if (_formKey.currentState!.validate() &&
          _selectedBusinessOption !=
              AppLocalizations.of(context)!.pleaseSelect) {
        try {
          final Email email = Email(
            body: _needInfoContrl.text.isEmpty
                ? AppLocalizations.of(context)!.joinBusiness
                : _describeContrl.text,
            subject: AppLocalizations.of(context)!.businessAccountInfo,
            recipients: ['helia@support.com'],
          );

          await FlutterEmailSender.send(email);
        } catch (error) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.emailAppError);
        }
      } else {
        if (_selectedBusinessOption ==
            AppLocalizations.of(context)!.pleaseSelect) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.selectBusinessType);
          return;
        }
      }
    } else {
      final _isValidate = _formKey.currentState!.validate();
      if ( _isValidate &&
          _selectedImageFile != null &&
          _selectedReasonOption2 !=
              AppLocalizations.of(context)!.pleaseSelect) {
        try {
          final Email email = Email(
            body: _descriptionContrl.text.isEmpty
                ? AppLocalizations.of(context)!.needSupportAbout + ' ${_selectedReasonOption2}'
                : _descriptionContrl.text,
            subject: AppLocalizations.of(context)!.supportMail,
            recipients: ['helia@support.com'],
            attachmentPaths: [_selectedImageFile!.path],
            isHTML: false,
          );

          await FlutterEmailSender.send(email);
        } catch (error) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.emailAppError);
        }
      } else {
        if(!_isValidate){
          SnackBarHelper.showError(AppLocalizations.of(context)!.fillAllInformation);
          return;
        }
        if (_selectedImageFile == null) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.noImageSelected);
          return;
        }
        if (_selectedReasonOption2 ==
            AppLocalizations.of(context)!.pleaseSelect) {
          SnackBarHelper.showError(AppLocalizations.of(context)!.selectReasonType);
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    _emailContrl.dispose();
    _describeContrl.dispose();
    _fullNameContrl.dispose();
    _phoneContrl.dispose();
    _businessContrl.dispose();
    _needInfoContrl.dispose();
    _descriptionContrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          AppLocalizations.of(context)!.helpCenter,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.emailUs,
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              Text(
                AppLocalizations.of(context)!.howCanWeHelp,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _showHelpOptionsDialog,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          _selectedHelpOption !=
                              AppLocalizations.of(context)!.pleaseSelect
                          ? const Color(0xFF6F42C1)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedHelpOption ??
                              AppLocalizations.of(context)!.pleaseSelect,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color:
                                _selectedHelpOption ==
                                    AppLocalizations.of(context)!.pleaseSelect
                                ? Colors.grey.shade400
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Email *'),
                    _buildTextField(
                      helperText: AppLocalizations.of(context)!.enterEmail2,
                      controller: _emailContrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.emailRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    if (_selectedHelpOption ==
                        AppLocalizations.of(context)!.needSupport)
                      _buildOption1Form()
                    else if (_selectedHelpOption ==
                        AppLocalizations.of(context)!.joinBusiness)
                      _buildOption2Form()
                    else if (_selectedHelpOption ==
                        AppLocalizations.of(context)!.bookedAppointment)
                      _buildOption3Form(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String text,
    required String value,
    String? groupValue,
    required String isHelp,
  }) {
    final bool isSelected = value == groupValue;
    final Color textColor = Colors.black;
    final Color radioColor = Colors.black;

    return InkWell(
      onTap: () {
        if (isHelp == 'help') {
          setState(() {
            _selectedHelpOption = value;
          });
        } else if (isHelp == 'reason1') {
          setState(() {
            _selectedReasonOption1 = value;
          });
        } else if (isHelp == 'reason2') {
          setState(() {
            _selectedReasonOption2 = value;
          });
        } else if (isHelp == 'business') {
          setState(() {
            _selectedBusinessOption = value;
          });
        }
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: radioColor,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {String? optionalText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (optionalText != null)
            Text(
              optionalText,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? helperText,
    int maxLines = 1,
    double height = 50,
    int? maxLength,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: maxLines > 1 ? null : height,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              helperText,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFileUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final image = await _pickImageFromGallery();
            if (image != null) {
              setState(() {
                _selectedImageFile = image;
              });
            }
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Colors.grey.withValues(alpha: 0.3),
              radius: Radius.circular(15),
              dashPattern: [6, 2],
            ),
            child: _selectedImageFile != null
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 260,
                          child: AspectRatio(
                            aspectRatio: 1 / 2,
                            child: Image.file(
                              _selectedImageFile!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 260,
                    width: double.infinity,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 35,
                          color: Colors.black87,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.attachScreenshots,
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: () async {
                            final image = await _pickImageFromGallery();
                            if (image != null) {
                              setState(() {
                                _selectedImageFile = image;
                              });
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            minimumSize: Size(0, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                width: 0.8,
                                color: Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.chooseFile,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          AppLocalizations.of(context)!.fileType,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.black.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return InkWell(
      onTap: () => _sendEmailWithAttachment(),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.sendEmail,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption1Form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppLocalizations.of(context)!.reasonRequired),
        InkWell(
          onTap: _showReasonOptionsDialog1,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    _selectedReasonOption1 !=
                        AppLocalizations.of(context)!.pleaseSelect
                    ? const Color(0xFF6F42C1)
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedReasonOption1 ??
                        AppLocalizations.of(context)!.pleaseSelect,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color:
                          _selectedReasonOption1 ==
                              AppLocalizations.of(context)!.pleaseSelect
                          ? Colors.grey.shade400
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel(
          AppLocalizations.of(context)!.describeYourIssue,
          optionalText: '0/2000',
        ),
        _buildTextField(
          maxLines: 6,
          controller: _describeContrl,
          maxLength: 2000,
        ),
        const SizedBox(height: 24),
        _buildFileUploadArea(),
      ],
    );
  }

  Widget _buildOption2Form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppLocalizations.of(context)!.fullName2),
        _buildTextField(
          controller: _fullNameContrl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.fullNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildLabel(AppLocalizations.of(context)!.mobileNumber2),
        Row(
          children: [
            Container(
              width: 70,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Text(
                '+84',
                style: GoogleFonts.quicksand(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(controller: _phoneContrl)),
          ],
        ),
        const SizedBox(height: 24),
        _buildLabel(AppLocalizations.of(context)!.businessName),
        _buildTextField(
          controller: _businessContrl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.businessNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildLabel(AppLocalizations.of(context)!.businessType),
        InkWell(
          onTap: _showBusinessTypeOptionsDialog,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    _selectedBusinessOption !=
                        AppLocalizations.of(context)!.pleaseSelect
                    ? const Color(0xFF6F42C1)
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedBusinessOption ??
                        AppLocalizations.of(context)!.pleaseSelect,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color:
                          _selectedBusinessOption ==
                              AppLocalizations.of(context)!.pleaseSelect
                          ? Colors.grey.shade400
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel(AppLocalizations.of(context)!.generalInquiry),
        _buildTextField(
          maxLines: 4,
          maxLength: 500,
          controller: _needInfoContrl,
        ),
      ],
    );
  }

  Widget _buildOption3Form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppLocalizations.of(context)!.reasonRequired),
        InkWell(
          onTap: _showReasonOptionsDialog2,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    _selectedReasonOption2 !=
                        AppLocalizations.of(context)!.pleaseSelect
                    ? const Color(0xFF6F42C1)
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedReasonOption2 ??
                        AppLocalizations.of(context)!.pleaseSelect,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color:
                          _selectedReasonOption2 ==
                              AppLocalizations.of(context)!.pleaseSelect
                          ? Colors.grey.shade400
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel(AppLocalizations.of(context)!.queryDescription),
        _buildTextField(
          maxLines: 6,
          controller: _descriptionContrl,
          maxLength: 2000,
        ),
        const SizedBox(height: 24),
        _buildFileUploadArea(),
      ],
    );
  }
}
