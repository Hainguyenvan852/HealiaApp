import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/utils/color_theme.dart';
import '../../../../../../l10n/app_localizations.dart';

class AppointmentSummaryPage extends StatefulWidget {
  const AppointmentSummaryPage({Key? key}) : super(key: key);

  @override
  State<AppointmentSummaryPage> createState() => _AppointmentSummaryPageState();
}

class _AppointmentSummaryPageState extends State<AppointmentSummaryPage> {
  // Dữ liệu giả định
  int _totalAppointments = 0;
  int _completed = 0;
  int _notCompleted = 0;
  int _noShows = 0;
  int _canceled = 0;
  List<FlSpot> _mainChartData = [];

  final Color _mainColor = const Color(0xFF5E5CE6); // Tím đậm

  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _prevStartDate;
  late DateTime _prevEndDate;
  late int _daysCount;
  bool _isLoading = true;
  double _maxY = 10;
  double _comparePercentage = 0;

  @override
  void initState() {
    super.initState();
    _calculateDateRange();
    _fetchData();
  }

  void _calculateDateRange() {
    DateTime now = DateTime.now();

    if (now.day < 15) {
      // Nếu hôm nay chưa đến ngày 15: Lấy từ 14 (tháng trước nữa) -> 15 (tháng trước)
      _startDate = DateTime(now.year, now.month - 2, 14);
      _endDate = DateTime(now.year, now.month - 1, 15);

      _prevStartDate = DateTime(now.year, now.month - 3, 14);
      _prevEndDate = DateTime(now.year, now.month - 2, 15);
    } else {
      // Nếu hôm nay từ ngày 15 trở đi: Lấy từ 14 (tháng trước) -> 15 (tháng này)
      _startDate = DateTime(now.year, now.month - 1, 14);
      _endDate = DateTime(now.year, now.month, 15);

      _prevStartDate = DateTime(now.year, now.month - 2, 14);
      _prevEndDate = DateTime(now.year, now.month - 1, 15);
    }

    // Tính tổng số ngày trong khoảng thời gian này
    _daysCount = _endDate.difference(_startDate).inDays;
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

      int total = 0;
      int prevTotal = 0;
      int completed = 0;
      int notCompleted = 0;
      int noShows = 0;
      int canceled = 0;

      final filterEnd = _endDate.add(const Duration(days: 1));
      final prevFilterEnd = _prevEndDate.add(const Duration(days: 1));
      List<int> dailyCounts = List.filled(_daysCount + 1, 0);

      for (var appt in appointments) {
        if (appt.startTime.isAfter(
              _startDate.subtract(const Duration(seconds: 1)),
            ) &&
            appt.startTime.isBefore(filterEnd)) {
          total++;

          final st = appt.status.toLowerCase();
          if (st == 'completed' || st == 'done') {
            completed++;
          } else if (st == 'cancelled' || st == 'canceled') {
            canceled++;
          } else if (st == 'no_show' || st == 'no show') {
            noShows++;
          } else {
            notCompleted++;
          }

          // Calculate day index. To avoid timezone issues, use DateTime at midnight
          final apptDate = DateTime(
            appt.startTime.year,
            appt.startTime.month,
            appt.startTime.day,
          );
          final startDateMidnight = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
          );
          int dayIndex = apptDate.difference(startDateMidnight).inDays;

          if (dayIndex >= 0 && dayIndex <= _daysCount) {
            dailyCounts[dayIndex]++;
          }
        } else if (appt.startTime.isAfter(
              _prevStartDate.subtract(const Duration(seconds: 1)),
            ) &&
            appt.startTime.isBefore(prevFilterEnd)) {
          prevTotal++;
        }
      }

      double maxCount = 10;
      for (var count in dailyCounts) {
        if (count > maxCount) maxCount = count.toDouble();
      }

      double percentage = 0;
      if (prevTotal == 0) {
        percentage = total > 0 ? 100 : 0;
      } else {
        percentage = ((total - prevTotal) / prevTotal) * 100;
      }

      if (mounted) {
        setState(() {
          _totalAppointments = total;
          _completed = completed;
          _notCompleted = notCompleted;
          _noShows = noShows;
          _canceled = canceled;
          _maxY = maxCount + 2;
          _comparePercentage = percentage;

          _mainChartData = List.generate(dailyCounts.length, (index) {
            return FlSpot(index.toDouble(), dailyCounts[index].toDouble());
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  Text(
                    AppLocalizations.of(context)!.appointmentSummary,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.appointments,
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.viewReport,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: const Color(0xFF5E5CE6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          '$_totalAppointments',
                          style: GoogleFonts.quicksand(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _comparePercentage >= 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _comparePercentage >= 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 14,
                                    color: _comparePercentage >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_comparePercentage.abs().toStringAsFixed(1)}%',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      color: _comparePercentage >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.vsCompPeriod,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: _daysCount.toDouble(),
                              minY: 0,
                              maxY: _maxY,
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (touchedSpot) =>
                                      const Color(0xFF1A1A1A),
                                  tooltipBorderRadius: BorderRadius.circular(5),
                                  tooltipPadding: const EdgeInsets.all(12),
                                  getTooltipItems:
                                      (List<LineBarSpot> touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          if (spot.barIndex != 0) return null;

                                          String dayOfWeek =
                                              DateFormat('EEEE', 'vi').format(
                                                _startDate.add(
                                                  Duration(
                                                    days: spot.spotIndex,
                                                  ),
                                                ),
                                              );
                                          String dateStr =
                                              DateFormat('d MMM', 'en').format(
                                                _startDate.add(
                                                  Duration(
                                                    days: spot.spotIndex,
                                                  ),
                                                ),
                                              );

                                          return LineTooltipItem(
                                            '$dayOfWeek, $dateStr\n',
                                            GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: '\n● ',
                                                style: TextStyle(
                                                  color: Color(0xFF00B074),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${AppLocalizations.of(context)!.appointment} ${_mainChartData[spot.spotIndex].y.toStringAsFixed(0)} đ',
                                                style: GoogleFonts.quicksand(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList();
                                      },
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                ),
                                getDrawingVerticalLine: (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0) {
                                        return Text(
                                          DateFormat(
                                            'dd MMM',
                                          ).format(_startDate),
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      }
                                      if (value == _daysCount.toDouble()) {
                                        return Text(
                                          DateFormat('dd MMM').format(_endDate),
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  right: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  top: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _mainChartData,
                                  isCurved: true,
                                  color: _mainColor,
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: Colors.purpleAccent,
                                              strokeWidth: 0,
                                            ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: _mainColor.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _buildLegendItem(
                              _mainColor,
                              DateFormat('dd MMM yyyy').format(_startDate) +
                                  ' - ' +
                                  DateFormat('dd MMM yyyy').format(_endDate),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Divider(color: Colors.grey.shade200, thickness: 1),
                        const SizedBox(height: 16),

                        _buildStatRow(AppLocalizations.of(context)!.completed, _completed),
                        _buildStatRow(AppLocalizations.of(context)!.notCompleted, _notCompleted),
                        _buildStatRow(AppLocalizations.of(context)!.noShows, _noShows),
                        _buildStatRow(AppLocalizations.of(context)!.canceled, _canceled),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.quicksand(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value.toString(),
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
