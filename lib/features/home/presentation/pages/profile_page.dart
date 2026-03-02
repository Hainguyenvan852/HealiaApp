import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


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
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state){
            if(state is AuthSignedOutSuccess){
              context.go('/home');
            }
          },
          builder: (context, state){
            return Center(
              child: ElevatedButton(
                  onPressed: (){
                    _showLogOutBottomSheet(context);
                  },
                  child: Text('Sign out')
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
          child: BlocConsumer<AuthBloc, AuthState>(
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
