import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';

import '../../../../../core/services/network_manager.dart';
import '../../../../landing/no_internet_page.dart';
import '../../../../../../l10n/app_localizations.dart';

class OveralReportMenuPage extends StatefulWidget {
  const OveralReportMenuPage({super.key});

  @override
  State<OveralReportMenuPage> createState() => _OveralReportMenuPageState();
}

class _OveralReportMenuPageState extends State<OveralReportMenuPage> {
  bool _isLoading = true;
  String? _error;

  ReportMetrics? _metrics;
  List<ReportChartData> _chartData = [];
  List<Map<String, dynamic>> _upcomingAppointments = [];
  List<Map<String, dynamic>> _todayAppointments = [];
  List<Map<String, dynamic>> _pastAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = inj<CheckCurrentUserUseCase>().call();
      if (user == null) {
        setState(() {
          _error = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      final reportDs = inj<ReportDatasource>();
      final storeId = await reportDs.getManagerStoreId(user.id);

      if (storeId == null) {
        setState(() {
          _error = 'No store found for this manager';
          _isLoading = false;
        });
        return;
      }

      final metrics = await reportDs.getReportMetrics(storeId);
      final chartData = await reportDs.getChartData(storeId);
      final upcoming = await reportDs.getUpcomingAppointments(storeId);
      final today = await reportDs.getUpcomingAppointments(
        storeId,
        onlyToday: true,
      );
      final past = await reportDs.getPastAppointments(storeId);

      setState(() {
        _metrics = metrics;
        _chartData = chartData;
        _upcomingAppointments = upcoming;
        _todayAppointments = today;
        _pastAppointments = past;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: NetworkManager.instance.connectionStream,
      initialData: NetworkManager.instance.hasInternet,
      builder: (context, asyncSnapshot) {
        final isConnected = asyncSnapshot.data ?? true;

        if (!isConnected) {
          return NoInternetPage(
            onTryAgain: () {
              NetworkManager.instance.retryConnection();
            },
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: _isLoading
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.mainAppColor(),
                      size: 50,
                    ),
                  )
                : _error != null
                ? Center(child: Text(_error!))
                : RefreshIndicator(
                    color: ColorTheme.mainAppColor(),
                    onRefresh: _loadData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSalesCard(),
                          const SizedBox(height: 16),
                          _buildUpcomingAppointmentsCard(),
                          const SizedBox(height: 16),
                          _buildAppointmentActivityCard(),
                          const SizedBox(height: 16),
                          _buildTodayAppointmentsCard(),
                          // const SizedBox(height: 16),
                          // _buildTopServicesCard(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _buildSalesCard() {
    double maxValue = 0;
    for (var point in _chartData) {
      if (point.transactions > maxValue) maxValue = point.transactions;
      if (point.appointments > maxValue)
        maxValue = point.appointments.toDouble();
    }
    double maxYScale = maxValue > 0 ? (maxValue / 20).ceil() * 20.0 : 60.0;
    if (maxYScale == 0) maxYScale = 60.0;

    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.recentSales,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.sevenDaysAgo,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              formatter.format(_metrics?.totalRevenue ?? 0),
              style: GoogleFonts.quicksand(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.appointments}: ${_metrics?.totalAppointments ?? 0}',
              style: GoogleFonts.quicksand(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            // const SizedBox(height: 4),
            // Text(
            //   'Services: ${_metrics?.totalServices ?? 0}',
            //   style: GoogleFonts.quicksand(fontSize: 15, color: Colors.black87),
            // ),
            const SizedBox(height: 32),

            if (_chartData.isNotEmpty)
              SizedBox(
                height: 240,
                width: double.infinity,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (_chartData.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxYScale,
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) =>
                            const Color(0xFF1A1A1A),
                        tooltipBorderRadius: BorderRadius.circular(5),
                        tooltipPadding: const EdgeInsets.all(12),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            if (spot.barIndex != 0) return null;

                            final dataPoint = _chartData[spot.spotIndex];

                            String dayOfWeek = DateFormat(
                              'EEEE',
                              'vi',
                            ).format(dataPoint.date);
                            String dateStr = DateFormat(
                              'd MMM',
                              'en',
                            ).format(dataPoint.date);

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
                                    color: Colors.purpleAccent,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${AppLocalizations.of(context)!.transaction} ${dataPoint.transactions.toInt()} đ',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const TextSpan(
                                  text: '\n● ',
                                  style: TextStyle(
                                    color: Color(0xFF00B074),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${AppLocalizations.of(context)!.appointment} ${dataPoint.appointments.toInt()}',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
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
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                      getDrawingVerticalLine: (value) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxYScale / 4 > 0 ? maxYScale / 4 : 15,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: GoogleFonts.quicksand(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < _chartData.length) {
                              final date = _chartData[index].date;

                              String weekday = DateFormat(
                                'E',
                                'en',
                              ).format(date).replaceAll('Th ', 'T');
                              String day = DateFormat('d', 'en').format(date);

                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    '$weekday $day',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.grey.shade600,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _chartData
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.transactions,
                              ),
                            )
                            .toList(),
                        isCurved: false,
                        color: Colors.purpleAccent,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 4,
                                color: Colors.purpleAccent,
                                strokeWidth: 0,
                              ),
                        ),
                      ),
                      LineChartBarData(
                        spots: _chartData
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.appointments.toDouble(),
                              ),
                            )
                            .toList(),
                        isCurved: false,
                        color: const Color(0xFF00B074),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 4,
                                color: const Color(0xFF00B074),
                                strokeWidth: 0,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildLegendItem(
                  Colors.purpleAccent,
                  AppLocalizations.of(context)!.paymentLabel,
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  const Color(0xFF00B074),
                  AppLocalizations.of(context)!.appointment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointmentsCard() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.upcomingAppointments,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.next7Days,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_upcomingAppointments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 48,
                        color: Colors.indigo.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.yourScheduleIsFree,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.createAppointmentsToDisplay,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._upcomingAppointments.map((apt) {
                return _buildAppointmentItemFromData(apt);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentActivityCard() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appointmentActivities,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_pastAppointments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    AppLocalizations.of(context)!.noActivitiesFound,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else ...[
              ..._pastAppointments.map(
                (apt) => _buildAppointmentItemFromData(apt),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAppointmentsCard() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.todaysNextAppointments,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_todayAppointments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.edit_calendar_outlined,
                        size: 48,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noAppointmentsToday,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.accessSection,
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.calendar,
                              style: const TextStyle(color: Color(0xFF6B4EFF)),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              )!.toAddAppointments,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._todayAppointments.map((apt) {
                return _buildAppointmentItemFromData(apt);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItemFromData(Map<String, dynamic> apt) {
    DateTime? startTime = apt['start_time'] != null
        ? DateTime.parse(apt['start_time']).toLocal()
        : null;
    DateTime? endTime = apt['end_time'] != null
        ? DateTime.parse(apt['end_time']).toLocal()
        : null;

    String day = startTime != null ? DateFormat('dd').format(startTime) : '--';
    String month = startTime != null
        ? DateFormat('MMM').format(startTime)
        : '--';
    String timeLine = '';
    if (startTime != null && endTime != null) {
      timeLine =
          '${DateFormat('E, d MMM yyyy HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}';
    }

    String status = apt['status'] ?? AppLocalizations.of(context)!.unknown;
    Color statusBg = Colors.grey.shade100;
    Color statusText = Colors.grey.shade700;

    if (status.toLowerCase() == 'completed') {
      statusBg = Colors.blue.shade100;
      statusText = Colors.blue.shade700;
      status = AppLocalizations.of(context)!.completed;
    } else if (status.toLowerCase() == 'cancelled') {
      statusBg = Colors.red.shade50;
      statusText = Colors.red.shade700;
      status = AppLocalizations.of(context)!.canceled;
    } else {
      statusBg = Colors.purple.shade50;
      statusText = Colors.purple.shade700;
      status = AppLocalizations.of(context)!.pending;
    }

    String customerName = AppLocalizations.of(context)!.unknownCustomer;
    if (apt['clients'] != null && apt['clients']['full_name'] != null) {
      customerName = apt['clients']['full_name'];
    }

    List<String> serviceNames = [];
    if (apt['appointment_services'] != null) {
      for (var s in apt['appointment_services']) {
        if (s['services'] != null && s['services']['name'] != null) {
          serviceNames.add(s['services']['name']);
        }
      }
    }
    String service = serviceNames.isNotEmpty
        ? serviceNames.join(', ')
        : 'No service';
    String details = customerName;

    return _buildActivityItem(
      day,
      month,
      timeLine,
      status,
      statusBg,
      statusText,
      service,
      details,
    );
  }

  Widget _buildActivityItem(
    String day,
    String month,
    String timeLine,
    String status,
    Color statusBg,
    Color statusText,
    String service,
    String details, {
    bool hideBorder = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  month,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeLine,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: statusText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!hideBorder) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
