import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/get_user_info_usecase.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';

import '../../../../../l10n/app_localizations.dart';
import 'edit_personal_info_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  Future<UserModel?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final currentUser = inj<CheckCurrentUserUseCase>().call();
    if (currentUser != null) {
      setState(() {
        _userFuture = inj<GetUserInfoUseCase>().call(currentUser.id);
      });
    }
  }

  void showEditPersonalInfoBottomSheet(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => EditPersonalInfoPage(user: user),
    ).then((updated) {
      if (updated == true) {
        _loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(
            PhosphorIconsRegular.arrowLeft,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: ColorTheme.mainAppColor(),
                  size: 50,
                ),
              );
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return Center(
                child: Text(AppLocalizations.of(context)!.failedToLoadUserInfo),
              );
            }

            final user = snapshot.data!;

            String genderStr = AppLocalizations.of(context)!.other;
            if (user.gender == 1)
              genderStr = AppLocalizations.of(context)!.male;
            if (user.gender == 2)
              genderStr = AppLocalizations.of(context)!.female;

            String dobStr = AppLocalizations.of(context)!.notProvided;
            if (user.dateOfBirth != null) {
              dobStr = DateFormat('dd/MM/yyyy').format(user.dateOfBirth!);
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        Text(
                          AppLocalizations.of(context)!.personalInformation,
                          style: GoogleFonts.quicksand(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(
                                  context,
                                )!.customizePersonalDetails,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.yourProfilePicture,
                              style: GoogleFonts.quicksand(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            _buildEditButton(() {
                              showEditPersonalInfoBottomSheet(context, user);
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2EFFF),
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child:
                                user.avatarUrl != null &&
                                    user.avatarUrl!.isNotEmpty
                                ? Image.network(
                                    user.avatarUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: PhosphorIcon(
                                      PhosphorIconsRegular.user,
                                      size: 60,
                                      color: Color(0xFF5B45FF),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        Text(
                          AppLocalizations.of(context)!.personalDetails,
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.keyInformationAboutYourself,
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildReadOnlyItem(
                          AppLocalizations.of(context)!.fullName,
                          user.fullName,
                        ),
                        const SizedBox(height: 20),
                        _buildReadOnlyItem(
                          AppLocalizations.of(context)!.dateOfBirth,
                          dobStr,
                        ),
                        const SizedBox(height: 20),
                        _buildReadOnlyItem(
                          AppLocalizations.of(context)!.gender,
                          genderStr,
                        ),

                        const SizedBox(height: 32),
                        Divider(color: Colors.grey.shade200, thickness: 1),
                        const SizedBox(height: 32),

                        Text(
                          AppLocalizations.of(context)!.contact,
                          style: GoogleFonts.quicksand(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildReadOnlyItem(
                          AppLocalizations.of(context)!.phoneNumber,
                          user.phoneNumber ??
                              AppLocalizations.of(context)!.notProvided,
                        ),
                        const SizedBox(height: 20),
                        _buildReadOnlyItem(
                          AppLocalizations.of(context)!.emailAddress,
                          user.email,
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        minimumSize: const Size(0, 32),
      ),
      child: Text(
        AppLocalizations.of(context)!.edit,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
