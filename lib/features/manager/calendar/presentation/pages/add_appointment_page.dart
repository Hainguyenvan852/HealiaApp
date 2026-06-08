import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/manager/client/presentation/pages/add_client_page.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/shared/datasource/transaction_datasource.dart';
import 'package:healio_app/shared/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../features/user/home/data/models/store_working_hour_model.dart';

import '../../../../../../core/injector/dependency_injector.dart';
import '../../../../../../shared/models/client_model.dart';
import '../../../../../../shared/datasource/client_datasource.dart';
import '../../../../../../features/user/explore/data/datasources/store_datasource.dart';
import '../../../../../../features/user/home/data/models/service_model.dart';
import '../../../../../../features/user/home/data/models/category_model.dart';
import '../../../../../core/utils/color_theme.dart';
import '../../../../../../features/user/appointment/data/models/appointment_model.dart';
import '../../../../../../features/user/appointment/data/datasource/appointment_datasource.dart';
import '../../../../../../features/user/home/data/models/staff_model.dart';
import '../../../../../l10n/app_localizations.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({
    super.key,
    required this.selectedDate,
    required this.managerId,
    this.availableMinutes,
  });
  final DateTime? selectedDate;
  final String managerId;
  final int? availableMinutes;

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  ClientModel? _selectedCustomer;
  StaffModel? _selectedProfessional;
  List<ServiceModel> _selectedServices = [];
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  late final Future<StoreModel> storeFuture;
  bool isBooking = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
      _selectedTime = TimeOfDay.fromDateTime(widget.selectedDate!);
    } else {
      final now = DateTime.now();
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedTime = null;
    }
    storeFuture = inj<StoreDatasource>().getStoreByMangerId(widget.managerId);
  }

  Map<String, int> convertMinutesToMap(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    return {'hour': hours, 'minute': minutes};
  }

  Future<void> _openCustomerSelection(int storeId) async {
    final result = await showModalBottomSheet<ClientModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CustomerSelectionModal(storeId: storeId),
    );

    if (result != null) {
      setState(() {
        _selectedCustomer = result;
      });
    }
  }

  Future<void> _openProfessionalSelection(int storeId) async {
    final totalDuration = _selectedServices.fold(
      0,
      (sum, item) => sum + item.duration,
    );
    final result = await showModalBottomSheet<StaffModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ProfessionalSelectionModal(
        storeId: storeId,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        totalDuration: totalDuration,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedProfessional = result;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B4EFF),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B4EFF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked.add(
          Duration(hours: _selectedDate.hour, minutes: _selectedDate.minute),
        );
        _selectedProfessional = null;
      });
    }
  }

  Future<void> _openServiceSelection(int storeId) async {
    final result = await showModalBottomSheet<List<ServiceModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ServiceSelectionModal(
        storeId: storeId,
        initialSelected: _selectedServices,
        availableMinutes: widget.availableMinutes,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedServices = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storeFuture,
      builder: (context, asyncSnapshot) {
        bool canSave =
            _selectedCustomer != null &&
            _selectedServices.isNotEmpty &&
            _selectedTime != null;
        if (asyncSnapshot.hasData && asyncSnapshot.data!.storeType == 'team') {
          canSave = canSave && _selectedProfessional != null;
        }

        if (asyncSnapshot.connectionState == ConnectionState.waiting &&
            !asyncSnapshot.hasData) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            ),
          );
        }

        if (asyncSnapshot.hasError && !asyncSnapshot.hasData) {
          return Scaffold(body: const SizedBox.shrink());
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: isBooking ? null : () => _selectDate(context),
                  child: Text(
                    DateFormat('EEE, dd MMM').format(_selectedDate),
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: isBooking ? null : () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomerBlock(asyncSnapshot.data!.id),
                const SizedBox(height: 16),
                if (asyncSnapshot.data!.storeType == 'team') ...[
                  _buildProfessionalBlock(asyncSnapshot.data!.id),
                  const SizedBox(height: 16),
                ],

                _buildDateTimeBlock(asyncSnapshot.data!.id),
                const SizedBox(height: 24),

                Text(
                  AppLocalizations.of(context)!.services,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildServiceBlock(asyncSnapshot.data!.id),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(canSave),
        );
      },
    );
  }

  Widget _buildCustomerBlock(int storeId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isBooking ? null : () => _openCustomerSelection(storeId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: _selectedCustomer == null
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.addClient,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.addClientsToContinueCreateAppointment,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.indigo.shade50,
                        child: Icon(
                          PhosphorIcons.userPlus(),
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedCustomer!.fullName,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedCustomer!.email,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE8EAF6),
                        child: Text(
                          _selectedCustomer!.fullName.isNotEmpty
                              ? _selectedCustomer!.fullName[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F51B5),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalBlock(int storeId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isBooking ? null : () => _openProfessionalSelection(storeId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: _selectedProfessional == null
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectProfessional,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.selectProfessionalForAppointment,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.indigo.shade50,
                        child: Icon(
                          PhosphorIcons.userPlus(),
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedProfessional!.fullName,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.professional,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE8EAF6),
                        child: Text(
                          _selectedProfessional!.fullName.isNotEmpty
                              ? _selectedProfessional!.fullName[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F51B5),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeBlock(int storeId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: Colors.black87,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  DateFormat('EEE dd MMM').format(_selectedDate),
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.access_time, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  final totalDuration = _selectedServices.fold(
                    0,
                    (sum, item) => sum + item.duration,
                  );
                  final pickedTime = await showModalBottomSheet<TimeOfDay>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _SelectTimeSheet(
                      storeId: storeId,
                      selectedDate: _selectedDate,
                      selectedProfessionalId: _selectedProfessional?.id,
                      totalDuration: totalDuration == 0 ? 30 : totalDuration,
                    ),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedTime = pickedTime;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Chọn giờ',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              const Icon(Icons.repeat, size: 20, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.once,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBlock(int storeId) {
    if (_selectedServices.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_offer,
                color: Colors.purpleAccent,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.addServicesToSaveAppointments,
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: isBooking
                  ? null
                  : () => _openServiceSelection(storeId),
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text(
                AppLocalizations.of(context)!.addService,
                style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            ..._selectedServices
                .map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.name,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${service.duration} ${AppLocalizations.of(context)!.minute}',
                                          style: GoogleFonts.quicksand(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${service.price.toInt()} đ',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: isBooking ? null : () => _openServiceSelection(storeId),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.addAnotherService,
                      style: GoogleFonts.quicksand(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTotalBlock() {
    final totalPrice = _selectedServices.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 16.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '${totalPrice.toInt()} đ',
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.haveToPay,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20, color: Colors.black),
                ],
              ),
              Text(
                '${totalPrice.toInt()} đ',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool canSave) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedServices.isNotEmpty) _buildTotalBlock(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isBooking
                        ? null
                        : (canSave
                              ? () async {
                                  setState(() {
                                    isBooking = true;
                                  });
                                  final store = await storeFuture;
                                  final totalDuration = _selectedServices.fold(
                                    0.0,
                                    (sum, item) => sum + item.duration,
                                  );
                                  final result = convertMinutesToMap(
                                    totalDuration.toInt(),
                                  );
                                  final finalStartTime = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month,
                                    _selectedDate.day,
                                    _selectedTime!.hour,
                                    _selectedTime!.minute,
                                  );
                                  final apm = AppointmentModel(
                                    id: 0,
                                    startTime: finalStartTime,
                                    endTime: finalStartTime.add(
                                      Duration(
                                        hours: result['hour'] as int,
                                        minutes: result['minute'] as int,
                                      ),
                                    ),
                                    status: 'confirmed',
                                    notes: '',
                                    totalPrice: _selectedServices.fold(
                                      0.0,
                                      (sum, item) => sum + item.price,
                                    ),
                                    createdAt: DateTime.now(),
                                    customerId:
                                        _selectedCustomer!.profileId ?? null,
                                    storeId: store.id,
                                    professionalId: _selectedProfessional?.id,
                                    services: _selectedServices,
                                    storeName: store.name,
                                    storeAddress: store.address,
                                    customerName: _selectedCustomer!.fullName,
                                    clientId: _selectedCustomer!.id,
                                  );

                                  try {
                                    final success =
                                        await inj<AppointmentDatasource>()
                                            .createNewAppointment(apm);
                                    if (success != null && mounted) {
                                      final trans = TransactionModel(
                                        id: 0,
                                        customerId:
                                            _selectedCustomer!.profileId ??
                                            null,
                                        amount: _selectedServices.fold(
                                          0.0,
                                          (sum, item) => sum + item.price,
                                        ),
                                        createdAt: DateTime.now(),
                                        clientId: _selectedCustomer!.id,
                                        appointmentId: success,
                                        storeId: store.id,
                                        paymentMethod: 'at_store',
                                        paymentStatus: 'pending',
                                      );
                                      await inj<TransactionDatasource>()
                                          .createTransaction(trans);

                                      SnackBarHelper.showSuccess(
                                        'Appointment created successfully',
                                      );
                                      Navigator.pop(context, true);
                                    } else if (mounted) {
                                      SnackBarHelper.showError(
                                        'Failed to create appointment',
                                      );
                                    }
                                    setState(() {
                                      isBooking = false;
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      SnackBarHelper.showError(e.toString());
                                    }
                                    setState(() {
                                      isBooking = false;
                                    });
                                  }
                                }
                              : null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: isBooking
                        ? LoadingAnimationWidget.progressiveDots(
                            color: Colors.white,
                            size: 30,
                          )
                        : Text(
                            'Save',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerSelectionModal extends StatefulWidget {
  final int storeId;
  const _CustomerSelectionModal({required this.storeId});

  @override
  State<_CustomerSelectionModal> createState() =>
      _CustomerSelectionModalState();
}

class _CustomerSelectionModalState extends State<_CustomerSelectionModal> {
  List<ClientModel> _allClients = [];
  List<ClientModel> _filteredClients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await inj<ClientDatasource>().getClientsByStoreId(
        widget.storeId,
      );
      if (mounted) {
        setState(() {
          _allClients = clients;
          _filteredClients = clients;
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
      if (query.isEmpty) {
        _filteredClients = _allClients;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredClients = _allClients
            .where(
              (client) =>
                  client.fullName.toLowerCase().contains(lowerQuery) ||
                  (client.email.toLowerCase().contains(lowerQuery)) ||
                  (client.phoneNumber?.toLowerCase().contains(lowerQuery) ??
                      false),
            )
            .toList();
      }
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
                  'Select client',
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
                hintText: 'Search for customers or leave blank for...',
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
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6B4EFF)),
                  )
                : ListView(
                    children: [
                      _buildActionItem(
                        Icons.add,
                        'Add new client',
                        Colors.indigo,
                        () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddNewClientPage(storeId: widget.storeId),
                            ),
                          );
                          if (result == true) {
                            _loadClients();
                          }
                        },
                      ),
                      const Divider(),
                      ..._filteredClients.map(
                        (c) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade50,
                            child: Text(
                              c.fullName.isNotEmpty
                                  ? c.fullName[0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.quicksand(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            c.fullName,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            c.email,
                            style: GoogleFonts.quicksand(),
                          ),
                          onTap: () => Navigator.pop(context, c),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}

class _ServiceSelectionModal extends StatefulWidget {
  final int storeId;
  final List<ServiceModel> initialSelected;
  final int? availableMinutes;
  const _ServiceSelectionModal({
    required this.storeId,
    required this.initialSelected,
    this.availableMinutes,
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
                  'Chọn dịch vụ',
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
                hintText: 'Tìm kiếm theo tên dịch vụ',
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
                              final bool isDisabled =
                                  widget.availableMinutes != null &&
                                  s.duration > widget.availableMinutes!;

                              return ListTile(
                                enabled: !isDisabled,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 40,
                                      color: isDisabled
                                          ? Colors.grey
                                          : Colors.lightBlue,
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
                                              color: isDisabled
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${s.duration} phút',
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
                                        color: isDisabled
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing:
                                    _selectedServices.any((e) => e.id == s.id)
                                    ? Icon(
                                        Icons.check_circle,
                                        color: isDisabled
                                            ? Colors.grey
                                            : Colors.indigo,
                                      )
                                    : const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.grey,
                                      ),
                                onTap: isDisabled
                                    ? null
                                    : () {
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
                onPressed: () => Navigator.pop(context, _selectedServices),
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
                  'Xác nhận (${_selectedServices.length})',
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

class _ProfessionalSelectionModal extends StatefulWidget {
  final int storeId;
  final DateTime selectedDate;
  final TimeOfDay? selectedTime;
  final int totalDuration;

  const _ProfessionalSelectionModal({
    required this.storeId,
    required this.selectedDate,
    required this.selectedTime,
    required this.totalDuration,
  });

  @override
  State<_ProfessionalSelectionModal> createState() =>
      _ProfessionalSelectionModalState();
}

class _ProfessionalSelectionModalState
    extends State<_ProfessionalSelectionModal> {
  List<StaffModel> _allProfessionals = [];
  List<StaffModel> _filteredProfessionals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    try {
      final professionals = await inj<StoreDatasource>()
          .fetchTeamMembersByStore(widget.storeId);

      Set<int> busyStaffIds = {};
      if (widget.selectedTime != null) {
        final startTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          widget.selectedTime!.hour,
          widget.selectedTime!.minute,
        );
        final endTime = startTime.add(
          Duration(
            minutes: widget.totalDuration == 0 ? 30 : widget.totalDuration,
          ),
        );

        final supabase = Supabase.instance.client;
        final overlappingData = await supabase
            .from('appointments')
            .select('member_id')
            .eq('store_id', widget.storeId)
            .inFilter('status', ['confirmed', 'pending'])
            .lt('start_time', endTime.toIso8601String())
            .gt('end_time', startTime.toIso8601String())
            .not('member_id', 'is', null);

        busyStaffIds = overlappingData
            .map((e) => e['member_id'] as int)
            .toSet();
      }

      final availableProfessionals = professionals
          .where((s) => !busyStaffIds.contains(s.id))
          .toList();

      if (mounted) {
        setState(() {
          _allProfessionals = availableProfessionals;
          _filteredProfessionals = availableProfessionals;
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
      if (query.isEmpty) {
        _filteredProfessionals = _allProfessionals;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredProfessionals = _allProfessionals
            .where((prof) => prof.fullName.toLowerCase().contains(lowerQuery))
            .toList();
      }
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
                  'Select professional',
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
                hintText: 'Search for professional...',
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
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.mainAppColor(),
                      size: 40,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredProfessionals.length,
                    itemBuilder: (context, index) {
                      final prof = _filteredProfessionals[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE8EAF6),
                          child: Text(
                            prof.fullName.isNotEmpty
                                ? prof.fullName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                        ),
                        title: Text(
                          prof.fullName,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, prof);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SelectTimeSheet extends StatefulWidget {
  final int storeId;
  final DateTime selectedDate;
  final int? selectedProfessionalId;
  final int totalDuration;

  const _SelectTimeSheet({
    required this.storeId,
    required this.selectedDate,
    required this.selectedProfessionalId,
    required this.totalDuration,
  });

  @override
  State<_SelectTimeSheet> createState() => _SelectTimeSheetState();
}

class _SelectTimeSheetState extends State<_SelectTimeSheet> {
  bool _isLoading = true;
  List<String> _availableSlots = [];
  StoreWorkingHourModel? _workingHour;

  @override
  void initState() {
    super.initState();
    _loadSlotsForDate();
  }

  Future<void> _loadSlotsForDate() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final workingHoursData = await supabase
          .from('store_working_hours')
          .select()
          .eq('store_id', widget.storeId);
      final workingHours = workingHoursData
          .map((e) => StoreWorkingHourModel.fromJson(e))
          .toList();

      int dayOfWeek = widget.selectedDate.weekday == 7
          ? 1
          : widget.selectedDate.weekday + 1;
      try {
        _workingHour = workingHours.firstWhere((w) => w.dayOfWeek == dayOfWeek);
      } catch (e) {
        _workingHour = null;
      }

      if (_workingHour == null || _workingHour!.isDayOff) {
        if (mounted) {
          setState(() {
            _availableSlots = [];
            _isLoading = false;
          });
        }
        return;
      }

      final startOfDay = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      ).toIso8601String();
      final endOfDay = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        23,
        59,
        59,
      ).toIso8601String();

      var query = supabase
          .from('appointments')
          .select('id, start_time, end_time, status')
          .eq('store_id', widget.storeId)
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .inFilter('status', ['confirmed', 'pending']);

      if (widget.selectedProfessionalId != null) {
        query = query.eq('member_id', widget.selectedProfessionalId!);
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
          storeId: widget.storeId,
          services: [],
          customerName: '',
          clientId: 0,
        );
      }).toList();

      int totalDuration = widget.totalDuration;

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

        DateTime slotStart = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          currentHour,
          currentMinute,
        );
        DateTime slotEnd = slotStart.add(Duration(minutes: totalDuration));

        bool isOverlapping = appointments.any((apm) {
          return apm.startTime.isBefore(slotEnd) &&
              apm.endTime.isAfter(slotStart);
        });

        if (!isOverlapping && slotStart.isAfter(DateTime.now())) {
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

      if (mounted) {
        setState(() {
          _availableSlots = slots;
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
            'Chọn giờ',
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
          else if (_availableSlots.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Không có khung giờ trống nào',
                style: GoogleFonts.quicksand(),
              ),
            )
          else
            SizedBox(
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final timeStr = _availableSlots[index];
                  return InkWell(
                    onTap: () {
                      final parts = timeStr.split(':');
                      final selectedTime = TimeOfDay(
                        hour: int.parse(parts[0]),
                        minute: int.parse(parts[1]),
                      );
                      Navigator.pop(context, selectedTime);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        timeStr,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
