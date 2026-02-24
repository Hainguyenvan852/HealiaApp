import 'package:flutter/material.dart';
import 'package:healio_app/features/auth/presentation/widgets/login_textfield.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 0.5
          )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Forgot password', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 20,),
                const Text('Please enter your registration email. '
                    'We will send instructions to change your password to this email.', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 15,),
                TextFormField(
                  style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintText: 'Enter email',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        )
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.2
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -3),
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5
            )
          ]
        ),
        child: FilledButton(
            onPressed: (){

            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            child: const Text('Reset password', style: TextStyle(
              fontWeight: FontWeight.bold
            ),)
        ),
      ),
    );
  }
}
