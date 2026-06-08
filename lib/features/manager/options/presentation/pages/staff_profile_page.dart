import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/features/manager/options/presentation/pages/edit_staff_page.dart';
import 'package:intl/intl.dart';
import '../../../../../../l10n/app_localizations.dart';

class StaffProfilePage extends StatelessWidget {
  final StaffModel staff;
  const StaffProfilePage({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          staff.fullName,
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, AppLocalizations.of(context)!.profile, showEdit: true),
            _buildInfoItem(AppLocalizations.of(context)!.fullName, staff.fullName),
            _buildInfoItem(AppLocalizations.of(context)!.email, staff.email ?? "-"),
            _buildInfoItem(AppLocalizations.of(context)!.phoneNumber, staff.phoneNumber ?? "-"),
            _buildInfoItem(
              AppLocalizations.of(context)!.dateOfBirth,
              staff.birthDay != null
                  ? DateFormat('dd/MM/yyyy').format(staff.birthDay!)
                  : '-',
            ),
            _buildInfoItem(AppLocalizations.of(context)!.country, AppLocalizations.of(context)!.vietnam),
            _buildInfoItem(AppLocalizations.of(context)!.jobTitleLabel, staff.jobTitle ?? '-'),

            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            _buildSectionHeader(context, AppLocalizations.of(context)!.workInformation, showEdit: false),
            _buildInfoItem(
              AppLocalizations.of(context)!.employmentPeriod,
              '${DateFormat('MMM dd, yyyy').format(staff.startDate)} - ${staff.endDate != null ? DateFormat('MMM dd, yyyy').format(staff.endDate!) : AppLocalizations.of(context)!.present}',
            ),
            _buildInfoItem(AppLocalizations.of(context)!.employmentType, AppLocalizations.of(context)!.employee),
            _buildInfoItem(AppLocalizations.of(context)!.employeeId, staff.id.toString()),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    required bool showEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (showEdit)
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditStaffPage(isEdit: true, staff: staff),
                  ),
                );
                if (result == true) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.edit,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Color(0xFF5E5CE6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
