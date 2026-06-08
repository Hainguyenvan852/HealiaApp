import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../core/utils/color_theme.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  String _selectedRangePreset = 'Last 30 days';
  late DateTime _startDate;
  late DateTime _endDate;

  List<AppointmentModel> _allAppointments = [];
  List<AppointmentModel> _filteredAppointments = [];
  bool _isLoading = true;

  final List<String> _presets = [
    'Yesterday',
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Last year',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    _applyPreset('Last 30 days');
    _fetchData();
  }

  String _localizePreset(String preset) {
    switch (preset) {
      case 'Yesterday':
        return AppLocalizations.of(context)!.yesterday;
      case 'Last 7 days':
        return AppLocalizations.of(context)!.last7Days;
      case 'Last 30 days':
        return AppLocalizations.of(context)!.last30Days;
      case 'Last 3 months':
        return AppLocalizations.of(context)!.last3Months;
      case 'Last 6 months':
        return AppLocalizations.of(context)!.last6Months;
      case 'Last year':
        return AppLocalizations.of(context)!.lastYear;
      case 'Custom':
        return AppLocalizations.of(context)!.customDate;
      default:
        return preset;
    }
  }

  void _applyPreset(String preset) {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (preset) {
      case 'Yesterday':
        start = now.subtract(const Duration(days: 1));
        end = now.subtract(const Duration(days: 1));
        break;
      case 'Last 7 days':
        start = now.subtract(const Duration(days: 7));
        end = now;
        break;
      case 'Last 30 days':
        start = now.subtract(const Duration(days: 30));
        end = now;
        break;
      case 'Last 3 months':
        start = DateTime(now.year, now.month - 3, now.day);
        end = now;
        break;
      case 'Last 6 months':
        start = DateTime(now.year, now.month - 6, now.day);
        end = now;
        break;
      case 'Last year':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        break;
      case 'Custom':
      default:
        return;
    }

    setState(() {
      _selectedRangePreset = preset;
      _startDate = start;
      _endDate = end;
      _filterData();
    });
  }

  void _showFilterBottomSheet() {
    String tempPreset = _selectedRangePreset;
    DateTime tempStart = _startDate;
    DateTime tempEnd = _endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void _syncTempPreset() {
              DateTime now = DateTime.now();
              DateTime today = DateTime(now.year, now.month, now.day);
              DateTime s = DateTime(
                tempStart.year,
                tempStart.month,
                tempStart.day,
              );
              DateTime e = DateTime(tempEnd.year, tempEnd.month, tempEnd.day);

              String newPreset = 'Custom';
              if (e.isAtSameMomentAs(today) &&
                  s.isAtSameMomentAs(
                    today.subtract(const Duration(days: 30)),
                  )) {
                newPreset = 'Last 30 days';
              }

              setModalState(() => tempPreset = newPreset);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.filter,
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.dateRange,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: tempPreset,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        items: _presets
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  _localizePreset(v),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              tempPreset = val;
                              DateTime now = DateTime.now();
                              if (val == 'Last 30 days') {
                                tempStart = now.subtract(
                                  const Duration(days: 30),
                                );
                                tempEnd = now;
                              } else if (val == 'Last 7 days') {
                                tempStart = now.subtract(
                                  const Duration(days: 7),
                                );
                                tempEnd = now;
                              } else if (val == 'Yesterday') {
                                tempStart = now.subtract(
                                  const Duration(days: 1),
                                );
                                tempEnd = now.subtract(const Duration(days: 1));
                              } else if (val == 'Last 3 months') {
                                tempStart = DateTime(
                                  now.year,
                                  now.month - 3,
                                  now.day,
                                );
                                tempEnd = now;
                              } else if (val == 'Last 6 months') {
                                tempStart = DateTime(
                                  now.year,
                                  now.month - 6,
                                  now.day,
                                );
                                tempEnd = now;
                              } else if (val == 'Last year') {
                                tempStart = DateTime(now.year - 1, 1, 1);
                                tempEnd = DateTime(now.year - 1, 12, 31);
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.startDate,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: tempStart,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        setModalState(() {
                          tempStart = d;
                          if (tempStart.isAfter(tempEnd)) {
                            tempEnd = tempStart.add(const Duration(days: 1));
                          }
                          _syncTempPreset();
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _dateFormat.format(tempStart),
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.endDate,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: tempEnd,
                        firstDate: tempStart.add(const Duration(days: 1)),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) {
                        setModalState(() {
                          tempEnd = d;
                          _syncTempPreset();
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _dateFormat.format(tempEnd),
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: GoogleFonts.quicksand(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            setState(() {
                              _startDate = tempStart;
                              _endDate = tempEnd;
                              _selectedRangePreset = tempPreset;
                              _filterData();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.apply,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final storeId = await inj<ReportDatasource>().getManagerStoreId(user.id);
      if (storeId == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final appointments = await inj<AppointmentDatasource>()
          .fetchStoreAppointments(storeId);

      if (mounted) {
        setState(() {
          _allAppointments = appointments;
          _filterData();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterData() {
    final filterEnd = _endDate.add(const Duration(days: 1));
    setState(() {
      _filteredAppointments = _allAppointments.where((appt) {
        return appt.startTime.isAfter(
              _startDate.subtract(const Duration(seconds: 1)),
            ) &&
            appt.startTime.isBefore(filterEnd);
      }).toList();
    });
  }

  Future<void> _exportToCsv(String extension) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'appointments_export_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final path = '${directory.path}/$filename';
      final file = File(path);

      String csvData =
          "Ref. No.,Client,Staff,Status,Created date,Service,Duration,Time slot,Net sales\n";

      for (var data in _filteredAppointments) {
        final services = data.services.isNotEmpty
            ? data.services.map((e) => e.name).join(', ')
            : 'No Service';
        final duration =
            '${data.endTime.difference(data.startTime).inMinutes} mins';
        final timeSlot =
            '${DateFormat('HH:mm').format(data.startTime)} - ${DateFormat('HH:mm').format(data.endTime)}';

        csvData +=
            '"#${data.id}","${data.customerName}","${data.professionalName ?? 'Unassigned'}","${data.status}","${_dateFormat.format(data.createdAt)}","$services","$duration","$timeSlot","${data.totalPrice}"\n';
      }

      await file.writeAsString(csvData);

      if (mounted) {
        Navigator.pop(context); // close bottom sheet if called from one
        await Share.shareXFiles([
          XFile(path),
        ], text: AppLocalizations.of(context)!.exportedAppointmentsList);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Error exporting data: $e');
      }
    }
  }

  void showActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black87,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.exportData,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _exportToCsv('csv'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 14.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          size: 28,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'CSV',
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => showActionsBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 40,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.appointmentList,
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.completeListOfBookedAppointments,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      InkWell(
                        onTap: _showFilterBottomSheet,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tune,
                                size: 20,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _localizePreset(_selectedRangePreset),
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingTextStyle: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        dataRowMinHeight: 60,
                        dataRowMaxHeight: 60,
                        columns: [
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.refNo),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.client),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.staff),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.status),
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(context)!.createdDate,
                            ),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.service),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.duration),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.timeSlot),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.netSales),
                          ),
                        ],
                        rows: _filteredAppointments.map((data) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  '#${data.id}',
                                  style: GoogleFonts.quicksand(
                                    color: const Color(0xFF5E5CE6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data.customerName,
                                  style: GoogleFonts.quicksand(
                                    color: const Color(0xFF5E5CE6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data.professionalName ??
                                      AppLocalizations.of(context)!.unassigned,
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data.status,
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  _dateFormat.format(data.createdAt),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  data.services.isNotEmpty
                                      ? data.services
                                            .map((e) => e.name)
                                            .join(', ')
                                      : AppLocalizations.of(context)!.noService,
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${data.endTime.difference(data.startTime).inMinutes} mins',
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${DateFormat('HH:mm').format(data.startTime)} - ${DateFormat('HH:mm').format(data.endTime)}',
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: 'đ',
                                  ).format(data.totalPrice),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
