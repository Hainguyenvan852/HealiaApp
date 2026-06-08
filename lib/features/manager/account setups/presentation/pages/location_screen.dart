import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../../l10n/app_localizations.dart';
import '../blocs/account_setup_cubit.dart';
import 'survey_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/utils/snackbar_helper.dart';
import '../../../widgets/step_progress_bar.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _locationContrl = TextEditingController();
  List<dynamic> places = [];
  bool isShow = false;
  Map<String, dynamic>? details;

  @override
  void dispose() {
    _locationContrl.dispose();
    super.dispose();
  }

  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
        'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C',
      );
      var response = await http.get(url);

      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        isShow = true;
      });
    } catch (e) {
      SnackBarHelper.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: StepProgressBar(currentStep: 4, totalSteps: 5),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.accountSetup,
              style: GoogleFonts.quicksand(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.setPhysicalLocation,
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.addPrimaryBusinessLocation,
              style: GoogleFonts.quicksand(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              AppLocalizations.of(context)!.whereIsBusinessLocated,
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationContrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  fetchData(value);
                }
                if (_locationContrl.text.isEmpty) {
                  setState(() {
                    places.clear();
                    isShow = false;
                  });
                }
              },
            ),

            const SizedBox(height: 10),
            if (isShow == true) Expanded(child: _buildListView()),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            double lat = 0.0;
            double lng = 0.0;
            if (details != null && details!['geometry'] != null) {
              lat = (details!['geometry']['location']['lat'] as num).toDouble();
              lng = (details!['geometry']['location']['lng'] as num).toDouble();
            }
            if (_locationContrl.text.isNotEmpty) {
              final paths = _locationContrl.text.split(',');

              context.read<AccountSetupCubit>().setLocation(
                address: _locationContrl.text,
                lat: lat,
                lng: lng,
                province: paths.isNotEmpty ? paths.last.trim() : '',
              );
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AccountSetupCubit>(),
                  child: const SurveyScreen(),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.continuee,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: places.length < 5 ? places.length : 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 0),
      itemBuilder: (_, index) {
        final coordinate = places[index];

        return ListTile(
          horizontalTitleGap: 5,
          leading: Container(
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                size: 21,
                color: Colors.black54,
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          title: Text(
            coordinate['structured_formatting']['main_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            coordinate['structured_formatting']['secondary_text'],
            softWrap: true,
            style: GoogleFonts.quicksand(
              color: Colors.black.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            try {
              final url = Uri.parse(
                'https://rsapi.goong.io/place/detail?place_id=${coordinate['place_id']}&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C',
              );
              var response = await http.get(url);
              final jsonResponse = jsonDecode(response.body);

              details = jsonResponse['result'];
              _locationContrl.setText(details!['formatted_address']);
              setState(() {
                isShow = false;
              });
            } catch (e) {
              SnackBarHelper.showError(e.toString());
            } finally {
              if (!mounted) return;
            }
          },
        );
      },
    );
  }
}
