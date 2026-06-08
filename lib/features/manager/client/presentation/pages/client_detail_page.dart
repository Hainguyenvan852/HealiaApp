import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/manager/client/presentation/pages/update_client_detail_page.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:intl/intl.dart';
import '../../../../../l10n/app_localizations.dart';

class ClientDetailsPage extends StatefulWidget {
  const ClientDetailsPage({super.key, required this.client});
  final ClientModel client;

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  late ClientModel _client;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
  }

  String genderByInt(BuildContext context, int? gender) {
    if (gender == 1) {
      return AppLocalizations.of(context)!.male;
    } else if (gender == 2) {
      return AppLocalizations.of(context)!.female;
    } else {
      return AppLocalizations.of(context)!.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context, _client),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFF3F0FF),
              child: Text(
                _client.fullName.isNotEmpty ? _client.fullName[0] : '?',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF6B4EFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _client.fullName,
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.clientDetails,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final updatedClient = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateClientDetailPage(client: _client),
                      ),
                    );
                    if (updatedClient != null && updatedClient is ClientModel) {
                      setState(() {
                        _client = updatedClient;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.edit,
                        style: GoogleFonts.quicksand(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              AppLocalizations.of(context)!.profile,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            _buildInfoRow(
              AppLocalizations.of(context)!.fullName,
              _client.fullName,
              'Email',
              _client.email,
            ),
            const SizedBox(height: 24),

            _buildInfoRow(
              AppLocalizations.of(context)!.phoneNumber,
              _client.phoneNumber ?? '-',
              AppLocalizations.of(context)!.dateOfBirth,
              _client.dateOfBirth != null
                  ? DateFormat('dd/MM/yyyy').format(_client.dateOfBirth!)
                  : '-',
            ),
            const SizedBox(height: 24),

            _buildInfoRow(AppLocalizations.of(context)!.gender, genderByInt(context, _client.gender), '', ''),
            const SizedBox(height: 24),

            _buildSingleInfo(
              AppLocalizations.of(context)!.joined,
              DateFormat('dd/MM/yyyy').format(_client.createdAt),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSingleInfo(title1, value1)),
        const SizedBox(width: 16),
        Expanded(child: _buildSingleInfo(title2, value2)),
      ],
    );
  }

  Widget _buildSingleInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
