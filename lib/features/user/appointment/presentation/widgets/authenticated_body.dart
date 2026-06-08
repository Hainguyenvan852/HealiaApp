import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';

class AuthenticatedBody extends StatefulWidget {
  const AuthenticatedBody({
    super.key,
    required this.appointments,
    required this.reset,
  });
  final List<AppointmentModel> appointments;
  final VoidCallback reset;

  @override
  State<AuthenticatedBody> createState() => _AuthenticatedBodyState();
}

class _AuthenticatedBodyState extends State<AuthenticatedBody> {
  final DateTime currentTime = DateTime.now();

  List<AppointmentModel> _filterAppointments(String status) {
    List<AppointmentModel> currentAppointments = List.from(widget.appointments);
    if (status.toLowerCase() == 'all') {
      currentAppointments.sort((a, b) {
        return b.startTime.compareTo(a.startTime);
      });
      return currentAppointments;
    }
    return currentAppointments
        .where((apt) => apt.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Color _colorByStatus(String status) {
    if (status.toLowerCase() == 'pending') {
      return Colors.orange;
    } else if (status.toLowerCase() == 'confirmed') {
      return Colors.blue;
    } else if (status.toLowerCase() == 'completed') {
      return Colors.green;
    } else if (status.toLowerCase() == 'cancelled') {
      return Colors.red;
    } else if (status.toLowerCase() == 'no_show') {
      return Colors.grey;
    } else {
      return Colors.orange;
    }
  }

  String _stringByStatus(String status) {
    if (status.toLowerCase() == 'pending') {
      return AppLocalizations.of(context)!.pending;
    } else if (status.toLowerCase() == 'confirmed') {
      return AppLocalizations.of(context)!.confirmed;
    } else if (status.toLowerCase() == 'completed') {
      return AppLocalizations.of(context)!.completed;
    } else if (status.toLowerCase() == 'cancelled') {
      return AppLocalizations.of(context)!.cancelled;
    } else if (status.toLowerCase() == 'no_show') {
      return AppLocalizations.of(context)!.noShow;
    } else {
      return AppLocalizations.of(context)!.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'All',
      'Pending',
      'Confirmed',
      'Completed',
      'Cancelled',
      'NoShow',
    ];

    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.deepPurpleAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurpleAccent,
              dividerColor: Colors.grey.shade300,
              labelStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              unselectedLabelStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              tabs: tabs.map((t) => Tab(text: _stringByStatus(t))).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: tabs
                    .map((tab) => _buildList(_filterAppointments(tab)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<AppointmentModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/calendar-icon.png', height: 80),
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.currentlyYouDontHaveAnyAppointments,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(top: 15, bottom: 20),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final apt = items[index];
        return GestureDetector(
          onTap: () async {
            await context.pushNamed('appointment-detail', extra: apt);

            widget.reset();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
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
                        apt.storeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _colorByStatus(
                          apt.status,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _stringByStatus(apt.status),
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _colorByStatus(apt.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd/MM/yyyy').format(apt.startTime),
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormat('hh:mm').format(apt.startTime)} - ${DateFormat('hh:mm').format(apt.endTime)}',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
