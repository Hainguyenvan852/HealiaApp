import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/update_appointment_usecase.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/domain/usecases/get_opening_hours_usecase.dart';
import 'package:healio_app/features/user/home/presentation/pages/select_time_page.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../l10n/app_localizations.dart';

class EditAppointmentBottomSheet extends StatefulWidget {
  final AppointmentModel appointment;

  const EditAppointmentBottomSheet({super.key, required this.appointment});

  @override
  State<EditAppointmentBottomSheet> createState() =>
      _EditAppointmentBottomSheetState();
}

class _EditAppointmentBottomSheetState
    extends State<EditAppointmentBottomSheet> {
  late DateTime _selectedDate;
  String? _selectedTime;
  List<StoreWorkingHourModel> _workingHours = [];
  bool _isLoading = true;
  bool _isSaving = false;
  List<String> _availableSlots = [];
  late TextEditingController _notesController;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.appointment.startTime;
    _selectedTime =
        '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';
    _notesController = TextEditingController(text: widget.appointment.notes);
    _fetchWorkingHours();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchWorkingHours() async {
    try {
      _workingHours = await inj<GetOpeningHoursUsecase>().call(
        widget.appointment.storeId,
      );
      await _fetchAppointmentsForSelectedDate();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching working hours: $e');
    }
  }

  Future<void> _fetchAppointmentsForSelectedDate() async {
    setState(() {
      _isLoading = true;
    });

    final startOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    ).toIso8601String();
    final endOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      23,
      59,
      59,
    ).toIso8601String();

    try {
      var query = _supabase
          .from('appointments')
          .select('id, start_time, end_time, status')
          .eq('store_id', widget.appointment.storeId)
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .inFilter('status', ['confirmed', 'pending'])
          .neq('id', widget.appointment.id);

      if (widget.appointment.professionalId != null &&
          widget.appointment.professionalId != 0) {
        query = query.eq('member_id', widget.appointment.professionalId!);
      }

      final response = await query;

      final appointments = response
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
              storeId: widget.appointment.storeId,
              services: [],
              customerName: '',
              clientId: 0,
            ),
          )
          .toList();

      final currentDayOfWeek = _selectedDate.weekday + 1;
      StoreWorkingHourModel? workingHour;
      try {
        workingHour = _workingHours.firstWhere(
          (w) => w.dayOfWeek == currentDayOfWeek,
        );
      } catch (e) {
        workingHour = null;
      }

      if (workingHour != null && !workingHour.isDayOff) {
        _availableSlots = _getAvailableTimeSlots(workingHour, appointments);
      } else {
        _availableSlots = [];
      }

      // If selected date is today, and the initial time is in the past, or if we switched date and it's not available, reset it.
      if (!_availableSlots.contains(_selectedTime)) {
        // But wait, if it's the SAME day as the original appointment, the original time might be in the past now but they still hold it!
        // Let's add the original time to the list if the date is the same as original.
        final originalDate = widget.appointment.startTime;
        if (_selectedDate.year == originalDate.year &&
            _selectedDate.month == originalDate.month &&
            _selectedDate.day == originalDate.day) {
          final origTime =
              '${originalDate.hour.toString().padLeft(2, '0')}:${originalDate.minute.toString().padLeft(2, '0')}';
          if (!_availableSlots.contains(origTime)) {
            _availableSlots.add(origTime);
            _availableSlots.sort();
          }
        } else {
          _selectedTime = _availableSlots.isNotEmpty
              ? _availableSlots.first
              : null;
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching appointments: $e');
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

    int totalDurationT = 0;
    for (var s in widget.appointment.services) {
      totalDurationT += s.duration;
    }
    if (totalDurationT == 0) totalDurationT = 30;

    final now = DateTime.now();
    final isToday =
        _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    final currentMinutesOfDay = now.hour * 60 + now.minute;

    int capacity = 1;

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

      if (isToday && slotStartInMinutes <= currentMinutesOfDay) {
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

  void _openCalendar() async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarBottomSheet(initialDate: _selectedDate),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _fetchAppointmentsForSelectedDate();
    }
  }

  void _onSave() async {
    if (_selectedTime == null) return;

    setState(() {
      _isSaving = true;
    });

    final parts = _selectedTime!.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );

    int totalDurationT = 0;
    for (var s in widget.appointment.services) {
      totalDurationT += s.duration;
    }
    if (totalDurationT == 0) totalDurationT = 30;

    final endTime = startTime.add(Duration(minutes: totalDurationT));

    try {
      await inj<UpdateAppointmentUseCase>().call(
        widget.appointment.id,
        startTime,
        endTime,
        _notesController.text,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
      debugPrint('Update error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.editAppointment,
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.date,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _openCalendar,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM. dd, yyyy').format(_selectedDate),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const PhosphorIcon(
                    PhosphorIconsRegular.calendarBlank,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.time,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF5B45FF)),
            )
          else if (_availableSlots.isEmpty)
            Text(
              AppLocalizations.of(context)!.noAvailableSlots,
              style: GoogleFonts.quicksand(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedTime,
                  items: _availableSlots.map((String slot) {
                    return DropdownMenuItem<String>(
                      value: slot,
                      child: Text(
                        slot,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value;
                    });
                  },
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.notes,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.anySpecialRequests,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isSaving || _selectedTime == null ? null : _onSave,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.saveChange,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
