import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../core/utils/color_theme.dart';
import 'package:intl/intl.dart';
import 'edit_working_hours_page.dart';
import '../../../../../../l10n/app_localizations.dart';

class BusinessSchedulePage extends StatefulWidget {
  const BusinessSchedulePage({Key? key}) : super(key: key);

  @override
  State<BusinessSchedulePage> createState() => _BusinessSchedulePageState();
}

class _BusinessSchedulePageState extends State<BusinessSchedulePage> {
  StoreModel? _store;
  bool _isLoading = true;
  List<StoreWorkingHourModel> _workingHours = [];
  List<Map<String, dynamic>> _holidays = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final store = await inj<StoreDatasource>().getStoreByMangerId(user.id);

      final workingHoursResponse = await Supabase.instance.client
          .from('store_working_hours')
          .select()
          .eq('store_id', store.id)
          .order('day_of_week', ascending: true);

      final workingHours = (workingHoursResponse as List)
          .map((item) => StoreWorkingHourModel.fromJson(item))
          .toList();

      final holidaysResponse = await Supabase.instance.client
          .from('holiday_schedule')
          .select()
          .eq('store_id', store.id)
          .order('id', ascending: false);

      if (mounted) {
        setState(() {
          _store = store;
          _workingHours = workingHours;
          _holidays = List<Map<String, dynamic>>.from(holidaysResponse);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.loadDataError}: ${e.toString()}')),
        );
      }
    }
  }

  String _getDayName(int dayOfWeek, BuildContext context) {
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 40,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOpeningHoursSection(),
                  const SizedBox(height: 40),
                  _buildHolidayScheduleSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildOpeningHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.openingHours,
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_store == null) return;
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditWorkingHoursPage(
                      workingHours: _workingHours,
                      storeId: _store!.id,
                    ),
                  ),
                );
                if (result == true) {
                  setState(() => _isLoading = true);
                  _fetchData();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.edit,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B4EFF), // Purplish color from image
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.openingHoursDesc,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _workingHours.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final hw = _workingHours[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDayName(hw.dayOfWeek, context),
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  hw.isDayOff
                      ? AppLocalizations.of(context)!.closed
                      : '${_formatTime(hw.startTime)} - ${_formatTime(hw.endTime)}',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showHolidayBottomSheet(
    BuildContext context, {
    Map<String, dynamic>? holiday,
  }) {
    if (_store == null) return;

    final isEdit = holiday != null;
    final nameController = TextEditingController(text: holiday?['name'] ?? '');

    DateTime initialDate = DateTime.now().add(const Duration(days: 1));
    if (isEdit) {
      final dateStr = holiday['date'] ?? holiday['start_date'] ?? '';
      if (dateStr.isNotEmpty) {
        try {
          initialDate = DateTime.parse(dateStr);
        } catch (_) {}
      }
    }

    DateTime selectedDate = initialDate;
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? AppLocalizations.of(context)!.editHoliday : AppLocalizations.of(context)!.addHoliday,
                          style: GoogleFonts.quicksand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.holidayName,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      style: GoogleFonts.quicksand(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterHolidayName,
                        hintStyle: GoogleFonts.quicksand(
                          color: Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterHolidayNameError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.holidayDate,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate:
                              DateTime.now(), // Không thể chọn ngày trước đó
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(selectedDate),
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  setModalState(() => isSaving = true);
                                  try {
                                    if (isEdit) {
                                      await Supabase.instance.client
                                          .from('holiday_schedule')
                                          .update({
                                            'name': nameController.text.trim(),
                                            'date': selectedDate
                                                .toIso8601String(),
                                          })
                                          .eq('id', holiday['id']);
                                    } else {
                                      await Supabase.instance.client
                                          .from('holiday_schedule')
                                          .insert({
                                            'store_id': _store!.id,
                                            'name': nameController.text.trim(),
                                            'date': selectedDate
                                                .toIso8601String(),
                                          });
                                    }
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      setState(() => _isLoading = true);
                                      _fetchData();
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}'),
                                        ),
                                      );
                                      setModalState(() => isSaving = false);
                                    }
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSaving
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white,
                                size: 24,
                              )
                            : Text(
                                AppLocalizations.of(context)!.save,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHolidayScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.holidaySchedule,
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                _showHolidayBottomSheet(context);
              },
              child: Text(
                AppLocalizations.of(context)!.add,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B4EFF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.holidayScheduleDesc,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        if (_holidays.isEmpty)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.noHolidaysFound,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _holidays.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final holiday = _holidays[index];
              // Assuming holiday has 'name' and 'date' or 'start_date' fields
              final name = holiday['name'] ?? AppLocalizations.of(context)!.holiday;
              final dateStr = holiday['date'] ?? holiday['start_date'] ?? '';

              String displayDate = dateStr;
              if (dateStr.isNotEmpty) {
                try {
                  final dt = DateTime.parse(dateStr);
                  displayDate = DateFormat('dd/MM/yyyy').format(dt);
                } catch (_) {}
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (displayDate.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            displayDate,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _showHolidayBottomSheet(context, holiday: holiday);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.edit,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
