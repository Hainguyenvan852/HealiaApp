import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FilterAppointmentScreen extends StatefulWidget {
  const FilterAppointmentScreen({super.key});

  @override
  State<FilterAppointmentScreen> createState() =>
      _FilterAppointmentScreenState();
}

class _FilterAppointmentScreenState extends State<FilterAppointmentScreen> {
  final List<String> appointmentStatuses = [
    "Đã đặt (Booked)",
    "Đã xác nhận (Confirmed)",
    "Đã đến",
    "Đã bắt đầu",
    "Hoàn thành (Completed)",
    "Vắng mặt (No-show)",
  ];

  final List<String> paymentStatuses = [
    "Chưa thanh toán",
    "Đã thanh toán một phần",
    "Đã thanh toán đầy đủ",
  ];

  final Set<String> _selectedAppointments = {};
  final Set<String> _selectedPayments = {};

  void _clearFilters() {
    setState(() {
      _selectedAppointments.clear();
      _selectedPayments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bộ lọc',
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.x, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    children: [
                      _buildExpansionSection(
                        title: 'Trạng thái cuộc hẹn',
                        icon: PhosphorIconsRegular.calendarBlank,
                        options: appointmentStatuses,
                        selectedSet: _selectedAppointments,
                        initiallyExpanded: true,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: Colors.grey.shade200, height: 1),
                      ),

                      _buildExpansionSection(
                        title: 'Trạng thái thanh toán',
                        icon: PhosphorIconsRegular.coins,
                        options: paymentStatuses,
                        selectedSet: _selectedPayments,
                        initiallyExpanded: false,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: Colors.grey.shade200, height: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Xóa bộ lọc',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        print(
                          "Trạng thái cuộc hẹn đã chọn: $_selectedAppointments",
                        );
                        print(
                          "Trạng thái thanh toán đã chọn: $_selectedPayments",
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Áp dụng',
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
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required Set<String> selectedSet,
    required bool initiallyExpanded,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),

        title: Row(
          children: [
            PhosphorIcon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),

        children: options.map((option) {
          final isSelected = selectedSet.contains(option);
          return InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedSet.remove(option);
                } else {
                  selectedSet.add(option);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40),

                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      option,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
