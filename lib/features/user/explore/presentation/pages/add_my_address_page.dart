import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/profile/data/models/address_model.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/utils/snackbar_helper.dart';
import '../../../profile/presentation/blocs/user_address_bloc.dart';
import '../widgets/search_text_field_1.dart';
import 'add_address_page.dart';

class AddMyAddressPage extends StatefulWidget {
  const AddMyAddressPage({super.key, required this.addressName});
  final String addressName;

  @override
  State<AddMyAddressPage> createState() => _AddMyAddressPageState();
}

class _AddMyAddressPageState extends State<AddMyAddressPage> {
  final _searchController = TextEditingController();
  List<dynamic> places = [];
  bool isShow = false;
  late Map<String, dynamic> details;

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
              _searchController.text = details['name'];

              final address = AddressModel(
                id: 0,
                name: widget.addressName,
                address: details['formatted_address'],
                province: details['compound']['province'],
                lat: details['geometry']['location']['lat'],
                lng: details['geometry']['location']['lng'],
                commune: details['compound']['commune'],
                district: details['compound']['district'],
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<UserAddressBloc>(),
                    child: AddAddressPage(address: address, isUpdate: false),
                  ),
                ),
              );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppLocalizations.of(context)!.add} ${widget.addressName}',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SearchTextField1(
                controller: _searchController,
                prefixIcon: PhosphorIcon(PhosphorIcons.mapPin(), size: 21),
                isReadOnly: false,
                isAutoFocus: true,
                suffixIcon: Icon(Icons.cancel_outlined, size: 20),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    fetchData(value);
                  }
                  if (_searchController.text.isEmpty) {
                    setState(() {
                      places.clear();
                      isShow = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              if (isShow == true) Expanded(child: _buildListView()),
            ],
          ),
        ),
      ),
    );
  }
}
