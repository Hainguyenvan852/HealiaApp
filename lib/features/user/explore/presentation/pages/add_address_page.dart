import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/profile/data/models/address_model.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../core/injector/dependency_injector.dart';
import '../widgets/search_text_field_1.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({
    super.key,
    required this.address,
    required this.isUpdate,
  });
  final AddressModel address;
  final bool isUpdate;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _provinceController = TextEditingController();
  final _communeController = TextEditingController();
  final _districtController = TextEditingController();
  late bool _canSubmit;
  late final User? user;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.address.address;
    _provinceController.text = widget.address.province;
    _communeController.text = widget.address.commune ?? '';
    _districtController.text = widget.address.district ?? '';
    _nameController.text = widget.address.name;

    _canSubmit =
        _addressController.text.isNotEmpty &&
        _provinceController.text.isNotEmpty &&
        _nameController.text.isNotEmpty;
    user = inj<CheckCurrentUserUseCase>().call();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _provinceController.dispose();
    _communeController.dispose();
    _districtController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAddressBloc, UserAddressState>(
      builder: (context, state) {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.addAddress,
                      style: GoogleFonts.quicksand(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.addressName,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SearchTextField1(
                      controller: _nameController,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.mapPin(),
                        size: 21,
                      ),
                      isReadOnly: widget.address.name.toLowerCase() != 'custom'
                          ? true
                          : false,
                      isAutoFocus: false,
                      isNext: true,
                      onChanged: (value) {
                        setState(() {
                          _canSubmit =
                              _addressController.text.isNotEmpty &&
                              _provinceController.text.isNotEmpty &&
                              _nameController.text.isNotEmpty;
                        });
                      },
                    ),

                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SearchTextField1(
                      controller: _addressController,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.mapPin(),
                        size: 21,
                      ),
                      isReadOnly: false,
                      isAutoFocus: false,
                      isNext: true,
                      onChanged: (value) {
                        setState(() {
                          _canSubmit =
                              _addressController.text.isNotEmpty &&
                              _provinceController.text.isNotEmpty;
                        });
                      },
                    ),

                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.commune,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SearchTextField1(
                      controller: _communeController,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.mapPin(),
                        size: 21,
                      ),
                      isReadOnly: false,
                      isAutoFocus: false,
                      isNext: true,
                    ),
                    const SizedBox(height: 30),

                    Text(
                      AppLocalizations.of(context)!.district,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SearchTextField1(
                      controller: _districtController,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.mapPin(),
                        size: 21,
                      ),
                      isReadOnly: false,
                      isAutoFocus: false,
                      isNext: true,
                    ),
                    const SizedBox(height: 30),

                    Text(
                      AppLocalizations.of(context)!.province,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SearchTextField1(
                      controller: _provinceController,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.mapPin(),
                        size: 21,
                      ),
                      isReadOnly: false,
                      isAutoFocus: false,
                      onChanged: (value) {
                        setState(() {
                          _canSubmit =
                              _addressController.text.isNotEmpty &&
                              _provinceController.text.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15,
              ),
              child: FilledButton(
                onPressed: state.isLoading
                    ? null
                    : (_canSubmit
                          ? () async {
                              if (widget.isUpdate) {
                                context.read<UserAddressBloc>().add(
                                  UpdateUserAddress(
                                    userId: user!.id,
                                    address: AddressModel(
                                      id: widget.address.id,
                                      name: _nameController.text.trim(),
                                      address: _addressController.text.trim(),
                                      province: _provinceController.text.trim(),
                                      lat: widget.address.lat,
                                      lng: widget.address.lng,
                                      district: _districtController.text.trim(),
                                      commune: _communeController.text.trim(),
                                    ),
                                  ),
                                );
                                await Future.delayed(Duration(seconds: 2));
                                SnackBarHelper.showSuccess(
                                  AppLocalizations.of(
                                    context,
                                  )!.updateAddressSuccess,
                                );
                                Navigator.pop(context);
                              } else {
                                final saveAddress = AddressModel(
                                  id: 0,
                                  name: _nameController.text.trim(),
                                  address: _addressController.text.trim(),
                                  province: _provinceController.text.trim(),
                                  lat: widget.address.lat,
                                  lng: widget.address.lng,
                                  commune: _communeController.text.trim(),
                                  district: _districtController.text.trim(),
                                );
                                context.read<UserAddressBloc>().add(
                                  AddUserAddress(
                                    userId: user!.id,
                                    address: saveAddress,
                                  ),
                                );
                                await Future.delayed(Duration(seconds: 1));
                                SnackBarHelper.showSuccess(
                                  AppLocalizations.of(
                                    context,
                                  )!.addAddressSuccess,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }
                          : null),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  maximumSize: Size(double.infinity, 50),
                ),
                child: state.isLoading
                    ? Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.save,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
