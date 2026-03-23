import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticatedBody extends StatelessWidget {
  const AuthenticatedBody({super.key});

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
            'Your upcoming and past appointments will\nappear here when you book',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 15,),
          OutlinedButton(
              onPressed: (){
                context.go('/explore');
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(
                      color: Colors.grey
                  )
              ),
              child: const Text(
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
}
