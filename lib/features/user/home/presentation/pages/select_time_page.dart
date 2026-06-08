import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/injector/dependency_injector.dart';

class SelectTimePage extends StatefulWidget {
  const SelectTimePage({
    super.key,
    this.professionals,
    this.selectedProfessional,
  });
  final List<StaffModel>? professionals;
  final StaffModel? selectedProfessional;

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  late DateTime _selectedDate;
  late List<DateTime> _availableDates;
  StaffModel? _selectedProfessional;
  late String _selectedProfessionalName;
  final supabase = Supabase.instance.client;

  late Future<List<AppointmentModel>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    _selectedProfessionalName = widget.selectedProfessional != null
        ? (widget.selectedProfessional!.id != 0
              ? widget.selectedProfessional!.fullName
              : 'Any professional')
        : 'None';

    _selectedProfessional = widget.selectedProfessional;
    _selectedDate = today;

    _availableDates = List.generate(
      60,
      (index) => today.add(Duration(days: index)),
    );

    _fetchAppointmentsForSelectedDate();
  }

  void _fetchAppointmentsForSelectedDate() {
    _appointmentsFuture = _mockFetchAppointments(_selectedDate);
  }

  Future<List<AppointmentModel>> _mockFetchAppointments(DateTime date) async {
    final store = context.read<BookingCubit>().state.currentStore;
    if (store == null) return [];

    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();
    final endOfDay = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
    ).toIso8601String();

    try {
      var query = supabase
          .from('appointments')
          .select('id, start_time, end_time, status')
          .eq('store_id', store.id)
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .inFilter('status', ['confirmed', 'pending']);

      if (store.storeType == 'team' &&
          _selectedProfessional != null &&
          _selectedProfessional!.id != 0) {
        query = query.eq('member_id', _selectedProfessional!.id);
      }

      final response = await query;

      return response
          .map(
            (e) => AppointmentModel(
              id: e['id'] as int,
              startTime: DateTime.parse(e['start_time']),
              endTime: DateTime.parse(e['end_time']),
              status: e['status'] as String,
              storeAddress: '',
              storeName: '',
              totalPrice: 0,
              createdAt: DateTime.now(),
              storeId: store.id,
              services: [],
              customerName: '',
              clientId: 0,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      return [];
    }
  }

  List<String> _getAvailableTimeSlots(
    StoreWorkingHourModel workingHour,
    List<AppointmentModel> appointments,
  ) {
    List<String> slots = [];
    int currentHour = workingHour.startTime.hour;
    int currentMinute = workingHour.startTime.minute;

    int endHour = workingHour.endTime.hour;
    int endMinute = workingHour.endTime.minute;
    int totalEndMinutes = endHour * 60 + endMinute;

    final services = context.read<BookingCubit>().state.services;
    int totalDurationT = 0;
    for (var s in services!) {
      totalDurationT += s.duration;
    }
    if (totalDurationT == 0) totalDurationT = 30;

    int capacity = 1;
    final store = context.read<BookingCubit>().state.currentStore;
    if (store?.storeType == 'team' &&
        _selectedProfessional != null &&
        _selectedProfessional!.id == 0) {
      capacity = widget.professionals?.length ?? 1;
    }

    while (currentHour < endHour ||
        (currentHour == endHour && currentMinute < endMinute)) {
      int slotStartInMinutes = currentHour * 60 + currentMinute;
      int slotEndInMinutes = slotStartInMinutes + totalDurationT;

      if (slotEndInMinutes > totalEndMinutes) {
        currentMinute += 30;
        if (currentMinute >= 60) {
          currentHour += 1;
          currentMinute -= 60;
        }
        continue;
      }

      int overlappingCount = 0;

      for (var appt in appointments) {
        int apptStart = appt.startTime.hour * 60 + appt.startTime.minute;
        int apptEnd = appt.endTime.hour * 60 + appt.endTime.minute;

        if (slotStartInMinutes < apptEnd && slotEndInMinutes > apptStart) {
          overlappingCount++;
        }
      }

      if (overlappingCount < capacity) {
        final formattedTime =
            '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}';
        slots.add(formattedTime);
      }

      currentMinute += 30;
      if (currentMinute >= 60) {
        currentHour += 1;
        currentMinute -= 60;
      }
    }
    return slots;
  }

  Future<StaffModel?> _openProfessionalBottomSheet(
    List<StaffModel> professionals,
    StaffModel selectedProfessional,
  ) async {
    final response = await showModalBottomSheet<StaffModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.9,
            child: SelectProfessionalScreen(
              professionals: professionals,
              selectedProfessional: selectedProfessional,
            ),
          ),
        );
      },
    );

    return response;
  }

  void _openCalendarBottomSheet() async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarBottomSheet(initialDate: _selectedDate),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _fetchAppointmentsForSelectedDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String monthYearDisplay = DateFormat('MMM yyyy').format(_selectedDate);

    final storeWorkingHours = context
        .read<StoreInfomationCubit>()
        .state
        .workingHours;

    final int currentDayOfWeek = _selectedDate.weekday + 1;

    StoreWorkingHourModel? currentWorkingHour;
    try {
      currentWorkingHour = storeWorkingHours.firstWhere(
        (w) => w.dayOfWeek == currentDayOfWeek,
      );
    } catch (e) {
      currentWorkingHour = null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<BookingCubit>().clearProfessional();
                          context.pop(context);
                        },
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.arrowLeft,
                          size: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomSheetHelper.showExitConfirmationBottomSheet(
                            context: context,
                            onExit: () {
                              context
                                  .read<BookingCubit>()
                                  .clearAllExpectStore();
                              Navigator.popUntil(
                                context,
                                (route) =>
                                    route.settings.name == 'store-detail',
                              );
                            },
                          );
                        },
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.x,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.selectTime,
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (widget.selectedProfessional != null &&
                              widget.professionals != null)
                          ? InkWell(
                              onTap: () async {
                                final result =
                                    await _openProfessionalBottomSheet(
                                      widget.professionals!,
                                      _selectedProfessional!,
                                    );

                                if (result != null) {
                                  setState(() {
                                    _selectedProfessionalName = result.fullName;
                                    _selectedProfessional = result;
                                    _fetchAppointmentsForSelectedDate();
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF2EFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: _selectedProfessional!.id == 0
                                          ? const PhosphorIcon(
                                              PhosphorIconsRegular.user,
                                              size: 16,
                                              color: Color(0xFF5B45FF),
                                            )
                                          : (_selectedProfessional!.avatarUrl !=
                                                    null
                                                ? Image.network(
                                                    _selectedProfessional!
                                                        .avatarUrl!,
                                                    height: 30,
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const PhosphorIcon(
                                                    PhosphorIconsRegular.user,
                                                    size: 16,
                                                    color: Color(0xFF5B45FF),
                                                  )),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedProfessionalName,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const PhosphorIcon(
                                      PhosphorIconsRegular.caretDown,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      InkWell(
                        onTap: _openCalendarBottomSheet,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: const PhosphorIcon(
                            PhosphorIconsRegular.calendarBlank,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                monthYearDisplay,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _availableDates.length,
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected =
                      date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;

                  return _buildDateItem(date, isSelected);
                },
              ),
            ),
            const SizedBox(height: 16),

            Expanded(child: _buildTimeSlotsArea(currentWorkingHour)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsArea(StoreWorkingHourModel? workingHour) {
    if (workingHour == null || workingHour.isDayOff) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.closeDay,
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    return FutureBuilder<List<AppointmentModel>>(
      future: _appointmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5B45FF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.errorCheckCalendar,
              style: GoogleFonts.quicksand(color: Colors.red),
            ),
          );
        }

        final appointments = snapshot.data ?? [];
        final availableSlots = _getAvailableTimeSlots(
          workingHour,
          appointments,
        );

        if (availableSlots.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.slotFull,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: availableSlots.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildTimeSlotItem(availableSlots[index]);
          },
        );
      },
    );
  }

  Widget _buildDateItem(DateTime date, bool isSelected) {
    String dayNumber = DateFormat('d').format(date);
    String dayOfWeek = DateFormat('E').format(date);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _fetchAppointmentsForSelectedDate();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5B45FF)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5B45FF)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayOfWeek,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotItem(String time) {
    return InkWell(
      onTap: () {
        final user = inj<CheckCurrentUserUseCase>().call();
        if (user == null) {
          final String currentPath = GoRouterState.of(context).uri.toString();
          context.push('/login?from=$currentPath');
        } else {
          final parts = time.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          context.read<BookingCubit>().selectDateTime(
            _selectedDate,
            DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              hour,
              minute,
            ),
          );
          context.pushNamed('review-confirm');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  const CalendarBottomSheet({super.key, required this.initialDate});

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  late DateTime _minMonth;
  late DateTime _maxMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;

    DateTime now = DateTime.now();
    _minMonth = DateTime(now.year, now.month, 1);
    _maxMonth = DateTime(now.year, now.month + 1, 1);

    DateTime initialMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      1,
    );
    if (initialMonth.isBefore(_minMonth)) {
      _displayedMonth = _minMonth;
    } else if (initialMonth.isAfter(_maxMonth)) {
      _displayedMonth = _maxMonth;
    } else {
      _displayedMonth = initialMonth;
    }
  }

  void _changeMonth(int offset) {
    DateTime nextMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + offset,
      1,
    );

    if (nextMonth.isAtSameMomentAs(_minMonth) ||
        nextMonth.isAtSameMomentAs(_maxMonth)) {
      setState(() {
        _displayedMonth = nextMonth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String monthYearDisplay = DateFormat('MMMM yyyy').format(_displayedMonth);

    bool canGoBack = _displayedMonth.isAfter(_minMonth);
    bool canGoForward = _displayedMonth.isBefore(_maxMonth);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.caretLeft,
                      color: canGoBack ? Colors.black : Colors.grey.shade300,
                    ),
                    onPressed: canGoBack ? () => _changeMonth(-1) : null,
                  ),
                  Text(
                    monthYearDisplay,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: PhosphorIcon(
                      PhosphorIconsRegular.caretRight,
                      color: canGoForward ? Colors.black : Colors.grey.shade300,
                    ),
                    onPressed: canGoForward ? () => _changeMonth(1) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCalendarGrid(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    const List<String> weekDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    int firstDayWeekday = _displayedMonth.weekday;
    if (firstDayWeekday == 7) firstDayWeekday = 0;

    int daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    int totalCells = firstDayWeekday + daysInMonth;
    int rows = (totalCells / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < firstDayWeekday || index >= totalCells) {
              return const SizedBox();
            }

            int dayNumber = index - firstDayWeekday + 1;
            DateTime cellDate = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              dayNumber,
            );

            bool isPastDay = cellDate.isBefore(
              DateTime.now().subtract(const Duration(days: 1)),
            );

            bool isSelected =
                cellDate.year == _selectedDate.year &&
                cellDate.month == _selectedDate.month &&
                cellDate.day == _selectedDate.day;

            return GestureDetector(
              onTap: isPastDay
                  ? null
                  : () {
                      Navigator.pop(context, cellDate);
                    },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5B45FF)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isPastDay ? Colors.grey.shade300 : Colors.black),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SelectProfessionalScreen extends StatefulWidget {
  const SelectProfessionalScreen({
    super.key,
    required this.professionals,
    required this.selectedProfessional,
  });
  final List<StaffModel> professionals;
  final StaffModel selectedProfessional;

  @override
  State<SelectProfessionalScreen> createState() =>
      _SelectProfessionalScreenState();
}

class _SelectProfessionalScreenState extends State<SelectProfessionalScreen> {
  late int _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedProfessional.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.x,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.selectProfessional,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.professionals.length + 1,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildNoPreference(_selectedId == 0);
                  }
                  final item = widget.professionals[index - 1];
                  final isSelected = _selectedId == item.id;
                  return _buildProfessionalItem(item, isSelected);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalItem(StaffModel item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          _buildAvatar(item),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fullName,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (item.jobTitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.jobTitle!,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isSelected ? _buildVerifyIcon() : _buildSelectButton(item),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPreference(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF2EFFF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: PhosphorIcon(
                PhosphorIconsRegular.users,
                color: Color(0xFF5B45FF),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.noPreference,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.forMaximumAvailability,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isSelected
                ? _buildVerifyIcon()
                : OutlinedButton(
                    key: const ValueKey('select_btn'),
                    onPressed: () {
                      setState(() {
                        _selectedId = 0;
                      });
                      context.read<BookingCubit>().selectProfessional(
                        StaffModel(
                          id: 0,
                          fullName: 'Any professional',
                          email: '',
                          phoneNumber: '',
                          jobTitle: '',
                          birthDay: DateTime(2026),
                          startDate: DateTime(2026),
                          isActive: true,
                        ),
                      );
                      Navigator.pop(
                        context,
                        StaffModel(
                          id: 0,
                          fullName: 'Any professional',
                          email: '',
                          phoneNumber: '',
                          jobTitle: '',
                          birthDay: DateTime(2026),
                          startDate: DateTime(2026),
                          isActive: true,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      disabledForegroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.select,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(StaffModel item) {
    if (item.id == 0) {
      return Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFF2EFFF),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: PhosphorIcon(
            PhosphorIconsRegular.users,
            color: Color(0xFF5B45FF),
            size: 28,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(item.avatarUrl ?? ''),
      onBackgroundImageError: (e, s) {},
    );
  }

  Widget _buildSelectButton(StaffModel item) {
    return OutlinedButton(
      key: const ValueKey('select_btn'),
      onPressed: () {
        if (_selectedId != item.id) {
          setState(() {
            _selectedId = item.id;
          });

          context.read<BookingCubit>().selectProfessional(
            widget.professionals.singleWhere((i) => i.id == _selectedId),
          );

          Navigator.pop(
            context,
            widget.professionals.singleWhere((i) => i.id == _selectedId),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        disabledForegroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        minimumSize: const Size(0, 36),
      ),
      child: Text(
        AppLocalizations.of(context)!.select,
        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildVerifyIcon() {
    return Container(
      key: const ValueKey('verify_icon'),
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF5B45FF),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: PhosphorIcon(
          PhosphorIconsRegular.check,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
