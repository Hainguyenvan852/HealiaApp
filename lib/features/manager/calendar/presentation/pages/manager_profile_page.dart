import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/language_setting.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/personal_infomation_page.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/security_page.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/support_page.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/utils/bottom_sheet_helper.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../user/auth/presentation/bloc/auth_bloc.dart';

class ManagerProfilePage extends StatelessWidget {
  const ManagerProfilePage({super.key, required this.currentUser});
  final UserModel currentUser;

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageSettingPage(),
    );
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildMenuSection1(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.personalArea,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUser.fullName,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: currentUser.avatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: currentUser.avatarUrl!,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) {
                        return Text(
                          currentUser.fullName[0],
                          style: GoogleFonts.quicksand(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    currentUser.fullName[0],
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection1(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            PhosphorIcons.userRectangle(),
            AppLocalizations.of(context)!.profile,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfoPage()),
            ),
          ),
          _buildMenuItem(
            PhosphorIcons.shieldCheck(),
            AppLocalizations.of(context)!.signInAndSecurity,
            isLast: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityPage()),
            ),
          ),
          _buildMenuItem(
            PhosphorIcons.question(),
            AppLocalizations.of(context)!.helpAndSupport,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpSupportPage()),
            ),
          ),
          _buildMenuItem(
            PhosphorIcons.globe(),
            AppLocalizations.of(context)!.language,
            onTap: () => showLanguageBottomSheet(context),
          ),
          _buildMenuItem(
            PhosphorIcons.signOut(),
            AppLocalizations.of(context)!.signOut,
            isLast: true,
            onTap: () => BottomSheetHelper.showLogOutBottomSheet(
              context,
              context.read<AuthBloc>(),
              () => context.read<AuthBloc>().add(UserSignedOutRequested()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    bool isLast = false,
    Widget? customIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isLast ? Radius.zero : const Radius.circular(12),
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            SizedBox(
              height: 18,
              width: 26,
              child: customIcon ?? Icon(icon, color: Colors.black87, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
