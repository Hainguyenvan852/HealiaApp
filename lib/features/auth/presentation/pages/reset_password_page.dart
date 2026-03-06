import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/core/validators/text_field_validation.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../widgets/custom_textfield.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submitRequest(){
    if(_formKey.currentState!.validate()){
      context.read<AuthBloc>().add(UpdatePasswordRequested(newPassword: _newPasswordCtrl.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, OAuthState>(
        listener: (context, state){
          if(state is AuthError){
            SnackBarHelper.showError(state.errorMsg);
          }
          if(state is UpdatePasswordSuccess){
            SnackBarHelper.showSuccess('Your password has been reset successfully. Please log in');
            context.go('/home');
          }
        },
        builder: (context, state){
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(onPressed: (){
                context.read<AuthBloc>().add(AuthReset());
                context.go('/home');
              }, icon: Icon(Icons.arrow_back_rounded, size: 25, )),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change password',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 28
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text(
                        'Please enter a new password for',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black45
                        ),
                      ),
                      Text(
                        'hainguyenvan852@gmail.com',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 25,),
                      Text(
                        'Enter new password *',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      CustomTextField(
                        isPassword: true,
                        controller: _newPasswordCtrl,
                        isFinalField: false,
                        validator: emptyPasswordValidation,
                      ),
                      const SizedBox(height: 25,),
                      Text(
                        'Confirm new password *',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      CustomTextField(
                        isPassword: true,
                        controller: _confirmPasswordCtrl,
                        isFinalField: true,
                        validator: (value) => confirmPasswordValidation(value, _newPasswordCtrl),
                      ),
                      const SizedBox(height: 30,),
                      FilledButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () => _submitRequest(),
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(double.infinity, 50)
                          ),
                          child: state is AuthLoading
                            ? Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.white, size: 30))
                            : Text(
                              'Submit',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                      ),
                      const SizedBox(height: 25,),
                      RichText(
                          text: TextSpan(
                              text: 'If you forgot your password, ',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4
                              ),
                              children: [
                                TextSpan(
                                    text: 'you can reset by clicking on this link',
                                    style: TextStyle(
                                        color: Color(0xFF6236FF)
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = (){

                                    }
                                )
                              ]
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}
