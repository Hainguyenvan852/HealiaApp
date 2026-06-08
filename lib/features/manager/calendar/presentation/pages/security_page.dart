import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/features/user/auth/presentation/pages/update_password_page.dart';

import '../../../../../l10n/app_localizations.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _hasEmail = false;
  bool _hasGoogle = false;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkProviders();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      if (mounted) {
        _checkProviders();
      }
    });
  }

  void _checkProviders() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final providers = user.appMetadata['providers'] as List<dynamic>? ?? [];
      setState(() {
        _hasEmail = providers.contains('email');
        _hasGoogle = providers.contains('google');
      });
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                AppLocalizations.of(context)!.loginAndSecurity,
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
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
                      )!.updateYourPasswordAndSecureYourAccount,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Text(
              //   AppLocalizations.of(context)!.loginDetails,
              //   style: GoogleFonts.quicksand(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Text(
              //   AppLocalizations.of(context)!.socialMediaAccountsAreLinked,
              //   style: GoogleFonts.quicksand(
              //     fontSize: 15,
              //     color: Colors.grey.shade600,
              //     fontWeight: FontWeight.w500,
              //     height: 1.4,
              //   ),
              // ),
              // const SizedBox(height: 24),

              _buildListItem(
                title: AppLocalizations.of(context)!.password,
                subtitle: '********',
                buttonText: AppLocalizations.of(context)!.changePassword,
                onPressed: () {
                  if (_hasEmail) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdatePasswordPage(),
                      ),
                    );
                  } else {
                    SnackBarHelper.showAlert(
                      AppLocalizations.of(
                        context,
                      )!.yourAccountRegisteredThroughDifferentMethod,
                    );
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: Colors.grey.shade200, thickness: 1),
              ),

              // _buildListItem(
              //   leadingIcon: SvgPicture.asset(
              //     'assets/icons/google-icon-logo.svg',
              //     height: 36,
              //   ),
              //   title: 'Google',
              //   subtitle: _hasGoogle
              //       ? AppLocalizations.of(context)!.connected
              //       : AppLocalizations.of(context)!.notConnected,
              //   buttonText: _hasGoogle
              //       ? AppLocalizations.of(context)!.connected
              //       : AppLocalizations.of(context)!.connect,
              //   onPressed: () async {
              //     if (!_hasGoogle) {
              //       try {
              //         await Supabase.instance.client.auth.linkIdentity(
              //           OAuthProvider.google,
              //         );
              //       } catch (e) {
              //         if (mounted) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text(
              //                 '${AppLocalizations.of(context)!.errorConnectingGoogle}$e',
              //               ),
              //             ),
              //           );
              //         }
              //       }
              //     }
              //   },
              // ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    Widget? leadingIcon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        if (leadingIcon != null) ...[leadingIcon, const SizedBox(width: 16)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            buttonText,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
