import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UnauthenticatedBody extends StatelessWidget {
  const UnauthenticatedBody({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Log in or sign up to manage your upcoming and\npast appointments',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
              onPressed: (){
                context.go('/explore');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
              ),
              child: const Text(
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
              child: const Text(
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
}
