import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ServiceOptionModel {
  final String id;
  final String title;
  final String duration;
  final double price;

  ServiceOptionModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
  });
}

Future<void> showServiceOptionBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const ServiceOptionBottomSheet();
    },
  );
}

class ServiceOptionBottomSheet extends StatefulWidget {
  const ServiceOptionBottomSheet({super.key});

  @override
  State<ServiceOptionBottomSheet> createState() => _ServiceOptionBottomSheetState();
}

class _ServiceOptionBottomSheetState extends State<ServiceOptionBottomSheet> {

  String? _selectedOptionId;

  final List<ServiceOptionModel> _options = [
    ServiceOptionModel(id: '1', title: 'Cắt tóc', duration: '30 min', price: 60000),
    ServiceOptionModel(id: '2', title: 'Combo Cắt, Xả', duration: '30 min', price: 70000),
    ServiceOptionModel(id: '3', title: 'Combo Cắt, Xả', duration: '30 min', price: 80000),
    ServiceOptionModel(id: '4', title: 'cắt tóc nam', duration: '30 min', price: 90000),
  ];


  @override
  Widget build(BuildContext context) {
    // Tính toán thông tin hiển thị ở Bottom Bar
    final selectedOption = _options.where((o) => o.id == _selectedOptionId).firstOrNull;
    final displayPrice = selectedOption != null 
        ? '₫${CurrencyFormart.formatVND(selectedOption.price)}' 
        : 'from ₫${CurrencyFormart.formatVND(_options.first.price)}';
    final displayDuration = selectedOption != null ? selectedOption.duration : '30 min';
    final canAdd = _selectedOptionId != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const PhosphorIcon(PhosphorIconsRegular.x, size: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cắt tóc Nam',
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select an option *',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _options.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade200,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = _options[index];
                  final isSelected = _selectedOptionId == item.id;
                  return _buildOptionItem(item, isSelected);
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Thông tin giá và thời gian
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayPrice,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayDuration,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: canAdd ? () {
                        // Xử lý thêm vào giỏ hàng
                        Navigator.pop(context, selectedOption);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAdd ? Colors.black : Colors.grey.shade400,
                        disabledBackgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  Widget _buildOptionItem(ServiceOptionModel item, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOptionId = item.id;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.duration,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₫${CurrencyFormart.formatVND(item.price)}',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isSelected
                  ? _buildSelectedRadio()
                  : _buildUnselectedRadio(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnselectedRadio() {
    return Container(
      key: const ValueKey('unselected'),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
    );
  }

  Widget _buildSelectedRadio() {
    return Container(
      key: const ValueKey('selected'),
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black, 
      ),
      child: const Center(
        child: PhosphorIcon(
          PhosphorIconsRegular.check,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }
}