import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void _signOut(){
    context.read<AuthBloc>().add(UserSignedOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, OAuthState>(
          listener: (context, state){
            if(state is AuthSignedOutSuccess){
              context.go('/home');
            }
          },
          builder: (context, state){
            return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        state is AuthSuccess
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.fullName,
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),
                                ),
                                Text(
                                  'Personal account',
                                  style: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                              ],
                            ),
                            state.user.avatarUrl != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                width: 60,
                                height: 60,
                                imageUrl: state.user.avatarUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url){
                                  return Shimmer(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error){
                                  return Center(child: Icon(Icons.error, color: Colors.white,));
                                },
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 60,
                                height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                child: Image.asset('assets/images/user-avatar-default.png', fit: BoxFit.cover,)
                              ),
                            )
                          ],
                        )
                        : SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer(
                                      child: Container(
                                          width: 200,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey.withValues(alpha: 0.4),
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 10,),
                                  Shimmer(
                                      child: Container(
                                          width: 140,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey.withValues(alpha: 0.4),
                                          )
                                      )
                                  ),
                                ],
                              ),
                              Shimmer(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withValues(alpha: 0.4),
                                        shape: BoxShape.circle
                                    )
                                  )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 50,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  width: 0.8
                              )
                          ),
                          child: Column(
                            children: [
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.userRectangle(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Profile',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.heart(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Favorites',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.clipboardText(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Forms',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.gearSix(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Settings',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  width: 0.8
                              )
                          ),
                          child: Column(
                            children: [
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.lifebuoy(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Support',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                              FilledButton.icon(
                                  onPressed: (){},
                                  style: FilledButton.styleFrom(
                                      padding: EdgeInsets.only(),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                  icon: PhosphorIcon(
                                    PhosphorIcons.globeHemisphereWest(),
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'English (United States)',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  width: 0.8
                              )
                          ),
                          child: FilledButton.icon(
                              onPressed: (){
                                _showLogOutBottomSheet(context);
                              },
                              style: FilledButton.styleFrom(
                                  padding: EdgeInsets.only(),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              icon: PhosphorIcon(
                                PhosphorIcons.signOut(),
                                color: Colors.black,
                                size: 25,
                              ),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Log out',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
                                ],
                              )
                          ),
                        )
                      ]
                  )
              ),
            );
          },
      )
    );
  }

  void _showLogOutBottomSheet(BuildContext context,){
    final authBloc = context.read<AuthBloc>();

     showModalBottomSheet(
        backgroundColor: Colors.white,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext sheetContext)
        => BlocProvider.value(
          value: authBloc,
          child: BlocConsumer<AuthBloc, OAuthState>(
              listener: (context, state){
                if(state is AuthSignedOutSuccess){
                  Navigator.pop(sheetContext);
                }
              },
              builder: (context, state){
                return Container(
                  height: 300,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Positioned.fill(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 70,),
                            Text('Log out?', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),),
                            const SizedBox(height: 30,),
                            RichText(
                                text: TextSpan(
                                    text: 'Are you sure you want to log out of\n',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: 'hainguyenvan852@gmail.com',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold
                                          )
                                      )
                                    ]
                                )
                            ),
                            const SizedBox(height: 60,),
                            Row(
                              spacing: 10,
                              children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: OutlinedButton(
                                        onPressed: state is AuthLoading ? null :  (){
                                          Navigator.pop(sheetContext);
                                        },
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            minimumSize: Size(double.infinity, 45),
                                            side: BorderSide(
                                                color: Colors.grey,
                                                width: 1
                                            )
                                        ),
                                        child: Text('Go back', style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),)
                                    )
                                ),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: FilledButton(
                                        onPressed: state is AuthLoading ? null : (){
                                          _signOut();
                                        },
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          minimumSize: Size(double.infinity, 45),
                                        ),
                                        child: state is AuthLoading
                                            ? Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.white, size: 30))
                                            : Text('Confirm', style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),)
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 0,
                        child: GestureDetector(
                            onTap: state is AuthLoading ? null : (){
                              Navigator.pop(sheetContext);
                            },
                            child: Icon(Icons.close_outlined)
                        ),
                      )
                    ],
                  ),
                );
              },
          ),
        )
    );
  }
}
