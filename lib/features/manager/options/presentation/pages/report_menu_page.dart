import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/manager/options/presentation/pages/appointment_list_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/appointmetn_sumary_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/customer_summary_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/finance_summary_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/report_summary_page.dart';
import 'package:healio_app/features/manager/options/presentation/pages/transaction_list_page.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../../l10n/app_localizations.dart';

class ReportSummaryPage extends StatelessWidget {
  const ReportSummaryPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.report,
              style: GoogleFonts.quicksand(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.reportSummary,
              description: AppLocalizations.of(context)!.reportSummaryDesc,
              icon: PhosphorIcons.chartDonut(),
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OveralReportMenuPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.appointmentSummary,
              description:
                  AppLocalizations.of(context)!.appointmentSummaryDesc,
              icon: PhosphorIcons.calendarDots(),
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentSummaryPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.financeSummary,
              description:
                  AppLocalizations.of(context)!.financeSummaryDesc,
              icon: PhosphorIcons.chartBar(),
              color: Colors.deepPurpleAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceSummaryPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.customerSummary,
              description: AppLocalizations.of(context)!.customerSummaryDesc,
              icon: PhosphorIcons.chartPieSlice(),
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerSummaryPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.appointmentList,
              description:
                  AppLocalizations.of(context)!.appointmentListDesc,
              icon: PhosphorIcons.listDashes(),
              color: Colors.deepOrange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentListPage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              context: context,
              title: AppLocalizations.of(context)!.transactionList,
              description: AppLocalizations.of(context)!.transactionListDesc,
              icon: PhosphorIcons.receipt(),
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionListPage()),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      radius: 12,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
