import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/utils/snackbar_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIcons.arrowLeft(),
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: GoogleFonts.quicksand(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildButtonList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonList() {
    return Column(
      children: [
        _buildSettingItem(
          icon: PhosphorIcon(
            PhosphorIcons.bell(),
            size: 28,
            color: Colors.black87,
          ),
          title: AppLocalizations.of(context)!.notifications,
          onTap: () => context.pushNamed('notification-setting'),
        ),
        // _buildSettingItem(
        //   icon: PhosphorIcon(
        //     PhosphorIcons.shareNetwork(),
        //     size: 28,
        //     color: Colors.black87,
        //   ),
        //   title: AppLocalizations.of(context)!.socialLogins,
        //   onTap: () {},
        // ),
        _buildSettingItem(
          icon: PhosphorIcon(
            PhosphorIcons.globeHemisphereWest(),
            size: 28,
            color: Colors.black87,
          ),
          title: AppLocalizations.of(context)!.language,
          onTap: () => context.pushNamed('language-setting'),
        ),
        _buildSettingItem(
          icon: PhosphorIcon(
            PhosphorIcons.key(),
            size: 28,
            color: Colors.black87,
          ),
          title: AppLocalizations.of(context)!.changePassword,
          onTap: () {
            final user = inj<CheckCurrentUserUseCase>().call();
            if (user != null) {
              final providers =
                  user.appMetadata['providers'] as List<dynamic>? ?? [];
              if (providers.contains('email')) {
                context.pushNamed('update-password');
              } else {
                SnackBarHelper.showAlert(
                  AppLocalizations.of(
                    context,
                  )!.yourAccountRegisteredThroughDifferentMethod,
                );
              }
            }
          },
        ),
        _buildSettingItem(
          icon: PhosphorIcon(
            PhosphorIcons.arrowUpRight(),
            size: 28,
            color: Colors.black87,
          ),
          title: AppLocalizations.of(context)!.termsAndPolicy,
          onTap: () => context.pushNamed('term-and-policy'),
          showBorder: false,
        ),
        const SizedBox(height: 48),
        // Center(
        //   child: OutlinedButton(
        //     onPressed: () {
        //       // Xử lý logic xóa tài khoản
        //     },
        //     style: OutlinedButton.styleFrom(
        //       minimumSize: Size(150, 0),
        //       maximumSize: Size(150, 40),
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       side: BorderSide(color: Colors.grey.shade300, width: 1),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(30),
        //       ),
        //     ),
        //     child: Text(
        //       AppLocalizations.of(context)!.deleteAccount,
        //       style: GoogleFonts.quicksand(
        //         fontSize: 14,
        //         fontWeight: FontWeight.bold,
        //         color: const Color.fromARGB(255, 235, 22, 22),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSettingItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                )
              : null,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 24, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}
