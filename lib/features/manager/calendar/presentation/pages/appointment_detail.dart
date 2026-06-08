import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/shared/datasource/transaction_datasource.dart';
import 'package:healio_app/shared/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late Future<TransactionModel?> transactionFuture;
  ClientModel? _client;
  bool _isLoadingClient = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
    _loadClient();
  }

  void _loadTransaction() {
    transactionFuture = inj<TransactionDatasource>()
        .getTransactionByAppointmentId(
          int.parse(widget.appointment.id.toString()),
        );
  }

  Future<void> _loadClient() async {
    final apm = (widget.appointment as StoreAppointment).model;
    try {
      final res = await Supabase.instance.client
          .from('clients')
          .select()
          .eq('id', apm.clientId)
          .maybeSingle();
      if (res != null) {
        if (mounted) {
          setState(() {
            _client = ClientModel.fromJson(res);
            _isLoadingClient = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingClient = false);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _isLoadingClient = false);
    }
  }

  Future<void> _updateAppointmentStatus(String newStatus) async {
    final apm = (widget.appointment as StoreAppointment).model;
    try {
      await inj<AppointmentDatasource>().updateAppointmentStatus(
        apm.id,
        newStatus,
      );
      setState(() {
        apm.status = newStatus;
      });
      SnackBarHelper.showSuccess(
        AppLocalizations.of(context)!.updatedAppointmentStatus,
      );
    } catch (e) {
      SnackBarHelper.showError(
        AppLocalizations.of(context)!.errorUpdatingAppointmentStatus,
      );
    }
  }

  Future<void> _updatePayment(
    TransactionModel trans,
    String newStatus, {
    String? method,
  }) async {
    try {
      if (method != null) {
        await inj<TransactionDatasource>().updateTransactionPayment(
          trans.id,
          newStatus,
          method,
        );
      } else {
        await inj<TransactionDatasource>().updateTransactionStatus(
          trans.id,
          newStatus,
        );
      }
      setState(() {
        _loadTransaction();
      });
      SnackBarHelper.showSuccess(AppLocalizations.of(context)!.updatedPayment);
    } catch (e) {
      SnackBarHelper.showError(
        AppLocalizations.of(context)!.errorUpdatingPayment,
      );
    }
  }

  Future<void> _callCustomer() async {
    if (_client?.phoneNumber != null && _client!.phoneNumber!.isNotEmpty) {
      final url = Uri.parse('tel:${_client!.phoneNumber}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackBarHelper.showError(
          AppLocalizations.of(context)!.couldNotLaunchPhoneApp,
        );
      }
    } else {
      SnackBarHelper.showError(
        AppLocalizations.of(context)!.noPhoneNumberAvailable,
      );
    }
  }

  Future<void> _emailCustomer() async {
    if (_client?.email != null && _client!.email.isNotEmpty) {
      final url = Uri.parse('mailto:${_client!.email}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackBarHelper.showError(
          AppLocalizations.of(context)!.couldNotLaunchEmailApp,
        );
      }
    } else {
      SnackBarHelper.showError(AppLocalizations.of(context)!.noEmailAvailable);
    }
  }

  void _showEditProfessionalBottomSheet(AppointmentModel apm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _EditProfessionalSheet(
          apm: apm,
          onSelect: (StaffModel staff) async {
            try {
              await Supabase.instance.client
                  .from('appointments')
                  .update({'member_id': staff.id})
                  .eq('id', apm.id);

              setState(() {
                apm.professionalId = staff.id;
                apm.professionalName = staff.fullName;
              });
              Navigator.pop(context);
              SnackBarHelper.showSuccess(
                AppLocalizations.of(context)!.professionalUpdated,
              );
            } catch (e) {
              SnackBarHelper.showError(
                AppLocalizations.of(context)!.errorUpdatingProfessional,
              );
            }
          },
        );
      },
    );
  }

  void _showEditTimeBottomSheet(AppointmentModel apm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _EditTimeSheet(
          apm: apm,
          onSelectTime: (DateTime newStart, DateTime newEnd) async {
            try {
              await Supabase.instance.client
                  .from('appointments')
                  .update({
                    'start_time': newStart.toUtc().toIso8601String(),
                    'end_time': newEnd.toUtc().toIso8601String(),
                  })
                  .eq('id', apm.id);

              setState(() {
                apm.startTime = newStart;
                apm.endTime = newEnd;
                widget.appointment.startTime = newStart;
                widget.appointment.endTime = newEnd;
              });
              Navigator.pop(context);
              SnackBarHelper.showSuccess(
                AppLocalizations.of(context)!.timeUpdated,
              );
            } catch (e) {
              SnackBarHelper.showError(
                AppLocalizations.of(context)!.errorUpdatingTime,
              );
            }
          },
        );
      },
    );
  }

  Future<void> _openServiceSelection(AppointmentModel apm) async {
    final result = await showModalBottomSheet<List<ServiceModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ServiceSelectionModal(
        storeId: apm.storeId,
        initialSelected: apm.services,
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final supabase = Supabase.instance.client;

        // 1. Delete old services
        await supabase
            .from('appointment_services')
            .delete()
            .eq('appointment_id', apm.id);

        // 2. Insert new services
        await Future.wait(
          result.map(
            (e) => supabase.from('appointment_services').insert({
              'appointment_id': apm.id,
              'service_id': e.id,
            }),
          ),
        );

        // 3. Calculate new price and duration
        double newTotal = result.fold(0.0, (sum, item) => sum + item.price);
        int newDuration = result.fold(0, (sum, item) => sum + item.duration);
        DateTime newEndTime = apm.startTime.add(Duration(minutes: newDuration));

        // 4. Update appointment
        await supabase
            .from('appointments')
            .update({
              'total_price': newTotal,
              'end_time': newEndTime.toIso8601String(),
            })
            .eq('id', apm.id);

        // 5. Update transaction if pending
        final trans = await inj<TransactionDatasource>()
            .getTransactionByAppointmentId(apm.id);
        if (trans != null && trans.paymentStatus == 'pending') {
          await supabase
              .from('transactions')
              .update({'amount': newTotal})
              .eq('id', trans.id);
        }

        setState(() {
          apm.services = result;
          apm.totalPrice = newTotal;
          apm.endTime = newEndTime;
          widget.appointment.endTime = newEndTime;
          _loadTransaction();
        });

        SnackBarHelper.showSuccess(
          AppLocalizations.of(context)!.updatedAppointmentServices,
        );
      } catch (e) {
        SnackBarHelper.showError(
          AppLocalizations.of(context)!.errorUpdatingAppointmentServices,
        );
        debugPrint(e.toString());
      }
    }
  }

  void _showCancelConfirmationDialog(
    AppointmentModel apm,
    TransactionModel? trans,
  ) {
    bool isPaid = trans?.paymentStatus == 'paid';
    bool refundChecked = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                AppLocalizations.of(context)!.confirmCancel,
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sureToCancelAppointment,
                    style: GoogleFonts.quicksand(),
                  ),
                  if (isPaid) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: refundChecked,
                          onChanged: (val) => setStateDialog(
                            () => refundChecked = val ?? false,
                          ),
                          activeColor: Colors.blue.shade600,
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.refundedForThisCustomer,
                            style: GoogleFonts.quicksand(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: GoogleFonts.quicksand(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _updateAppointmentStatus('cancelled');
                    if (isPaid && refundChecked) {
                      await _updatePayment(trans!, 'refunded');
                    } else if (!isPaid && trans != null) {
                      await _updatePayment(trans, 'cancelled');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.confirmCancel,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final apm = (widget.appointment as StoreAppointment).model;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: FutureBuilder<TransactionModel?>(
        future: transactionFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            );
          }
          final trans = asyncSnapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(AppLocalizations.of(context)!.customerInfo),
                _buildCustomerBlock(apm),
                const SizedBox(height: 24),

                _buildSectionTitle(
                  AppLocalizations.of(context)!.timeAndProfessional,
                ),
                _buildDateTimeBlock(apm),
                const SizedBox(height: 24),

                _buildSectionTitle(
                  AppLocalizations.of(context)!.appointmentStatusTracking,
                ),
                _buildStatusTrackerBlock(apm, trans),
                const SizedBox(height: 24),

                _buildSectionTitle(
                  AppLocalizations.of(context)!.serviceDetails,
                ),
                _buildServiceBlock(apm),
                const SizedBox(height: 24),

                _buildSectionTitle(AppLocalizations.of(context)!.payment),
                _buildPaymentBlock(apm, trans),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCustomerBlock(AppointmentModel apm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE8EAF6),
                child: Text(
                  apm.customerName.isNotEmpty
                      ? apm.customerName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3F51B5),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apm.customerName,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.customer,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoadingClient ? null : _callCustomer,
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(AppLocalizations.of(context)!.call),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoadingClient ? null : _emailCustomer,
                  icon: const Icon(Icons.email, size: 18),
                  label: const Text('Email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeBlock(AppointmentModel apm) {
    bool canEditTime = apm.status == 'pending' || apm.status == 'confirmed';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          InkWell(
            onTap: canEditTime ? () => _showEditTimeBottomSheet(apm) : null,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('📅 ', style: TextStyle(fontSize: 16)),
                      Text(
                        DateFormat('EEE dd MMM').format(apm.startTime),
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Text('🕒 ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          '${DateFormat('h:mm a').format(apm.startTime)} - ${DateFormat('h:mm a').format(apm.endTime)}',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (canEditTime)
                        const Icon(Icons.edit, color: Colors.grey, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (apm.professionalId != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            InkWell(
              onTap: canEditTime
                  ? () => _showEditProfessionalBottomSheet(apm)
                  : null,
              child: Row(
                children: [
                  const Text('👤 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.professionalPrefix}${apm.professionalName ?? AppLocalizations.of(context)!.none}',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (canEditTime)
                    const Icon(Icons.edit, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusTrackerBlock(
    AppointmentModel apm,
    TransactionModel? trans,
  ) {
    int stepIndex = 0;
    if (apm.status == 'confirmed')
      stepIndex = 1;
    else if (apm.status == 'completed')
      stepIndex = 2;
    else if (apm.status == 'cancelled' || apm.status == 'no_show')
      stepIndex = -1; // special case
    else if (apm.status == 'cancel_pending')
      stepIndex = -2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Stepper
          if (stepIndex >= 0)
            Row(
              children: [
                _buildStepItem(
                  AppLocalizations.of(context)!.pending,
                  0,
                  stepIndex,
                ),
                _buildStepLine(0, stepIndex),
                _buildStepItem(
                  AppLocalizations.of(context)!.confirmed,
                  1,
                  stepIndex,
                ),
                _buildStepLine(1, stepIndex),
                _buildStepItem(
                  AppLocalizations.of(context)!.completed,
                  2,
                  stepIndex,
                ),
              ],
            )
          else if (stepIndex == -1)
            Center(
              child: Text(
                apm.status == 'cancelled'
                    ? AppLocalizations.of(context)!.statusCancelled
                    : AppLocalizations.of(context)!.statusNoShow,
                style: GoogleFonts.quicksand(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          else if (stepIndex == -2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.cancellationRequested,
                      style: GoogleFonts.quicksand(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.cancelReason,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        apm.cancelReason ??
                            AppLocalizations.of(context)!.noReasonProvided,
                        style: GoogleFonts.quicksand(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _updateAppointmentStatus('confirmed');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.reject,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showCancelConfirmationDialog(apm, trans);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.accept,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          if (stepIndex >= 0 && stepIndex < 2) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (apm.status == 'pending') {
                        _updateAppointmentStatus('confirmed');
                      } else if (apm.status == 'confirmed') {
                        _updateAppointmentStatus('completed');
                      }
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      apm.status == 'pending'
                          ? AppLocalizations.of(context)!.confirm
                          : AppLocalizations.of(context)!.btnCompleted,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _showStatusOptions(context, apm, trans);
                    },
                    child: const Icon(Icons.settings, color: Colors.black87),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showStatusOptions(
    BuildContext context,
    AppointmentModel apm,
    TransactionModel? trans,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    title: Text(
                      'Cancel',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showCancelConfirmationDialog(apm, trans);
                    },
                  ),
                ),
                if (apm.status == 'confirmed')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListTile(
                      title: Text(
                        'No show',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _updateAppointmentStatus('no_show');
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepItem(String title, int index, int currentIndex) {
    Color color;
    if (index == currentIndex) {
      color = Colors.blue;
    } else if (index < currentIndex) {
      color = Colors.green;
    } else {
      color = Colors.grey.shade400;
    }

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: index < currentIndex
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : (index == currentIndex
                      ? const Icon(Icons.circle, size: 10, color: Colors.white)
                      : const SizedBox()),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 12,
            color: color,
            fontWeight: index == currentIndex
                ? FontWeight.bold
                : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int index, int currentIndex) {
    Color color = index < currentIndex ? Colors.green : Colors.grey.shade300;
    return Expanded(
      child: Container(
        height: 2,
        color: color,
        margin: const EdgeInsets.only(bottom: 24), // to align with circles
      ),
    );
  }

  Widget _buildServiceBlock(AppointmentModel apm) {
    final services = apm.services;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            services[i].name,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${DateTimeHelper.minuteToHourAndMinute(services[i].duration)}',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${NumberFormat.currency(locale: 'vi', symbol: '₫').format(services[i].price)}',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (apm.status == 'pending' || apm.status == 'confirmed')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _openServiceSelection(apm),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    side: BorderSide(
                      color: Colors.blue.shade200,
                      style: BorderStyle.solid,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.editServices,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentBlock(AppointmentModel apm, TransactionModel? trans) {
    if (trans == null) return const SizedBox();

    bool isPaid = trans.paymentStatus == 'paid';
    bool isRefunded = trans.paymentStatus == 'refunded';

    String statusText = '🔴 UNPAID';
    Color statusColor = Colors.red;
    if (isPaid) {
      statusText = '🟢 PAID';
      statusColor = Colors.green;
    } else if (isRefunded) {
      statusText = '⚪ REFUNDED';
      statusColor = Colors.grey;
    } else if (trans.paymentStatus == 'cancelled') {
      statusText = '⚫ CANCELLED';
      statusColor = Colors.black54;
    }

    bool canPay =
        trans.paymentStatus == 'pending' &&
        (apm.status == 'confirmed' || apm.status == 'completed');
    bool canRefund =
        isPaid && (apm.status == 'cancelled' || apm.status == 'completed');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                NumberFormat.currency(
                  locale: 'vi',
                  symbol: '₫',
                ).format(apm.totalPrice),
                style: GoogleFonts.quicksand(
                  fontSize: 15,
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
                AppLocalizations.of(context)!.haveToPay,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                NumberFormat.currency(
                  locale: 'vi',
                  symbol: '₫',
                ).format(apm.totalPrice),
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),
          Text(
            '${AppLocalizations.of(context)!.status}: $statusText',
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          if (isPaid) ...[
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.method}: ${trans.paymentMethod == 'cash' ? AppLocalizations.of(context)!.cash : (trans.paymentMethod == 'transfer' ? AppLocalizations.of(context)!.transfer : trans.paymentMethod)}',
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],

          if (canPay) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showPaymentOptions(trans),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.confirmPayment,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],

          if (canRefund) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showRefundDialog(trans),
                icon: const Icon(Icons.reply, color: Colors.red),
                label: Text(
                  AppLocalizations.of(context)!.refunds,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPaymentOptions(TransactionModel trans) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.selectPaymentMethod,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Image.asset('assets/icons/money-icon.png', height: 30),
                title: Text(
                  AppLocalizations.of(context)!.cash,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updatePayment(trans, 'paid', method: 'cash');
                },
              ),
              ListTile(
                leading: Image.asset('assets/icons/card-icon.png', height: 30),
                title: Text(
                  AppLocalizations.of(context)!.transfer,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updatePayment(trans, 'paid', method: 'transfer');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRefundDialog(TransactionModel trans) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.confirmRefund,
            style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(
              context,
            )!.areYouSureYouWantToRefundThisTransaction,
            style: GoogleFonts.quicksand(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.quicksand(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updatePayment(trans, 'refunded');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                AppLocalizations.of(context)!.refunds,
                style: GoogleFonts.quicksand(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EditProfessionalSheet extends StatefulWidget {
  final AppointmentModel apm;
  final Function(StaffModel) onSelect;

  const _EditProfessionalSheet({required this.apm, required this.onSelect});

  @override
  State<_EditProfessionalSheet> createState() => _EditProfessionalSheetState();
}

class _EditProfessionalSheetState extends State<_EditProfessionalSheet> {
  bool _isLoading = true;
  List<StaffModel> _availableStaffs = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableProfessionals();
  }

  Future<void> _loadAvailableProfessionals() async {
    try {
      final supabase = Supabase.instance.client;
      final staffData = await supabase
          .from('members')
          .select()
          .eq('store_id', widget.apm.storeId)
          .eq('is_active', true);

      List<StaffModel> staffs = staffData
          .map((e) => StaffModel.fromJson(e))
          .toList();

      final overlappingData = await supabase
          .from('appointments')
          .select('member_id')
          .eq('store_id', widget.apm.storeId)
          .inFilter('status', ['confirmed', 'pending'])
          .neq('id', widget.apm.id)
          .lt('start_time', widget.apm.endTime.toIso8601String())
          .gt('end_time', widget.apm.startTime.toIso8601String())
          .not('member_id', 'is', null);

      final busyStaffIds = overlappingData
          .map((e) => e['member_id'] as int)
          .toSet();

      setState(() {
        _availableStaffs = staffs
            .where((s) => !busyStaffIds.contains(s.id))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.selectProfessional,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_availableStaffs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.noAvailableProfessionalsForThisTimeSlot,
                style: GoogleFonts.quicksand(),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              itemCount: _availableStaffs.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (context, index) {
                final staff = _availableStaffs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: staff.avatarUrl != null
                        ? NetworkImage(staff.avatarUrl!)
                        : null,
                    child: staff.avatarUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    staff.fullName,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    staff.jobTitle ?? AppLocalizations.of(context)!.staff,
                    style: GoogleFonts.quicksand(),
                  ),
                  onTap: () => widget.onSelect(staff),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _EditTimeSheet extends StatefulWidget {
  final AppointmentModel apm;
  final Function(DateTime, DateTime) onSelectTime;

  const _EditTimeSheet({required this.apm, required this.onSelectTime});

  @override
  State<_EditTimeSheet> createState() => _EditTimeSheetState();
}

class _EditTimeSheetState extends State<_EditTimeSheet> {
  late DateTime _selectedDate;
  bool _isLoading = true;
  List<String> _availableSlots = [];
  StoreWorkingHourModel? _workingHour;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.apm.startTime.year,
      widget.apm.startTime.month,
      widget.apm.startTime.day,
    );
    _loadSlotsForDate();
  }

  Future<void> _loadSlotsForDate() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final workingHoursData = await supabase
          .from('store_working_hours')
          .select()
          .eq('store_id', widget.apm.storeId);
      final workingHours = workingHoursData
          .map((e) => StoreWorkingHourModel.fromJson(e))
          .toList();

      int dayOfWeek = _selectedDate.weekday == 7
          ? 1
          : _selectedDate.weekday + 1;
      try {
        _workingHour = workingHours.firstWhere((w) => w.dayOfWeek == dayOfWeek);
      } catch (e) {
        _workingHour = null;
      }

      if (_workingHour == null || _workingHour!.isDayOff) {
        setState(() {
          _availableSlots = [];
          _isLoading = false;
        });
        return;
      }

      final startOfDay = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ).toIso8601String();
      final endOfDay = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        23,
        59,
        59,
      ).toIso8601String();

      var query = supabase
          .from('appointments')
          .select('id, start_time, end_time, status')
          .eq('store_id', widget.apm.storeId)
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .inFilter('status', ['confirmed', 'pending'])
          .neq('id', widget.apm.id);

      if (widget.apm.professionalId != null) {
        query = query.eq('member_id', widget.apm.professionalId!);
      }

      final response = await query;
      final appointments = response.map((e) {
        return AppointmentModel(
          id: e['id'] as int,
          startTime: DateTime.parse(e['start_time']),
          endTime: DateTime.parse(e['end_time']),
          status: e['status'] as String,
          storeAddress: '',
          storeName: '',
          totalPrice: 0,
          createdAt: DateTime.now(),
          storeId: widget.apm.storeId,
          services: [],
          customerName: '',
          clientId: 0,
        );
      }).toList();

      int totalDuration = widget.apm.services.fold(
        0,
        (sum, s) => sum + s.duration,
      );
      if (totalDuration == 0) totalDuration = 30;

      List<String> slots = [];
      int currentHour = _workingHour!.startTime.hour;
      int currentMinute = _workingHour!.startTime.minute;
      int endHour = _workingHour!.endTime.hour;
      int endMinute = _workingHour!.endTime.minute;
      int totalEndMinutes = endHour * 60 + endMinute;

      while (currentHour < endHour ||
          (currentHour == endHour && currentMinute < endMinute)) {
        int slotStartInMinutes = currentHour * 60 + currentMinute;
        int slotEndInMinutes = slotStartInMinutes + totalDuration;

        if (slotEndInMinutes > totalEndMinutes) {
          currentMinute += 30;
          if (currentMinute >= 60) {
            currentHour += 1;
            currentMinute -= 60;
          }
          continue;
        }

        bool hasOverlap = false;
        for (var appt in appointments) {
          int apptStart = appt.startTime.hour * 60 + appt.startTime.minute;
          int apptEnd = appt.endTime.hour * 60 + appt.endTime.minute;
          if (slotStartInMinutes < apptEnd && slotEndInMinutes > apptStart) {
            hasOverlap = true;
            break;
          }
        }

        if (!hasOverlap) {
          slots.add(
            '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}',
          );
        }

        currentMinute += 30;
        if (currentMinute >= 60) {
          currentHour += 1;
          currentMinute -= 60;
        }
      }

      setState(() {
        _availableSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint(e.toString());
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadSlotsForDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalDuration = widget.apm.services.fold(
      0,
      (sum, s) => sum + s.duration,
    );
    if (totalDuration == 0) totalDuration = 30;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.selectTime,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEE dd MMM yyyy').format(_selectedDate),
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                label: Text(
                  AppLocalizations.of(context)!.changeDate,
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (_availableSlots.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noAvailableTimeSlots,
                            style: GoogleFonts.quicksand(color: Colors.black),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: _availableSlots.length,
                          itemBuilder: (context, index) {
                            return OutlinedButton(
                              onPressed: () {
                                final parts = _availableSlots[index].split(':');
                                final hour = int.parse(parts[0]);
                                final min = int.parse(parts[1]);
                                final newStart = DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                  _selectedDate.day,
                                  hour,
                                  min,
                                );
                                final newEnd = newStart.add(
                                  Duration(minutes: totalDuration),
                                );
                                widget.onSelectTime(newStart, newEnd);
                              },
                              child: Text(
                                _availableSlots[index],
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        )),
          ),
        ],
      ),
    );
  }
}

class _ServiceSelectionModal extends StatefulWidget {
  final int storeId;
  final List<ServiceModel> initialSelected;
  const _ServiceSelectionModal({
    required this.storeId,
    required this.initialSelected,
  });

  @override
  State<_ServiceSelectionModal> createState() => _ServiceSelectionModalState();
}

class _ServiceSelectionModalState extends State<_ServiceSelectionModal> {
  List<CategoryModel> _categories = [];
  Map<int, List<ServiceModel>> _servicesByCategory = {};
  String _searchQuery = '';
  bool _isLoading = true;
  List<ServiceModel> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    _selectedServices = List.from(widget.initialSelected);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categories = await inj<StoreDatasource>().fetchCategorys(
        widget.storeId,
      );
      final Map<int, List<ServiceModel>> servicesMap = {};

      for (var cat in categories) {
        final services = await inj<StoreDatasource>().fetchServices(cat.id);
        servicesMap[cat.id] = services;
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _servicesByCategory = servicesMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.selectService,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchByServiceName,
                hintStyle: GoogleFonts.quicksand(),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6B4EFF)),
                  )
                : ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final allServices =
                          _servicesByCategory[category.id] ?? [];

                      final filteredServices = _searchQuery.isEmpty
                          ? allServices
                          : allServices
                                .where(
                                  (s) => s.name.toLowerCase().contains(
                                    _searchQuery,
                                  ),
                                )
                                .toList();

                      if (filteredServices.isEmpty)
                        return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  category.name,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${filteredServices.length}',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredServices.length,
                            separatorBuilder: (context, i) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final s = filteredServices[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 40,
                                      color: Colors.lightBlue,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name,
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${s.duration} ' +
                                                AppLocalizations.of(
                                                  context,
                                                )!.minute,
                                            style: GoogleFonts.quicksand(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${s.price.toInt()} đ',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing:
                                    _selectedServices.any((e) => e.id == s.id)
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.indigo,
                                      )
                                    : const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.grey,
                                      ),
                                onTap: () {
                                  setState(() {
                                    if (_selectedServices.any(
                                      (e) => e.id == s.id,
                                    )) {
                                      _selectedServices.removeWhere(
                                        (e) => e.id == s.id,
                                      );
                                    } else {
                                      _selectedServices.add(s);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _selectedServices.isEmpty
                    ? null
                    : () => Navigator.pop(context, _selectedServices),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.confirm +
                      ' (${_selectedServices.length})',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
