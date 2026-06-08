import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SlidingUpHeader extends StatelessWidget {
  const SlidingUpHeader({super.key});

  void _showPriceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const PriceFilterDialog();
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SortFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //         ActionChip(
          //           label: PhosphorIcon(PhosphorIcons.faders(), size: 20),
          //           onPressed: () {},
          //           backgroundColor: Colors.white,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //         ActionChip(
          //           label: Row(
          //             children: [
          //               Text(
          //                 AppLocalizations.of(context)!.bestMatch,
          //                 style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          //               ),
          //               const SizedBox(width: 5),
          //               const Icon(Icons.keyboard_arrow_down, size: 20),
          //             ],
          //           ),
          //           onPressed: () => _showSortBottomSheet(context),
          //           backgroundColor: Colors.white,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(25),
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //         ActionChip(
          //           label: Row(
          //             children: [
          //               Text(
          //                 AppLocalizations.of(context)!.price,
          //                 style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          //               ),
          //               const SizedBox(width: 5),
          //               const Icon(Icons.keyboard_arrow_down, size: 20),
          //             ],
          //           ),
          //           onPressed: () => _showPriceBottomSheet(context),
          //           backgroundColor: Colors.white,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(25),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SortFilterDialog extends StatefulWidget {
  const SortFilterDialog({super.key});

  @override
  State<SortFilterDialog> createState() => _SortFilterDialogState();
}

class _SortFilterDialogState extends State<SortFilterDialog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort by',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 24),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              _buildSortItem(
                index: 0,
                label: 'Best match',
                icon: PhosphorIcons.heart(),
              ),
              const SizedBox(width: 12),
              _buildSortItem(
                index: 1,
                label: 'Top rated',
                icon: PhosphorIcons.star(),
              ),
              const SizedBox(width: 12),
              _buildSortItem(
                index: 2,
                label: 'Nearest',
                icon: PhosphorIcons.mapPin(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortItem({
    required int index,
    required String label,
    required PhosphorIconData icon,
  }) {
    bool isSelected = _selectedIndex == index;
    Color primaryColor = const Color(0xFF6B4EFF);

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          // Có thể thêm Navigator.pop(context, index) nếu muốn đóng luôn
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected 
              ? [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhosphorIcon(
                icon,
                color: isSelected ? primaryColor : Colors.black87,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? primaryColor : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceFilterDialog extends StatefulWidget {
  const PriceFilterDialog({super.key});

  @override
  State<PriceFilterDialog> createState() => _PriceFilterDialogState();
}

class _PriceFilterDialogState extends State<PriceFilterDialog> {
  final double _maxLimit = 20000000;
  double _currentPrice = 20000000;

  String _formatCurrency(double value) {
    return '₫${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum price',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                _formatCurrency(_currentPrice),
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6B4EFF),
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: const Color(0xFF6B4EFF),
              overlayColor: const Color(0xFF6B4EFF).withValues(alpha: 0.2),
              trackHeight: 1.5,
            ),
            child: Slider(
              value: _currentPrice,
              min: 0,
              max: _maxLimit,
              divisions: 400,
              padding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _currentPrice = value;
                });
              },
            ),
          ),
          
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentPrice = _maxLimit;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 45),
                    maximumSize: Size(double.infinity, 80),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Clear',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 45),
                    maximumSize: Size(double.infinity, 80),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}