import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/get_user_settings_usecase.dart';
import 'package:healio_app/features/user/profile/domain/usecases/update_user_settings_usecase.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool? _isNotificationEnabled;
  bool isLoading = false;
  late final Future<bool> settingFuture;
  late final String userId;

  @override
  void initState() {
    super.initState();
    final currentUser = inj<CheckCurrentUserUseCase>().call();
    userId = currentUser!.id;
    settingFuture = inj<GetUserSettingsUseCase>().call(currentUser.id);
  }

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
      body: FutureBuilder(
        future: settingFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            );
          }

          if(snap.hasError || !snap.hasData){
            return Center(
              child: Text(AppLocalizations.of(context)!.somethingWentWrong, style: GoogleFonts.quicksand(
                fontSize: 16,
                color: ColorTheme.mainAppColor(),
                fontWeight: FontWeight.w600
              ),),
            );
          }

          _isNotificationEnabled ??= snap.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.notificationSettings,
                  style: GoogleFonts.quicksand(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  AppLocalizations.of(context)!.newsletterSubscription,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  AppLocalizations.of(context)!.appointmentNotifications,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.textMessage,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    AsyncLoadingSwitch(
                      value: _isNotificationEnabled!,
                      onChanged: (bool newValue) async {
                        await inj<UpdateUserSettingsUseCase>().call(userId, newValue);

                        setState(() {
                          _isNotificationEnabled = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AsyncLoadingSwitch extends StatefulWidget {
  final bool value;
  final Future<void> Function(bool newValue) onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const AsyncLoadingSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF6B4EFF),
    this.inactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  State<AsyncLoadingSwitch> createState() => _AsyncLoadingSwitchState();
}

class _AsyncLoadingSwitchState extends State<AsyncLoadingSwitch> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onChanged(!widget.value);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: widget.value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: widget.value ? widget.activeColor : Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
