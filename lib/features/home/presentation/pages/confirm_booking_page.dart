import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({super.key});

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  final double _discountAmount = 45000;

  String _formatCurrency(double amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final store = state.currentStore;
        final services = state.services ?? [];

        double subtotal = services.fold(0, (sum, item) => sum + item.price);
        double total = subtotal - _discountAmount;

        int totalDuration = services.fold(
          0,
          (sum, item) => sum + item.duration,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actionsPadding: const EdgeInsets.only(right: 5),
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const PhosphorIcon(
                PhosphorIconsRegular.arrowLeft,
                color: Colors.black,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.only(left: 10),
              ),
              onPressed: () {
                context.read<BookingCubit>().clearDateTime();
                context.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const PhosphorIcon(
                  PhosphorIconsRegular.x,
                  color: Colors.black,
                ),
                onPressed: () {
                  BottomSheetHelper.showExitConfirmationBottomSheet(
                    context: context,
                    onExit: () {
                      context.read<BookingCubit>().clearAllExpectStore();
                      context.go('/home/store-detail');
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review and confirm',
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildStoreInfo(store),
                      const SizedBox(height: 24),

                      _buildDateTimeInfo(totalDuration, state),
                      const SizedBox(height: 32),

                      _buildServicesList(state, services),

                      _buildDivider(),
                      _buildDiscountCode(),

                      _buildDivider(),
                      _buildPriceBreakdown(subtotal, total),

                      const SizedBox(height: 32),
                      _buildPaymentMethod(),

                      const SizedBox(height: 32),
                      _buildCancellationPolicy(),

                      const SizedBox(height: 32),
                      _buildNotesField(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(total, services.length, totalDuration),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Divider(color: Colors.black.withValues(alpha: 0.15), height: 1),
    );
  }

  Widget _buildStoreInfo(StoreModel? store) {
    if (store == null) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            store.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Shimmer(
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    store.rating.toString(),
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const PhosphorIcon(
                        PhosphorIconsFill.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${store.ratingNumber})',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                store.address,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeInfo(int totalDuration, BookingState _bookingState) {
    final dateStr = _bookingState.date != null
        ? DateFormat('EEEE d MMMM').format(_bookingState.date!)
        : '';
    final startStr = _bookingState.startTime != null
        ? _formatTimeOfDay(_bookingState.startTime!)
        : '';
    final endStr = _bookingState.startTime != null
        ? _formatTimeOfDay(
            TimeOfDay(
              hour:
                  _bookingState.startTime!.hour + (totalDuration / 60).toInt(),
              minute: _bookingState.startTime!.minute + totalDuration % 60,
            ),
          )
        : '';

    return Column(
      children: [
        Row(
          children: [
            PhosphorIcon(
              PhosphorIconsRegular.calendarBlank,
              size: 22,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              dateStr,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            PhosphorIcon(
              PhosphorIconsRegular.clock,
              size: 22,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              '$startStr–$endStr (${DateTimeHelper.minuteToHourAndMinute(totalDuration)} duration)',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesList(
    BookingState _bookingState,
    List<ServiceModel> services,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hải',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateTimeHelper.minuteToHourAndMinute(service.duration)}' +
                          (_bookingState.professional != null
                              ? ' • with' + _bookingState.professional!.fullName
                              : ''),
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.black.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₫${_formatCurrency(service.price)}',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDiscountCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discount code',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            final String? enteredCode = await showAddDiscountBottomSheet(
              context,
            );

            if (enteredCode != null && enteredCode.isNotEmpty) {
              print("Đã nhập mã: $enteredCode");
            }
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Text(
            'Add',
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown(double subtotal, double total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₫${_formatCurrency(subtotal)}',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discounts',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '-₫${_formatCurrency(_discountAmount)}',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₫${_formatCurrency(total)}',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pay now',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₫0',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pay at venue',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₫${_formatCurrency(total)}',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment method',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const PhosphorIcon(
                PhosphorIconsRegular.storefront,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Pay at venue',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cancellation policy',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
            children: const [
              TextSpan(text: 'Please cancel at least '),
              TextSpan(
                text: '3 hours before',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: ' appointment.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.black.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Include comments or requests about your booking',
            hintStyle: GoogleFonts.quicksand(
              color: Colors.black.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
              fontSize: 16,
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
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double total, int serviceCount, int durationHours) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₫${_formatCurrency(total)}',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$serviceCount service${serviceCount > 1 ? 's' : ''} • $durationHours hr',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Xử lý Confirm Booking
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> showAddDiscountBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Cho phép BottomSheet tùy chỉnh chiều cao
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const AddDiscountBottomSheet();
    },
  );
}

class AddDiscountBottomSheet extends StatefulWidget {
  const AddDiscountBottomSheet({super.key});

  @override
  State<AddDiscountBottomSheet> createState() => _AddDiscountBottomSheetState();
}

class _AddDiscountBottomSheetState extends State<AddDiscountBottomSheet> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const PhosphorIcon(PhosphorIconsRegular.x, size: 24),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a discount',
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the discount or promo code',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ô nhập Text Field
                    TextField(
                      controller: _codeController,
                      focusNode: _focusNode,
                      style: GoogleFonts.quicksand(fontSize: 16),
                      textCapitalization:
                          TextCapitalization.characters, // Tự động viết hoa
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        // Border khi bình thường
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        // Border màu tím khi đang focus (như trong ảnh)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF5B45FF),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // Cập nhật UI nếu cần validate độ dài code
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 32),

                    // Nút Continue
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _codeController.text.trim().isNotEmpty
                            ? () {
                                // Xử lý logic khi có code
                                final code = _codeController.text.trim();
                                Navigator.pop(
                                  context,
                                  code,
                                ); // Trả code về màn hình trước
                              }
                            : null, // Vô hiệu hóa nút nếu chưa nhập gì
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _codeController.text.trim().isNotEmpty
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
