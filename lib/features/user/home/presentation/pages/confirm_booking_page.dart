import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/injector/dependency_injector.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({super.key});

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  bool isLoading = false;

  String _formatCurrency(double amount) {
    return NumberFormat('#,###', 'vi_VN').format(amount);
  }

  String _formatTimeOfDay(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final store = state.currentStore;
        final services = state.services ?? [];

        double subtotal = services.fold(0, (sum, item) => sum + item.price);
        double total = subtotal;

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
                      Navigator.popUntil(
                        context,
                        (route) => route.settings.name == 'store-detail',
                      );
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
                        AppLocalizations.of(context)!.reviewAndConfirm,
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
            store.primaryImageUrl,
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
            _bookingState.startTime!.add(Duration(minutes: totalDuration)),
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
              '$startStr–$endStr (${DateTimeHelper.minuteToHourAndMinute(totalDuration)} )' +
                  AppLocalizations.of(context)!.duration,
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
          AppLocalizations.of(context)!.services,
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
                              ? ' • ' +
                                    AppLocalizations.of(context)!.withh +
                                    ' ${_bookingState.professional!.fullName.toLowerCase()}'
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

  Widget _buildPriceBreakdown(double subtotal, double total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.subtotal,
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
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.discounts,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '-₫0',
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
              AppLocalizations.of(context)!.total,
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
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.paymentMethod,
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const PhosphorIcon(
                  PhosphorIconsRegular.storefront,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.payAtVenue,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.cancellationPolicy1,
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
            children: [
              TextSpan(text: AppLocalizations.of(context)!.cancellationPolicy2),
              TextSpan(
                text: AppLocalizations.of(context)!.cancellationPolicy3,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: AppLocalizations.of(context)!.cancellationPolicy4),
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
          AppLocalizations.of(context)!.notes,
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
            hintText: AppLocalizations.of(context)!.notesPlaceholder,
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
                '$serviceCount' +
                    AppLocalizations.of(context)!.service +
                    '${serviceCount > 1 ? 's' : ''} • $durationHours hr',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    final currentBooking = context.read<BookingCubit>().state;
                    if (currentBooking.currentStore != null &&
                        currentBooking.services != null &&
                        currentBooking.date != null &&
                        currentBooking.startTime != null) {
                      try {
                        setState(() {
                          isLoading = true;
                        });

                        double totalPrice = 0;

                        for (var i in currentBooking.services!) {
                          totalPrice += i.price;
                        }

                        final currentUser = inj<CheckCurrentUserUseCase>()
                            .call();

                        if (currentUser == null) {
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        int totalDuration = currentBooking.services!.fold(
                          0,
                          (sum, item) => sum + item.duration,
                        );

                        int? assignedMemberId =
                            currentBooking.professional != null
                            ? currentBooking.professional!.id
                            : null;

                        if (assignedMemberId == 0) {
                          final professionals = await Supabase.instance.client
                              .from('members')
                              .select()
                              .eq('store_id', currentBooking.currentStore!.id)
                              .eq('is_active', true);

                          final allMemberIds = professionals
                              .map((e) => e['id'] as int)
                              .toList();

                          final startIso = currentBooking.startTime!
                              .toIso8601String();
                          final endIso = currentBooking.startTime!
                              .add(Duration(minutes: totalDuration))
                              .toIso8601String();

                          final busyAppts = await Supabase.instance.client
                              .from('appointments')
                              .select('member_id')
                              .eq('store_id', currentBooking.currentStore!.id)
                              .inFilter('status', ['confirmed', 'pending'])
                              .lt('start_time', endIso)
                              .gt('end_time', startIso);

                          final busyMemberIds = busyAppts
                              .map((e) => e['member_id'] as int?)
                              .where((id) => id != null)
                              .toSet();
                          final availableMemberIds = allMemberIds
                              .where((id) => !busyMemberIds.contains(id))
                              .toList();

                          if (availableMemberIds.isNotEmpty) {
                            assignedMemberId = availableMemberIds.first;
                          } else {
                            assignedMemberId = null;
                          }
                        }

                        await Supabase.instance.client.rpc(
                          'book_appointment_tx',
                          params: {
                            'p_customer_id': currentUser.id,
                            'p_store_id': currentBooking.currentStore!.id,
                            'p_member_id': assignedMemberId,
                            'p_start_time': currentBooking.startTime!
                                .toIso8601String(),
                            'p_end_time': currentBooking.startTime!
                                .add(Duration(minutes: totalDuration))
                                .toIso8601String(),
                            'p_total_price': totalPrice,
                            'p_service_ids': currentBooking.services!
                                .map((s) => s.id)
                                .toList(),
                            'p_payment_method': 'at_store',
                            'p_payment_status': 'pending',
                          },
                        );

                        if (context.mounted) {
                          context.read<BookingCubit>().clearAllExpectStore();
                          Navigator.popUntil(
                            context,
                            (route) => route.settings.name == 'store-detail',
                          );
                          SnackBarHelper.showSuccess(
                            AppLocalizations.of(context)!.bookingSuccess,
                          );
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (e.toString().contains(
                          'This time slot has just been booked by another customer',
                        )) {
                          SnackBarHelper.showError(
                            AppLocalizations.of(context)!.slotBooked,
                          );
                        } else {
                          SnackBarHelper.showError(
                            AppLocalizations.of(context)!.bookingFail,
                          );
                        }
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? LoadingAnimationWidget.progressiveDots(
                    color: Colors.white,
                    size: 30,
                  )
                : Text(
                    AppLocalizations.of(context)!.confirm,
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
