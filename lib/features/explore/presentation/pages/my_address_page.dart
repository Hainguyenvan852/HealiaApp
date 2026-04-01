import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/explore/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/explore/presentation/widgets/address_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/injector/dependency_injector.dart';
import 'add_my_address_page.dart';


class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  late final User? user;

  @override
  void initState() {
    super.initState();
    user = inj<CheckCurrentUserUseCase>().call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25,)
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocConsumer<UserAddressBloc, UserAddressState>(
              listener: (context, state){
                if(state.error != null){
                  SnackBarHelper.showError(state.error.toString());
                  context.read<UserAddressBloc>().add(ClearError());
                }
              },
              builder: (context, state){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My addresses',
                      style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    const SizedBox(height: 35,),
                    state.homeAddress != null
                    ? AddressCard(
                        iconData: PhosphorIcons.house(PhosphorIconsStyle.fill),
                        title: 'Home',
                        content: state.homeAddress!.address,
                        iconColor: Colors.black54,
                        iconBackgroundColor: Colors.grey.withValues(alpha: 0.15),
                        menuButton: GestureDetector(
                          onTap: () => BottomSheetHelper.showSettingAddressBottomSheet(context, context.read<UserAddressBloc>(), state.homeAddress!, user!.id),
                          child: PhosphorIcon(PhosphorIcons.dotsThreeVertical(), size: 30,),
                        ),
                        onTap: (){},
                    )
                    : AddressCard(
                        iconData: PhosphorIcons.house(PhosphorIconsStyle.fill),
                        title: 'Home',
                        content: 'Add address',
                        iconColor: Colors.black54,
                        iconBackgroundColor: Colors.grey.withValues(alpha: 0.15),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<UserAddressBloc>(), child: AddMyAddressPage(addressName: 'Home'),))),
                    ),

                    const SizedBox(height: 15,),
                    state.workAddress != null
                    ? AddressCard(
                        iconData: PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
                        title: 'Work',
                        iconColor: Colors.black54,
                        iconBackgroundColor: Colors.grey.withValues(alpha: 0.15),
                        content: state.workAddress!.address,
                        menuButton: GestureDetector(
                          onTap: () => BottomSheetHelper.showSettingAddressBottomSheet(context, context.read<UserAddressBloc>(), state.workAddress!, user!.id),
                          child: PhosphorIcon(PhosphorIcons.dotsThreeVertical(), size: 30,),
                        ),
                        onTap: (){},
                    )
                    : AddressCard(
                        iconData: PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
                        title: 'Work',
                        iconColor: Colors.black54,
                        iconBackgroundColor: Colors.grey.withValues(alpha: 0.15),
                        content: 'Add address',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<UserAddressBloc>(), child: AddMyAddressPage(addressName: 'Work'),))),
                    ),

                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<UserAddressBloc>(), child: AddMyAddressPage(addressName: 'Custom'),))),
                      child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10,
                            children: [
                              Icon(Icons.add_circle_outline_rounded, size: 20,),
                              Text(
                                'Add',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          )
                      ),
                    )
                  ],
                );
              },
            )
          ),
        )
    );
  }
}
