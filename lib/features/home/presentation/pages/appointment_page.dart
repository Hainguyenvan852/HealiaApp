import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60,),
              const Text('Appointments', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26
              ),),
              const SizedBox(height: 30,),
              BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state){
                    if(state is AuthSuccess || state is AuthFacebookSignInSuccess || state is AuthGoogleSignInSuccess){
                      return Container(
                        height: 380,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 0.4
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 75,),
                            const SizedBox(height: 10,),
                            const Text('No appointments', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 10,),
                            const Text(
                              'Your upcoming and past appointments will\nappear here when you book',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            OutlinedButton(
                                onPressed: (){

                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  side: BorderSide(
                                    color: Colors.grey
                                  )
                                ),
                                child: Text(
                                  'Search salons',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: 380,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 0.4
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 75,),
                          const SizedBox(height: 10,),
                          const Text('No appointments', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),),
                          const SizedBox(height: 10,),
                          const Text(
                            'Log in or sign up to manage your upcoming and\npast appointments',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 15,),
                          ElevatedButton(
                              onPressed: (){

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white
                              ),
                              child: Text(
                                'Search salons',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                          const SizedBox(height: 8,),
                          ElevatedButton(
                              onPressed: (){
                                context.push('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black
                              ),
                              child: Text(
                                'Log in or sign up',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ],
                      ),
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
