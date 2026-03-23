import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/features/profile/data/models/profile_button_model.dart';
import 'package:healio_app/features/profile/presentation/widgets/button_card.dart';
import 'package:healio_app/features/profile/presentation/widgets/header_shimmer.dart';
import 'package:healio_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void _signOut(){
    context.read<AuthBloc>().add(UserSignedOutRequested());
  }

  late final buttonList1;

  late final buttonList2;

  late final buttonList3;

  @override
  void initState() {
    super.initState();
    buttonList1 = [
      ProfileButtonModel(
          'Profile',
          PhosphorIcon(
            PhosphorIcons.userRectangle(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
      ProfileButtonModel(
          'Favorites',
          PhosphorIcon(
            PhosphorIcons.heart(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
      ProfileButtonModel(
          'Forms',
          PhosphorIcon(
            PhosphorIcons.clipboardText(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
      ProfileButtonModel(
          'Settings',
          PhosphorIcon(
            PhosphorIcons.gearSix(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
    ];
    buttonList2 = [
      ProfileButtonModel(
          'Support',
          PhosphorIcon(
            PhosphorIcons.lifebuoy(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
      ProfileButtonModel(
          'English (United States)',
          PhosphorIcon(
            PhosphorIcons.globeHemisphereWest(),
            color: Colors.black,
            size: 25,
          ),
              (){}
      ),
    ];
    buttonList3 = [
      ProfileButtonModel(
          'Log out',
          PhosphorIcon(
            PhosphorIcons.signOut(),
            color: Colors.black,
            size: 25,
          ),
          () => BottomSheetHelper.showLogOutBottomSheet(context, context.read<AuthBloc>(), () => _signOut())
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, OAuthState>(
          // listener: (context, state){
          //   if(state is AuthSignedOutSuccess){
          //     context.go('/home');
          //   }
          // },
          builder: (context, state){
            return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        state is AuthSuccess
                        ? ProfileHeader(state: state,)
                        : const HeaderShimmer(),
                        const SizedBox(height: 50,),
                        ButtonCard(buttonList: buttonList1),
                        const SizedBox(height: 20,),
                        ButtonCard(buttonList: buttonList2),
                        const SizedBox(height: 20,),
                        ButtonCard(buttonList: buttonList3),
                        const SizedBox(height: 20,),
                      ]
                  )
              ),
            );
          },
      )
    );
  }

}
