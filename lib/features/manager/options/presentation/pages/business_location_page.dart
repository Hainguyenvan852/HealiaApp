import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import '../../../../../core/utils/color_theme.dart';
import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../../l10n/app_localizations.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  StoreModel? _store;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
  }

  Future<void> _fetchStoreDetails() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final store = await inj<StoreDatasource>().getStoreByMangerId(user.id);
      if (mounted) {
        setState(() {
          _store = store;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      SnackBarHelper.showError(e.toString());
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 40,
              ),
            )
          : _store == null
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.storeNotFound,
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.locations,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.manageLocationInfoDesc,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          color: const Color(0xFFF3F2FD),
                          child: const Center(
                            child: Icon(
                              Icons.storefront_outlined,
                              size: 64,
                              color: Color(0xFF5E5CE6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _store!.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                                Text(
                                  _store!.ratingNumber == 0
                                      ? AppLocalizations.of(context)!.noRatingsYet
                                      : '${_store!.ratingNumber} ${AppLocalizations.of(context)!.reviews}',
                                  style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_store!.address}, ${_store!.province}',
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () =>
                                    _showLocationOptionsBottomSheet(context),
                                borderRadius: BorderRadius.circular(24),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showLocationOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.edit,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditLocationBottomSheet(context);
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditLocationBottomSheet(BuildContext context) {
    if (_store == null) return;

    final TextEditingController addressController = TextEditingController(
      text: _store!.address,
    );
    final TextEditingController provinceController = TextEditingController(
      text: _store!.province,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSaving = false;

    List<dynamic> localPlaces = [];
    bool localIsShow = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> _fetchLocalData(String input) async {
              try {
                if (input.trim().isEmpty) {
                  setModalState(() {
                    localPlaces = [];
                    localIsShow = false;
                  });
                  return;
                }
                final url = Uri.parse(
                  'https://rsapi.goong.io/Place/AutoComplete?location=21.013715429594125%2C%20105.79829597455202&input=$input&api_key=i9WBxoabU5xQF7ViPKwrEIp5roEEUfs0ZvxBOf7C',
                );
                var response = await http.get(url);
                setModalState(() {
                  final jsonResponse = jsonDecode(response.body);
                  localPlaces = jsonResponse['predictions'] as List<dynamic>;
                  localIsShow = true;
                });
              } catch (e) {
                // ignore
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.editLocation,
                      style: GoogleFonts.quicksand(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      AppLocalizations.of(context)!.address,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: addressController,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      onChanged: (val) {
                        _fetchLocalData(val);
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterAddressError;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    if (localIsShow && localPlaces.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 150),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: localPlaces.length,
                          itemBuilder: (context, index) {
                            final place = localPlaces[index];
                            return ListTile(
                              title: Text(
                                place['description'],
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                setModalState(() {
                                  addressController.text = place['description'];
                                  localIsShow = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),

                    Text(
                      AppLocalizations.of(context)!.provinceCity,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: provinceController,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterProvinceError;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  setModalState(() => isSaving = true);
                                  try {
                                    await inj<StoreDatasource>()
                                        .updateStoreLocation(
                                          storeId: _store!.id,
                                          address: addressController.text
                                              .trim(),
                                          province: provinceController.text
                                              .trim(),
                                        );
                                    if (mounted) {
                                      setState(() {
                                        _store = _store!.copyWith(
                                          address: addressController.text
                                              .trim(),
                                          province: provinceController.text
                                              .trim(),
                                        );
                                      });
                                    }
                                    if (mounted) Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                    setModalState(() => isSaving = false);
                                  }
                                }
                              },
                        child: isSaving
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white,
                                size: 24,
                              )
                            : Text(
                                AppLocalizations.of(context)!.save,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
