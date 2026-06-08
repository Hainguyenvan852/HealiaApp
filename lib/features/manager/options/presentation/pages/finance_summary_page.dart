import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/manager/options/data/datasources/report_datasource.dart';
import 'package:healio_app/shared/datasource/transaction_datasource.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../core/utils/color_theme.dart';
import '../../../../../../l10n/app_localizations.dart';

class FinanceSummaryPage extends StatefulWidget {
  const FinanceSummaryPage({Key? key}) : super(key: key);

  @override
  State<FinanceSummaryPage> createState() => _FinanceSummaryPageState();
}

class _FinanceSummaryPageState extends State<FinanceSummaryPage> {
  // Dữ liệu giả định cho Tài chính (Kiểu double để tính tiền)
  double _totalRevenue = 0;
  double _grossSales = 0;
  double _refunds = 0;
  double _netSales = 0;
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

  // Format tiền tệ Việt Nam
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
  );

  @override
  void initState() {
    super.initState();
    _calculateDateRange();
    _fetchData();
  }

  // Thuật toán tính toán ngày 14 và 15
  void _calculateDateRange() {
    DateTime now = DateTime.now();

    if (now.day < 15) {
      _startDate = DateTime(now.year, now.month - 2, 14);
      _endDate = DateTime(now.year, now.month - 1, 15);

      _prevStartDate = DateTime(now.year, now.month - 3, 14);
      _prevEndDate = DateTime(now.year, now.month - 2, 15);
    } else {
      _startDate = DateTime(now.year, now.month - 1, 14);
      _endDate = DateTime(now.year, now.month, 15);

      _prevStartDate = DateTime(now.year, now.month - 2, 14);
      _prevEndDate = DateTime(now.year, now.month - 1, 15);
    }

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

      final transactions = await inj<TransactionDatasource>()
          .getTransactionsByStoreId(storeId);

      double grossSales = 0;
      double refunds = 0;
      double prevGrossSales = 0;
      double prevRefunds = 0;

      final filterEnd = _endDate.add(const Duration(days: 1));
      final prevFilterEnd = _prevEndDate.add(const Duration(days: 1));
      List<double> dailyRevenue = List.filled(_daysCount + 1, 0.0);

      for (var tx in transactions) {
        final status = tx.paymentStatus.toLowerCase();
        bool isPaid =
            (status == 'paid' || status == 'completed' || status == 'success');
        bool isRefund = (status == 'refunded' || status == 'refund');

        if (tx.createdAt.isAfter(
              _startDate.subtract(const Duration(seconds: 1)),
            ) &&
            tx.createdAt.isBefore(filterEnd)) {
          if (isPaid) {
            grossSales += tx.amount;

            // Calculate day index. To avoid timezone issues, use DateTime at midnight
            final txDate = DateTime(
              tx.createdAt.year,
              tx.createdAt.month,
              tx.createdAt.day,
            );
            final startDateMidnight = DateTime(
              _startDate.year,
              _startDate.month,
              _startDate.day,
            );
            int dayIndex = txDate.difference(startDateMidnight).inDays;

            if (dayIndex >= 0 && dayIndex <= _daysCount) {
              dailyRevenue[dayIndex] += tx.amount;
            }
          } else if (isRefund) {
            refunds += tx.amount;
          }
        } else if (tx.createdAt.isAfter(
              _prevStartDate.subtract(const Duration(seconds: 1)),
            ) &&
            tx.createdAt.isBefore(prevFilterEnd)) {
          if (isPaid) {
            prevGrossSales += tx.amount;
          } else if (isRefund) {
            prevRefunds += tx.amount;
          }
        }
      }

      double maxDaily = 0;
      for (var rev in dailyRevenue) {
        if (rev > maxDaily) maxDaily = rev;
      }

      double prevTotalRevenue = prevGrossSales - prevRefunds;
      double currentTotalRevenue = grossSales - refunds;

      double percentage = 0;
      if (prevTotalRevenue == 0) {
        percentage = currentTotalRevenue > 0 ? 100 : 0;
      } else {
        percentage =
            ((currentTotalRevenue - prevTotalRevenue) / prevTotalRevenue) * 100;
      }

      if (mounted) {
        setState(() {
          _grossSales = grossSales;
          _refunds = refunds;
          _netSales = currentTotalRevenue;
          _totalRevenue = _netSales;
          _comparePercentage = percentage;

          // Trục Y biểu đồ tính theo đơn vị triệu (M)
          double maxYInMillions = maxDaily / 1000000;
          _maxY = maxYInMillions > 0
              ? (maxYInMillions * 1.2).ceilToDouble()
              : 10;

          _mainChartData = List.generate(dailyRevenue.length, (index) {
            return FlSpot(index.toDouble(), dailyRevenue[index] / 1000000);
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
                    AppLocalizations.of(context)!.financeSummary,
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
                          AppLocalizations.of(context)!.revenue,
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
                          _currencyFormat.format(_totalRevenue),
                          style: GoogleFonts.quicksand(
                            fontSize: 32,
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
                                      fontWeight: FontWeight.bold,
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
                              maxY: _maxY, // Max value in millions
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

                                          double dailyRevenue =
                                              spot.y * 1000000;

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
                                                    '${AppLocalizations.of(context)!.revenue}: ${_currencyFormat.format(dailyRevenue)}',
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
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0) return const Text('');
                                      return Text(
                                        '${value.toInt()}M',
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
                                    color: _mainColor.withValues(alpha: 0.1),
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

                        _buildStatRow(AppLocalizations.of(context)!.grossSales, _grossSales),
                        _buildStatRow(AppLocalizations.of(context)!.refunds, _refunds, isNegative: true),
                        Divider(color: Colors.grey.shade100, thickness: 1),
                        _buildStatRow(AppLocalizations.of(context)!.netSales, _netSales, isBold: true),
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

  Widget _buildStatRow(
    String label,
    double value, {
    bool isNegative = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: isBold ? Colors.black87 : Colors.grey.shade600,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          Text(
            isNegative
                ? '- ${_currencyFormat.format(value)}'
                : _currencyFormat.format(value),
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isNegative ? Colors.red.shade400 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
