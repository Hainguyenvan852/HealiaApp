import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import '../../../../../l10n/app_localizations.dart';

enum ApptStatus { all, pending, confirmed, completed, cancelled, no_show }

class ClientAppointmentsPage extends StatefulWidget {
  final ClientModel client;
  const ClientAppointmentsPage({super.key, required this.client});

  @override
  State<ClientAppointmentsPage> createState() => _ClientAppointmentsPageState();
}

class _ClientAppointmentsPageState extends State<ClientAppointmentsPage> {
  ApptStatus _selectedFilter = ApptStatus.all;
  late Future<List<AppointmentModel>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = inj<AppointmentDatasource>().fetchClientAppointments(
      widget.client.id,
      widget.client.storeId,
    );
  }

  ApptStatus _mapStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'pending':
        return ApptStatus.pending;
      case 'confirmed':
        return ApptStatus.confirmed;
      case 'completed':
        return ApptStatus.completed;
      case 'cancelled':
        return ApptStatus.cancelled;
      case 'no_show':
        return ApptStatus.no_show;
      default:
        return ApptStatus.all;
    }
  }

  List<AppointmentModel> _filterAppointments(
    List<AppointmentModel> allAppointments,
  ) {
    if (_selectedFilter == ApptStatus.all) {
      return allAppointments;
    }
    return allAppointments
        .where((app) => _mapStatus(app.status) == _selectedFilter)
        .toList();
  }

  void _showExtraFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                _buildSheetItem(
                  AppLocalizations.of(context)!.confirmed,
                  ApptStatus.confirmed,
                ),
                _buildSheetItem(
                  AppLocalizations.of(context)!.completed,
                  ApptStatus.completed,
                ),
                _buildSheetItem(
                  AppLocalizations.of(context)!.cancelled,
                  ApptStatus.cancelled,
                ),
                _buildSheetItem(
                  AppLocalizations.of(context)!.noShow,
                  ApptStatus.no_show,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetItem(String title, ApptStatus status) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: _selectedFilter == status
                ? FontWeight.bold
                : FontWeight.w600,
            color: _selectedFilter == status
                ? const Color(0xFF6B4EFF)
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientName = widget.client.fullName;
    final initial = clientName.isNotEmpty ? clientName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Text(
                initial,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF6B4EFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              clientName,
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.appointments,
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterPill(
                  AppLocalizations.of(context)!.all,
                  ApptStatus.all,
                ),
                const SizedBox(width: 12),
                _buildFilterPill(
                  AppLocalizations.of(context)!.pending,
                  ApptStatus.pending,
                ),
                const SizedBox(width: 12),
                _buildDropdownPill(),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<AppointmentModel>>(
              future: _appointmentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.mainAppColor(),
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.quicksand(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noDataAvailable,
                      style: GoogleFonts.quicksand(color: Colors.grey),
                    ),
                  );
                }

                final allAppointments = snapshot.data!;
                final filteredAppointments = _filterAppointments(
                  allAppointments,
                );

                if (filteredAppointments.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noDataAvailable,
                      style: GoogleFonts.quicksand(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 40,
                  ),
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appt = filteredAppointments[index];
                    final bool isLast =
                        index == filteredAppointments.length - 1;
                    return _buildTimelineItem(appt, isLast);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, ApptStatus status) {
    bool isActive = _selectedFilter == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPill() {
    bool isDropdownActive =
        _selectedFilter != ApptStatus.all &&
        _selectedFilter != ApptStatus.pending;
    String displayText = isDropdownActive
        ? _getStatusText(context, _selectedFilter)
        : AppLocalizations.of(context)!.more;

    return GestureDetector(
      onTap: _showExtraFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDropdownActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDropdownActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              displayText,
              style: GoogleFonts.quicksand(
                color: isDropdownActive ? Colors.white : Colors.black87,
                fontWeight: isDropdownActive
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: isDropdownActive ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(AppointmentModel data, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _buildAppointmentCard(data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel data) {
    String dayStr = DateFormat(
      'dd MMM - HH:mm',
      'vi',
    ).format(data.startTime).replaceAll('Th ', 'CN ');
    String timeStr = DateFormat('HH:mm').format(data.startTime);

    int durationMins = data.endTime.difference(data.startTime).inMinutes;
    String durationStr = durationMins > 60
        ? '${durationMins ~/ 60} ${AppLocalizations.of(context)!.hour} ${durationMins % 60 > 0 ? '${durationMins % 60} ${AppLocalizations.of(context)!.minute}' : ''}'
        : '$durationMins ${AppLocalizations.of(context)!.minute}';

    ApptStatus currentStatus = _mapStatus(data.status);
    Color badgeBg = _getBadgeBgColor(currentStatus);
    Color badgeTextCol = _getBadgeTextColor(currentStatus);
    String statusText = _getStatusText(context, currentStatus);

    String serviceName = data.services.isNotEmpty
        ? data.services.first.name
        : AppLocalizations.of(context)!.unknownService;
    String staffName = data.professionalName ?? '';
    int price = data.totalPrice.toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appointment,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayStr',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.quicksand(
                    color: badgeTextCol,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text(
                '$price đ',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            staffName.isNotEmpty
                ? '$timeStr • $durationStr • $staffName'
                : '$timeStr • $durationStr',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BuildContext context, ApptStatus status) {
    switch (status) {
      case ApptStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case ApptStatus.confirmed:
        return AppLocalizations.of(context)!.confirmed;
      case ApptStatus.completed:
        return AppLocalizations.of(context)!.completed;
      case ApptStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
      case ApptStatus.no_show:
        return AppLocalizations.of(context)!.noShow;
      default:
        return '';
    }
  }

  Color _getBadgeBgColor(ApptStatus status) {
    switch (status) {
      case ApptStatus.pending:
        return Colors.blue.shade50;
      case ApptStatus.cancelled:
        return Colors.red.shade50;
      case ApptStatus.confirmed:
        return Colors.purple.shade50;
      case ApptStatus.completed:
        return Colors.green.shade50;
      case ApptStatus.no_show:
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getBadgeTextColor(ApptStatus status) {
    switch (status) {
      case ApptStatus.pending:
        return Colors.blue.shade700;
      case ApptStatus.cancelled:
        return Colors.red.shade700;
      case ApptStatus.confirmed:
        return const Color(0xFF6B4EFF);
      case ApptStatus.completed:
        return Colors.green.shade700;
      case ApptStatus.no_show:
        return Colors.orange.shade700;
      default:
        return Colors.black;
    }
  }
}
