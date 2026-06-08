import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../../l10n/app_localizations.dart';

class EditWorkingHoursPage extends StatefulWidget {
  final List<StoreWorkingHourModel> workingHours;
  final int storeId;

  const EditWorkingHoursPage({
    Key? key,
    required this.workingHours,
    required this.storeId,
  }) : super(key: key);

  @override
  State<EditWorkingHoursPage> createState() => _EditWorkingHoursPageState();
}

class _EditWorkingHoursPageState extends State<EditWorkingHoursPage> {
  late List<StoreWorkingHourModel> _currentHours;
  bool _isSaving = false;
  bool _hasChanges = false;

  final List<TimeOfDay> _timeOptions = [];

  @override
  void initState() {
    super.initState();
    // Copy the working hours to a new list to avoid modifying the original until saved
    _currentHours = widget.workingHours.map((hw) {
      return StoreWorkingHourModel(
        id: hw.id,
        dayOfWeek: hw.dayOfWeek,
        startTime: hw.startTime,
        endTime: hw.endTime,
        isDayOff: hw.isDayOff,
        storeId: hw.storeId,
      );
    }).toList();

    // Generate 30-minute interval options
    for (int h = 0; h < 24; h++) {
      _timeOptions.add(TimeOfDay(hour: h, minute: 0));
      _timeOptions.add(TimeOfDay(hour: h, minute: 30));
    }
  }

  void _checkForChanges() {
    bool hasChanges = false;
    for (int i = 0; i < widget.workingHours.length; i++) {
      final original = widget.workingHours[i];
      final current = _currentHours.firstWhere(
        (element) => element.dayOfWeek == original.dayOfWeek,
      );

      if (original.isDayOff != current.isDayOff ||
          original.startTime != current.startTime ||
          original.endTime != current.endTime) {
        hasChanges = true;
        break;
      }
    }

    if (_hasChanges != hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getDayName(BuildContext context, int dayOfWeek) {
    switch (dayOfWeek) {
      case 2:
        return AppLocalizations.of(context)!.monday;
      case 3:
        return AppLocalizations.of(context)!.tuesday;
      case 4:
        return AppLocalizations.of(context)!.wednesday;
      case 5:
        return AppLocalizations.of(context)!.thursday;
      case 6:
        return AppLocalizations.of(context)!.friday;
      case 7:
        return AppLocalizations.of(context)!.saturday;
      case 8:
        return AppLocalizations.of(context)!.sunday;
      default:
        return '';
    }
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      for (var hour in _currentHours) {
        final startStr =
            '${hour.startTime.hour.toString().padLeft(2, '0')}:${hour.startTime.minute.toString().padLeft(2, '0')}:00';
        final endStr =
            '${hour.endTime.hour.toString().padLeft(2, '0')}:${hour.endTime.minute.toString().padLeft(2, '0')}:00';

        await Supabase.instance.client
            .from('store_working_hours')
            .update({
              'is_day_off': hour.isDayOff,
              'start_time': startStr,
              'end_time': endStr,
            })
            .eq('id', hour.id);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.saveError}: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.editOpeningHours,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.openingHoursDesc2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _currentHours.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final item = _currentHours[index];
                      return _buildDayItem(item, index);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildDayItem(StoreWorkingHourModel item, int index) {
    final bool isOpen = !item.isDayOff;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isOpen,
                onChanged: (bool? value) {
                  setState(() {
                    _currentHours[index].isDayOff = !(value ?? true);
                    _checkForChanges();
                  });
                },
                activeColor: const Color(0xFF6B4EFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getDayName(context, item.dayOfWeek),
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (isOpen) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTimeDropdown(item, index, true)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.toTime,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: _buildTimeDropdown(item, index, false)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimeDropdown(
    StoreWorkingHourModel item,
    int index,
    bool isStartTime,
  ) {
    TimeOfDay selectedValue = isStartTime ? item.startTime : item.endTime;

    // Build the valid options for the dropdown
    List<DropdownMenuItem<TimeOfDay>> dropdownItems = [];

    for (var time in _timeOptions) {
      // If building end time, ensure it's > start time
      if (!isStartTime) {
        if (_timeToMinutes(time) <= _timeToMinutes(item.startTime)) {
          continue; // Skip invalid end times
        }
      }

      dropdownItems.add(
        DropdownMenuItem(
          value: time,
          child: Text(
            _formatTime(time),
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // Add "24:00" equivalent if needed, but since it's TimeOfDay, we handle up to 23:30.
    // If start time is 23:30, end time would need to be the next day, but for simplicity
    // we assume max end time is 23:30. If end time list is empty, we must handle it.
    if (dropdownItems.isEmpty && !isStartTime) {
      // Fallback if no valid time (e.g. start time is 23:30)
      dropdownItems.add(
        DropdownMenuItem(
          value: const TimeOfDay(hour: 23, minute: 59),
          child: Text(
            '23:59',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      if (_timeToMinutes(selectedValue) <= _timeToMinutes(item.startTime)) {
        selectedValue = const TimeOfDay(hour: 23, minute: 59);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TimeOfDay>(
          value: selectedValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: dropdownItems,
          onChanged: (TimeOfDay? newValue) {
            if (newValue != null) {
              setState(() {
                if (isStartTime) {
                  _currentHours[index].startTime = newValue;
                  // Ensure end time is greater than start time
                  if (_timeToMinutes(_currentHours[index].endTime) <=
                      _timeToMinutes(newValue)) {
                    // Find the next available 30-min slot
                    int newEndMinutes = _timeToMinutes(newValue) + 30;
                    if (newEndMinutes >= 24 * 60) {
                      _currentHours[index].endTime = const TimeOfDay(
                        hour: 23,
                        minute: 59,
                      );
                    } else {
                      _currentHours[index].endTime = TimeOfDay(
                        hour: newEndMinutes ~/ 60,
                        minute: newEndMinutes % 60,
                      );
                    }
                  }
                } else {
                  _currentHours[index].endTime = newValue;
                }
                _checkForChanges();
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _hasChanges && !_isSaving ? _saveChanges : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: _isSaving
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 24,
                )
              : Text(
                  AppLocalizations.of(context)!.save,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _hasChanges ? Colors.white : Colors.grey.shade500,
                  ),
                ),
        ),
      ),
    );
  }
}
