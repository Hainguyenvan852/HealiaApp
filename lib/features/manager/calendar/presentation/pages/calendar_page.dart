import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/add_appointment_page.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/appointment_detail.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../l10n/app_localizations.dart';
import 'manager_profile_page.dart';
import 'notification_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  CalendarView _currentView = CalendarView.day;
  final ValueNotifier<String> _headerTextNotifier = ValueNotifier<String>('');
  bool _isLoading = true;
  final _MeetingDataSource _dataSource = _MeetingDataSource([]);
  late RealtimeChannel _appointmentSubscription;

  @override
  void initState() {
    super.initState();
    _calendarController.view = _currentView;
    _loadAppoiment();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    _appointmentSubscription = Supabase.instance.client
        .channel('public:appointments:calendar_${widget.currentUser.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'appointments',
          callback: (payload) {
            if (mounted) {
              _loadAppoiment(); // Updates datasource directly without rebuilding calendar
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_appointmentSubscription);
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        _calendarController.displayDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.quicksandTextTheme(),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B4EFF),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B4EFF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _calendarController.displayDate = picked;
      });
    }
  }

  void _onCalendarTapped(CalendarTapDetails details, List<Appointment> apms) {
    if (details.targetElement == CalendarElement.calendarCell) {
      if (_currentView == CalendarView.month) {
        setState(() {
          _currentView = CalendarView.day;
          _calendarController.view = CalendarView.day;
        });
      } else {
        if (details.date != null) {
          final DateTime slotStart = details.date!.toLocal();
          final DateTime slotEnd = slotStart.add(const Duration(hours: 1));

          final List<Appointment> dayAppointments = apms.where((apm) {
            final DateTime apmLocalStart = apm.startTime.toLocal();

            return apmLocalStart.year == slotStart.year &&
                apmLocalStart.month == slotStart.month &&
                apmLocalStart.day == slotStart.day &&
                apm is StoreAppointment;
          }).toList();

          dayAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

          final List<Appointment> intersectingApms = dayAppointments.where((
            apm,
          ) {
            return apm.startTime.isBefore(slotEnd) &&
                apm.endTime.isAfter(slotStart);
          }).toList();

          DateTime? finalSelectedDate;
          int? availableMinutes;

          if (intersectingApms.isEmpty) {
            finalSelectedDate = slotStart;
            final nextApm = dayAppointments.firstWhere(
              (apm) =>
                  apm.startTime.isAfter(slotStart) ||
                  apm.startTime.isAtSameMomentAs(slotEnd),
              orElse: () => Appointment(
                startTime: slotStart.add(const Duration(days: 1)),
                endTime: slotStart.add(const Duration(days: 1)),
              ),
            );
            availableMinutes = nextApm.startTime
                .difference(slotStart)
                .inMinutes;
          } else {
            final apm = intersectingApms.first;

            final int startMin = apm.startTime.isBefore(slotStart)
                ? 0
                : apm.startTime.minute;
            final int endMin = apm.endTime.isAfter(slotEnd)
                ? 60
                : (apm.endTime.hour > slotStart.hour ? 60 : apm.endTime.minute);

            if (startMin == 0 && endMin <= 30) {
              finalSelectedDate = slotStart.add(Duration(minutes: 30));

              final nextApm = dayAppointments.firstWhere(
                (a) => a.startTime.isAfter(finalSelectedDate!),
                orElse: () => Appointment(
                  startTime: slotStart.add(const Duration(days: 1)),
                  endTime: slotStart.add(const Duration(days: 1)),
                ),
              );
              availableMinutes = nextApm.startTime
                  .difference(finalSelectedDate)
                  .inMinutes;
            } else if (startMin == 0 && endMin > 30 && endMin < 60) {
              return;
            } else if (startMin >= 30 && endMin == 60) {
              finalSelectedDate = slotStart;
              availableMinutes = startMin;
            } else if (startMin > 0 && endMin < 60) {
              final int freeBefore = startMin;
              final int freeAfter = 60 - endMin;

              if (freeBefore < 30 && freeAfter < 30) {
                return;
              } else if (freeBefore >= 30) {
                finalSelectedDate = slotStart;
                availableMinutes = freeBefore;
              }
            }
          }

          if (finalSelectedDate != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAppointmentPage(
                  selectedDate: finalSelectedDate!,
                  managerId: widget.currentUser.id,
                  availableMinutes: availableMinutes,
                ),
              ),
            );
          }
        }
      }
    } else if (details.targetElement == CalendarElement.appointment) {
      final Appointment appointment = details.appointments!.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentDetailPage(appointment: appointment),
        ),
      );
    }
  }

  Color colorByStatus(String status) {
    switch (status) {
      case 'pending':
        return Colors.yellowAccent;
      case 'confirmed':
        return Colors.lightBlueAccent;
      case 'completed':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.grey;
      case 'no_show':
        return Colors.red;
      case 'cancel_pending':
        return Colors.orange;
      default:
        return Colors.lightBlueAccent;
    }
  }

  Future<void> _loadAppoiment() async {
    final store = await inj<StoreDatasource>().getStoreByMangerId(
      widget.currentUser.id,
    );

    final appointments = await inj<AppointmentDatasource>()
        .fetchStoreAppointments(store.id);

    List<Appointment> apms = appointments.map<Appointment>((e) {
      String service = '';
      for (var i in e.services) {
        service += '\n${i.name}';
      }
      return StoreAppointment(
        model: e,
        id: e.id,
        startTime: e.startTime,
        endTime: e.endTime,
        color: colorByStatus(e.status),
        subject:
            '${DateFormat('HH:mm').format(e.startTime)} - ${DateFormat('HH:mm').format(e.endTime)} ${e.customerName}$service',
      );
    }).toList();

    _dataSource.updateAppointments(apms);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onViewChanged(ViewChangedDetails details) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      String newHeaderText = '';
      if (_calendarController.view == CalendarView.month) {
        newHeaderText = DateFormat(
          'MMMM yyyy',
          'en',
        ).format(details.visibleDates[details.visibleDates.length ~/ 2]);
      } else {
        final date = details.visibleDates[0];
        newHeaderText = DateFormat('EEE, dd MMM').format(date);
      }

      if (_headerTextNotifier.value != newHeaderText) {
        _headerTextNotifier.value = newHeaderText;
      }
    });
  }

  void _showCalendarViewsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.calendarViews,
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildViewOptionButton(
                    AppLocalizations.of(context)!.day,
                    Icons.calendar_view_day_outlined,
                    CalendarView.day,
                  ),
                  _buildViewOptionButton(
                    AppLocalizations.of(context)!.week,
                    Icons.view_week_outlined,
                    CalendarView.week,
                  ),
                  _buildViewOptionButton(
                    AppLocalizations.of(context)!.month,
                    Icons.calendar_month_outlined,
                    CalendarView.month,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewOptionButton(
    String title,
    IconData icon,
    CalendarView viewValue,
  ) {
    bool isSelected = _currentView == viewValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentView = viewValue;
          _calendarController.view = viewValue;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B4EFF) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF6B4EFF) : Colors.black87,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF6B4EFF) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
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
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: _showCalendarViewsModal,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: ValueListenableBuilder<String>(
                valueListenable: _headerTextNotifier,
                builder: (context, value, child) {
                  return Text(
                    value.isNotEmpty
                        ? value
                        : AppLocalizations.of(context)!.calendar,
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 15),
        actions: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            ),
            child: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold), size: 25),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ManagerProfilePage(currentUser: widget.currentUser),
              ),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: widget.currentUser.avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: widget.currentUser.avatarUrl!,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) {
                            return Text(
                              widget.currentUser.fullName[0],
                              style: GoogleFonts.quicksand(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        widget.currentUser.fullName[0],
                        style: GoogleFonts.quicksand(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading && _dataSource.appointments!.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            )
          : SfCalendar(
              controller: _calendarController,
              dataSource: _dataSource,
              onViewChanged: _onViewChanged,
              onTap: (details) => _onCalendarTapped(
                details,
                _dataSource.appointments as List<Appointment>,
              ),
              todayHighlightColor: const Color(0xFF6B4EFF),
              headerHeight: 0,
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 0,
                endHour: 24,
                timeIntervalHeight: 80,
                timeFormat: 'HH:mm',
                timeTextStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true,
              ),
              weekNumberStyle: WeekNumberStyle(
                textStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              headerStyle: CalendarHeaderStyle(
                textStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              todayTextStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
              ),
              appointmentTextStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  void updateAppointments(List<Appointment> source) {
    appointments = source;
    notifyListeners(CalendarDataSourceAction.reset, source);
  }
}
