import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/appointment/presentation/widgets/authenticated_body.dart';
import 'package:healio_app/features/appointment/presentation/widgets/unauthenticated_body.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key,});

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
              Text('Appointments', style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 26
              ),),
              const SizedBox(height: 30,),
              BlocBuilder<AuthBloc, OAuthState>(
                  builder: (context, state){
                    if(state is AuthInitial){
                      return SizedBox(
                        height: 380,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      );
                    }
                    if(state is AuthSuccess){
                      return const AuthenticatedBody();
                    }
                    return const UnauthenticatedBody();
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
