import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/manager/client/presentation/pages/client_appointment_page.dart';
import 'package:healio_app/features/manager/client/presentation/pages/client_detail_page.dart';
import 'package:healio_app/features/manager/client/presentation/pages/client_review_page.dart';
import 'package:healio_app/features/manager/client/presentation/pages/client_transaction_page.dart';
import 'package:healio_app/shared/models/client_model.dart';

import '../../../../../core/injector/dependency_injector.dart';
import '../../../../../shared/datasource/client_datasource.dart';
import 'update_client_detail_page.dart';
import '../../../../../l10n/app_localizations.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key, required this.client});

  final ClientModel client;

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  late ClientModel _client;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
  }

  void showClientActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return _ClientActionsMenu(
          onEditTap: () async {
            final updatedClient = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateClientDetailPage(client: _client),
              ),
            );
            if (updatedClient != null && updatedClient is ClientModel) {
              setState(() {
                _client = updatedClient;
              });
            }
          },
          onDeleteTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.deleteClient,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  AppLocalizations.of(context)!.confirmDeleteClient,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      AppLocalizations.of(context)!.delete,
                      style: GoogleFonts.quicksand(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              try {
                await inj<ClientDatasource>().deleteClient(_client.id);
                if (mounted) {
                  Navigator.pop(context); // close bottom sheet
                  Navigator.pop(context, 'deleted'); // return to menu page
                }
              } catch (e) {
                if (mounted) {
                  SnackBarHelper.showError('Error deleting client: $e');
                }
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black87),
                      onPressed: () => showClientActionsBottomSheet(context),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black87,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context, _client),
                  ),
                ],
              ),

              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFF3F0FF),
                child: Text(
                  _client.fullName.isNotEmpty ? _client.fullName[0] : '?',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFF6B4EFF),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _client.fullName,
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _client.email,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      AppLocalizations.of(context)!.clientDetails,
                      onTap: () async {
                        final updatedClient = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientDetailsPage(client: _client),
                          ),
                        );
                        if (updatedClient != null &&
                            updatedClient is ClientModel) {
                          setState(() {
                            _client = updatedClient;
                          });
                        }
                      },
                    ),
                    _buildMenuItem(
                      AppLocalizations.of(context)!.appointments,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientAppointmentsPage(client: _client),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      AppLocalizations.of(context)!.transactions,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientTransactionsPage(client: _client),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      AppLocalizations.of(context)!.reviews1,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientReviewsPage(client: _client),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}

class _ClientActionsMenu extends StatelessWidget {
  const _ClientActionsMenu({
    required this.onEditTap,
    required this.onDeleteTap,
  });
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            _buildActionItem(
              textColor: Colors.black,
              title: AppLocalizations.of(context)!.editClientInfo,
              onTap: () => onEditTap(),
            ),
            _buildActionItem(
              textColor: Colors.red,
              title: AppLocalizations.of(context)!.deleteClient,
              onTap: () => onDeleteTap(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required Color textColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
