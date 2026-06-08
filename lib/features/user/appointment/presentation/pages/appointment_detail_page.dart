import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/add_new_review_usecase.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/request_cancel_appointment_usecase.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/get_review_by_apm_usecase.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/presentation/widgets/rating_line.dart';
import 'package:healio_app/features/user/appointment/presentation/widgets/edit_appointment_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../l10n/app_localizations.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.appointment});
  final AppointmentModel appointment;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Color _colorByStatus(String status) {
    if (status.toLowerCase() == 'pending') {
      return Colors.orange;
    } else if (status.toLowerCase() == 'confirmed') {
      return Colors.blue;
    } else if (status.toLowerCase() == 'completed') {
      return Colors.green;
    } else if (status.toLowerCase() == 'cancelled') {
      return Colors.red;
    } else if (status.toLowerCase() == 'no_show') {
      return Colors.grey;
    } else {
      return Colors.orange;
    }
  }

  String _stringByStatus(String status) {
    if (status.toLowerCase() == 'pending') {
      return AppLocalizations.of(context)!.pending;
    } else if (status.toLowerCase() == 'confirmed') {
      return AppLocalizations.of(context)!.confirmed;
    } else if (status.toLowerCase() == 'completed') {
      return AppLocalizations.of(context)!.completed;
    } else if (status.toLowerCase() == 'cancelled') {
      return AppLocalizations.of(context)!.cancelled;
    } else if (status.toLowerCase() == 'no_show') {
      return AppLocalizations.of(context)!.noShow;
    } else {
      return '';
    }
  }

  void showRatingBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return RatingBottomSheetContent(
          appointmentId: widget.appointment.id,
          storeId: widget.appointment.storeId,
        );
      },
    );

    setState(() {
      reviewFuture = inj<GetReviewByApmUsecase>().call(widget.appointment.id);
    });
  }

  late Future<ReviewModel?> reviewFuture;

  bool isLoading = false;

  late AppointmentModel currentApm;

  void _openEditBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return EditAppointmentBottomSheet(appointment: currentApm);
      },
    );

    if (result == true) {
      SnackBarHelper.showSuccess(
        AppLocalizations.of(context)!.updateAppointmentSuccess,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    reviewFuture = inj<GetReviewByApmUsecase>().call(widget.appointment.id);
    currentApm = widget.appointment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.appointmentDetail,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (currentApm.status == 'pending' ||
              currentApm.status == 'confirmed')
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: _openEditBottomSheet,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.orange.shade100,
                              child: const Icon(
                                Icons.spa,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.appointment.storeName,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.appointment.storeAddress,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInfoBlock(
                      children: [
                        _buildRow(
                          AppLocalizations.of(context)!.createdAt,
                          DateFormat(
                            'MMM. dd, yyyy  hh:mm',
                          ).format(widget.appointment.createdAt),
                        ),
                        _buildRow(
                          AppLocalizations.of(context)!.dateAndTime,
                          DateFormat(
                                'MMM. dd, yyyy  hh:mm',
                              ).format(widget.appointment.startTime) +
                              DateFormat(
                                ' - hh:mm',
                              ).format(widget.appointment.endTime),
                        ),
                        _buildRow(
                          AppLocalizations.of(context)!.specialist,
                          widget.appointment.professionalName ??
                              'Any professional',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.services,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Expanded(child: SizedBox(width: double.infinity)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ...widget.appointment.services
                                      .map(
                                        (i) => Text(
                                          i.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInfoBlock(
                      children: [
                        _buildRow(
                          AppLocalizations.of(context)!.paymentMethods,
                          AppLocalizations.of(context)!.payAtVenue,
                          showCheck: false,
                          showDivider: true,
                        ),
                        _buildRow(
                          AppLocalizations.of(context)!.total,
                          CurrencyFormart.formatVND(
                            widget.appointment.totalPrice,
                          ),
                          showCheck: false,
                          showDivider: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInfoBlock(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.status,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _colorByStatus(
                                    widget.appointment.status,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _stringByStatus(widget.appointment.status),
                                  style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _colorByStatus(
                                      widget.appointment.status,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (currentApm.notes != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.notes,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.appointment.notes ?? '',
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    if (widget.appointment.status == 'completed')
                      FutureBuilder(
                        future: reviewFuture,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snap.hasError) {
                            return Text(
                              'An error occurred when loading ${snap.error}',
                            );
                          }

                          if (snap.data != null) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!.yourReview,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  RatingLine(
                                    rating: snap.data!.rating,
                                    iconSize: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snap.data!.comment ?? '',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (currentApm.status == 'completed')
              FutureBuilder(
                future: reviewFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  if (snap.hasError) {
                    return Text('An error occurred when loading ${snap.error}');
                  }

                  if (snap.data != null) {
                    return const SizedBox.shrink();
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7F7F9),
                        border: Border(
                          top: BorderSide(color: Colors.black12, width: 0.5),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => showRatingBottomSheet(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.reviewAppointment,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            if (currentApm.status == 'pending' ||
                currentApm.status == 'confirmed')
              Builder(
                builder: (context) {
                  final now = DateTime.now();
                  final difference = currentApm.startTime.difference(now);
                  final isOutside12Hours = difference.inHours > 12;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F9),
                      border: Border(
                        top: BorderSide(color: Colors.black12, width: 0.5),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (isOutside12Hours) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 40,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.cancelAppointmentConfirmation,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.back,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  flex: 3,
                                                  child: ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black,
                                                        ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      final result =
                                                          await inj<
                                                                CancelAppointmentUsecase
                                                              >()
                                                              .call(
                                                                widget
                                                                    .appointment
                                                                    .id,
                                                              );
                                                      if (result) {
                                                        setState(() {
                                                          isLoading = false;
                                                          currentApm = currentApm
                                                              .copyWith(
                                                                status:
                                                                    'cancelled',
                                                              );
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        SnackBarHelper.showError(
                                                          'An error occurred in canceling process.',
                                                        );
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.cancel,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Request cancellation dialog
                                  final reasonController =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 30,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.cancelRequest,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.cancelRequest1,

                                              style: GoogleFonts.quicksand(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextField(
                                              controller: reasonController,
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                  context,
                                                )!.reasonPlaceholder,
                                                hintStyle:
                                                    GoogleFonts.quicksand(
                                                      fontSize: 14,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.close,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black,
                                                        ),
                                                    onPressed: () async {
                                                      if (reasonController.text
                                                          .trim()
                                                          .isEmpty) {
                                                        SnackBarHelper.showError(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.enterReason,
                                                        );
                                                        return;
                                                      }
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      final result =
                                                          await inj<
                                                                RequestCancelAppointmentUseCase
                                                              >()
                                                              .call(
                                                                widget
                                                                    .appointment
                                                                    .id,
                                                                reasonController
                                                                    .text
                                                                    .trim(),
                                                              );
                                                      if (result) {
                                                        setState(() {
                                                          isLoading = false;
                                                          currentApm = currentApm
                                                              .copyWith(
                                                                status:
                                                                    'cancel_pending',
                                                              );
                                                        });
                                                        SnackBarHelper.showSuccess(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.requestHasBeenSent,
                                                        );
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        SnackBarHelper.showError(
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.anErrorOccurredWhenSendingRequest,
                                                        );
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.send,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? LoadingAnimationWidget.waveDots(
                                color: ColorTheme.mainAppColor(),
                                size: 25,
                              )
                            : Text(
                                isOutside12Hours
                                    ? AppLocalizations.of(
                                        context,
                                      )!.cancelAppointment
                                    : AppLocalizations.of(
                                        context,
                                      )!.requestCancelAppointment,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    bool showCheck = false,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}

class RatingBottomSheetContent extends StatefulWidget {
  const RatingBottomSheetContent({
    super.key,
    required this.appointmentId,
    required this.storeId,
  });
  final int appointmentId;
  final int storeId;

  @override
  State<RatingBottomSheetContent> createState() =>
      _RatingBottomSheetContentState();
}

class _RatingBottomSheetContentState extends State<RatingBottomSheetContent> {
  int _selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.rateYourAppointment,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _selectedStars;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStars = starIndex;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 40,
                    color: isFilled
                        ? const Color(0xFFFFCC00)
                        : Colors.grey.shade400,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.comments,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: _commentController,
            maxLines: 3,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterYourComments,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_selectedStars != 0) {
                  final rating = _selectedStars;
                  final comment = _commentController.text;
                  final user = inj<CheckCurrentUserUseCase>().call();

                  inj<AddNewReviewUsecase>().call(
                    ReviewModel(
                      id: 0,
                      customerId: user!.id,
                      appointmentId: widget.appointmentId,
                      rating: rating.toDouble(),
                      comment: comment.isEmpty ? null : comment,
                      createdAt: DateTime.now(),
                      storeId: widget.storeId,
                      customerName: null,
                      avatarUrl: null,
                    ),
                  );

                  Navigator.of(context).pop();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.send,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
