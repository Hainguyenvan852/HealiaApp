import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/profile/data/models/address_model.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_address_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../features/user/auth/presentation/bloc/auth_bloc.dart';
import '../../features/user/explore/presentation/pages/add_address_page.dart';
import '../../l10n/app_localizations.dart';

class BottomSheetHelper {
  static void showLogOutBottomSheet(
    BuildContext context,
    AuthBloc authBloc,
    VoidCallback signOut,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      context: context,
      builder: (BuildContext sheetContext) => BlocProvider.value(
        value: authBloc,
        child: BlocConsumer<AuthBloc, OAuthState>(
          listener: (context, state) {
            if (state is AuthSignedOutSuccess) {
              Navigator.canPop(sheetContext);
            }
          },
          builder: (context, state) {
            return Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        Text(
                          AppLocalizations.of(context)!.logout + '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppLocalizations.of(context)!.logoutMessage,
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 60),
                        Row(
                          spacing: 10,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: OutlinedButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        Navigator.canPop(sheetContext);
                                      },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 45),
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.back,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: FilledButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        Navigator.pop(sheetContext);
                                        signOut();
                                      },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  minimumSize: Size(double.infinity, 45),
                                ),
                                child: state is AuthLoading
                                    ? Center(
                                        child:
                                            LoadingAnimationWidget.progressiveDots(
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                  Positioned(
                    top: 30,
                    right: 0,
                    child: GestureDetector(
                      onTap: state is AuthLoading
                          ? null
                          : () {
                              Navigator.pop(sheetContext);
                            },
                      child: Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static void showSettingAddressBottomSheet(
    BuildContext context,
    UserAddressBloc bloc,
    AddressModel address,
    String userId,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      context: context,
      builder: (BuildContext sheetContext) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<UserAddressBloc, UserAddressState>(
          builder: (context, state) {
            return Container(
              height: 180,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(sheetContext);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: AddAddressPage(
                                    address: address,
                                    isUpdate: true,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'Edit',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(sheetContext);
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 40,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Are you sure you want to delete this address?',
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
                                                'No',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            flex: 3,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<UserAddressBloc>()
                                                    .add(
                                                      DeleteUserAddress(
                                                        addressId: address.id,
                                                        userId: userId,
                                                      ),
                                                    );
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Yes',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
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
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.transparent,
                            height: 40,
                            width: double.infinity,
                            child: Text(
                              'Delete',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 0,
                    child: GestureDetector(
                      onTap: state is AuthLoading
                          ? null
                          : () {
                              Navigator.pop(sheetContext);
                            },
                      child: Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<void> showExitConfirmationBottomSheet({
    required BuildContext context,
    required VoidCallback onExit,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: PhosphorIcon(PhosphorIcons.x(), size: 28),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Are you sure you want to\nleave this booking?',
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'All selections will be lost',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop();
                            onExit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Yes, exit',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
