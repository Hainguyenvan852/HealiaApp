import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/notification_setting_page.dart';
import 'package:healio_app/shared/datasource/notification_datasource.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/shared/models/notification_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../l10n/app_localizations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppLocalizations.of(context)!.notifications,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            GestureDetector(
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NotificationSettingsPage(),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              color: Colors.transparent,
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.notificationSettings,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade700,
                labelStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                indicatorColor: Colors.black,
                indicatorWeight: 3,
                dividerColor: Colors.grey.shade300,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.appointments),
                  Tab(text: AppLocalizations.of(context)!.reviews1),
                ],
              ),
            ),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime, BuildContext context) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 1) {
      return '${difference.inDays} ${AppLocalizations.of(context)!.daysAgo}';
    } else if (difference.inDays == 1) {
      return '1 ${AppLocalizations.of(context)!.dayAgo}';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} ${AppLocalizations.of(context)!.hoursAgo}';
    } else if (difference.inHours == 1) {
      return '1 ${AppLocalizations.of(context)!.hourAgo}';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} ${AppLocalizations.of(context)!.minutesAgo}';
    } else if (difference.inMinutes == 1) {
      return '1 ${AppLocalizations.of(context)!.minuteAgo}';
    } else {
      return AppLocalizations.of(context)!.justNow;
    }
  }

  Widget _buildBody(BuildContext context) {
    final currentUser = inj<CheckCurrentUserUseCase>().call();
    if (currentUser == null) {
      return Center(child: Text(AppLocalizations.of(context)!.notLoggedIn));
    }

    return StreamBuilder<List<NotificationModel>>(
      stream: inj<NotificationDatasource>().getNotificationsStream(
        currentUser.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: ColorTheme.mainAppColor(),
              size: 50,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data ?? [];
        final appointmentNotifications = notifications
            .where((n) => n.type == 'appointment')
            .toList();
        final reviewNotifications = notifications
            .where((n) => n.type == 'review')
            .toList();

        return TabBarView(
          children: [
            _buildAppointmentsTab(appointmentNotifications, context),
            _buildReviewsTab(reviewNotifications, context),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentsTab(
    List<NotificationModel> notifications,
    BuildContext context,
  ) {
    if (notifications.isEmpty) {
      return _buildEmptyTab(context);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...notifications.map((notification) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildNotificationCard(
              title: notification.title,
              time: _formatTimeAgo(notification.createdAt, context),
              content: notification.content,
              icon: Icons.calendar_today_rounded,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReviewsTab(
    List<NotificationModel> notifications,
    BuildContext context,
  ) {
    if (notifications.isEmpty) {
      return _buildEmptyTab(context);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ...notifications.map((notification) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildNotificationCard(
              title: notification.title,
              time: _formatTimeAgo(notification.createdAt, context),
              content: notification.content,
              icon: Icons.star_rounded,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String time,
    required String content,
    IconData icon = Icons.notifications,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.quicksand(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildAvatarWithBadge(icon),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithBadge(IconData icon) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.indigo.shade400,
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildEmptyTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSimulatedIllustration(),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noNotificationsYet,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.youDoNotHaveAnyNotificationsYet,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatedIllustration() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            left: 15,
            child: Container(
              width: 40,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
