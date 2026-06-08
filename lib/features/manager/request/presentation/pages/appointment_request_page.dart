import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/appointment_detail.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentRequestPage extends StatefulWidget {
  final UserModel currentUser;
  const AppointmentRequestPage({super.key, required this.currentUser});

  @override
  State<AppointmentRequestPage> createState() => _AppointmentRequestPageState();
}

class _AppointmentRequestPageState extends State<AppointmentRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<AppointmentModel>> _futureAppointments;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureAppointments = _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<AppointmentModel>> _loadAppointments() async {
    try {
      final store = await inj<StoreDatasource>().getStoreByMangerId(
        widget.currentUser.id,
      );
      final allAppointments = await inj<AppointmentDatasource>()
          .fetchStoreAppointments(store.id);

      return allAppointments
          .where(
            (apm) => apm.status == 'pending' || apm.status == 'cancel_pending',
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  void _refreshData() {
    setState(() {
      _futureAppointments = _loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.requests,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorTheme.mainAppColor(),
          labelColor: ColorTheme.mainAppColor(),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          tabs: [
            Tab(text: AppLocalizations.of(context)!.booking),
            Tab(text: AppLocalizations.of(context)!.cancellation),
          ],
        ),
      ),
      body: FutureBuilder<List<AppointmentModel>>(
        future: _futureAppointments,
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
            return Center(
              child: Text(
                'Error loading requests.',
                style: GoogleFonts.quicksand(),
              ),
            );
          }

          final allRequests = snapshot.data ?? [];
          final bookingRequests = allRequests
              .where((a) => a.status == 'pending')
              .toList();
          final cancelRequests = allRequests
              .where((a) => a.status == 'cancel_pending')
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRequestList(bookingRequests),
              _buildRequestList(cancelRequests),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRequestList(List<AppointmentModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noRequestsAvailable,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildAppointmentCard(list[index]);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel apm) {
    return InkWell(
      onTap: () async {
        String serviceNames = apm.services.map((e) => e.name).join('\n');

        final appointmentToPass = StoreAppointment(
          model: apm,
          id: apm.id,
          startTime: apm.startTime,
          endTime: apm.endTime,
          resourceIds: apm.services,
          color: apm.status == 'cancel_pending'
              ? Colors.orange
              : Colors.yellowAccent,
          subject:
              '${DateFormat('HH:mm').format(apm.startTime)} - ${DateFormat('HH:mm').format(apm.endTime)} ${apm.customerName}\n$serviceNames',
        );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentDetailPage(appointment: appointmentToPass),
          ),
        );
        _refreshData();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    apm.customerName,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: apm.status == 'cancel_pending'
                        ? Colors.orange.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    apm.status == 'cancel_pending' ? 'Cancel Req' : 'Booking',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: apm.status == 'cancel_pending'
                          ? Colors.orange.shade700
                          : Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEE, dd MMM yyyy').format(apm.startTime),
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('hh:mm a').format(apm.startTime)} - ${DateFormat('hh:mm a').format(apm.endTime)}',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (apm.status == 'cancel_pending' && apm.cancelReason != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.reason}: ${apm.cancelReason}',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
