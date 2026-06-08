import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/shared/datasource/transaction_datasource.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import '../../../../../l10n/app_localizations.dart';

enum TransStatus { all, paid, pending, refunded, cancelled }

class ClientTransactionsPage extends StatefulWidget {
  final ClientModel client;
  const ClientTransactionsPage({super.key, required this.client});

  @override
  State<ClientTransactionsPage> createState() => _ClientTransactionsPageState();
}

class _ClientTransactionsPageState extends State<ClientTransactionsPage> {
  TransStatus _selectedFilter = TransStatus.all;
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = inj<TransactionDatasource>().getClientTransactionsWithService(
      widget.client.id,
      widget.client.storeId,
    );
  }

  TransStatus _mapStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'paid':
        return TransStatus.paid;
      case 'pending':
        return TransStatus.pending;
      case 'refunded':
        return TransStatus.refunded;
      case 'cancelled':
      case 'failed':
        return TransStatus.cancelled;
      default:
        return TransStatus.pending;
    }
  }

  List<Map<String, dynamic>> _filterTransactions(
    List<Map<String, dynamic>> allTransactions,
  ) {
    if (_selectedFilter == TransStatus.all) {
      return allTransactions;
    }
    return allTransactions
        .where((trans) => _mapStatus(trans['payment_status'] ?? '') == _selectedFilter)
        .toList();
  }

  void _showExtraFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                _buildSheetItem(AppLocalizations.of(context)!.refunded, TransStatus.refunded),
                _buildSheetItem(AppLocalizations.of(context)!.cancelled, TransStatus.cancelled),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetItem(String title, TransStatus status) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: _selectedFilter == status
                ? FontWeight.bold
                : FontWeight.w600,
            color: _selectedFilter == status
                ? const Color(0xFF6B4EFF)
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientName = widget.client.fullName;
    final initial = clientName.isNotEmpty ? clientName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Text(
                initial,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF6B4EFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              clientName,
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.transaction,
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill(AppLocalizations.of(context)!.all, TransStatus.all),
                  const SizedBox(width: 12),
                  _buildFilterPill(AppLocalizations.of(context)!.paid, TransStatus.paid),
                  const SizedBox(width: 12),
                  _buildFilterPill(AppLocalizations.of(context)!.pending, TransStatus.pending),
                  const SizedBox(width: 12),
                  _buildDropdownPill(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.mainAppColor(),
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.quicksand(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final allTransactions = snapshot.data!;
                final filteredList = _filterTransactions(allTransactions);

                if (filteredList.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.transaction,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
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
                              '${allTransactions.length}',
                              style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 40,
                        ),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final trans = filteredList[index];
                          final bool isLast = index == filteredList.length - 1;
                          return _buildTimelineItem(trans, isLast);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, TransStatus status) {
    bool isActive = _selectedFilter == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPill() {
    bool isDropdownActive =
        _selectedFilter != TransStatus.all &&
        _selectedFilter != TransStatus.paid &&
        _selectedFilter != TransStatus.pending;
    String displayText = isDropdownActive
        ? _getStatusText(context, _selectedFilter)
        : AppLocalizations.of(context)!.more;

    return GestureDetector(
      onTap: _showExtraFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDropdownActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDropdownActive ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              displayText,
              style: GoogleFonts.quicksand(
                color: isDropdownActive ? Colors.white : Colors.black87,
                fontWeight: isDropdownActive
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: isDropdownActive ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(
                0xFFB8A2FF,
              ), // Light purple similar to the image
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noTransactions,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noTransactionsDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> data, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_offer_outlined,
                    color: Colors.white,
                    size: 14,
                  ), // Icon tag
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1.5, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _buildTransactionCard(data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> data) {
    DateTime createdAt = data['created_at'] != null ? DateTime.parse(data['created_at']).toLocal() : DateTime.now();
    String dayStr = DateFormat('dd MMM yyyy', 'vi').format(createdAt);
    
    TransStatus currentStatus = _mapStatus(data['payment_status'] ?? '');
    String statusText = _getStatusText(context, currentStatus);
    Color statusColor = _getStatusColor(currentStatus);

    // Extract service name from appointments
    String serviceName = AppLocalizations.of(context)!.unknownService;
    if (data['appointments'] != null) {
      var apt = data['appointments'];
      if (apt['appointment_services'] != null) {
        List servicesList = apt['appointment_services'];
        if (servicesList.isNotEmpty) {
          serviceName = servicesList[0]['services']['name'] ?? AppLocalizations.of(context)!.unknownService;
        }
      }
    }

    double price = (data['amount'] as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.appointmentPayment,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              children: [
                TextSpan(text: '$dayStr • '),
                TextSpan(
                  text: statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text(
                '${price.toInt()} đ',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${price.toInt()} đ',
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

  String _getStatusText(BuildContext context, TransStatus status) {
    switch (status) {
      case TransStatus.paid:
        return AppLocalizations.of(context)!.paid;
      case TransStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case TransStatus.refunded:
        return AppLocalizations.of(context)!.refunded;
      case TransStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
      default:
        return '';
    }
  }

  Color _getStatusColor(TransStatus status) {
    switch (status) {
      case TransStatus.paid:
        return const Color(0xFF00B074);
      case TransStatus.pending:
        return Colors.orange.shade700;
      case TransStatus.refunded:
        return const Color(0xFF6B4EFF);
      case TransStatus.cancelled:
        return Colors.red.shade700;
      default:
        return Colors.black;
    }
  }
}
