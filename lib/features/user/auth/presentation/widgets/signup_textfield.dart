import 'package:flutter/material.dart';

class SignupTextField extends StatefulWidget {

  final String hintText;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController controller;


  const SignupTextField({super.key, required this.hintText, this.validator, required this.prefixIcon, required this.isPassword, required this.controller});

  @override
  State<SignupTextField> createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  bool _isObscure = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      cursorColor: Colors.black,
      obscureText: widget.isPassword ? _isObscure : false,
      onTapOutside: (event){
        _focusNode.unfocus();
      },
      validator: widget.validator,
      textInputAction: widget.isPassword
          ? widget.hintText.toLowerCase() == 'password' ? TextInputAction.next : TextInputAction.done
          : TextInputAction.next,
      style: TextStyle(
          fontWeight: FontWeight.w600
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword ? _isObscure
            ? IconButton(
              onPressed: (){
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(Icons.visibility)
            )
            : IconButton(
                onPressed: (){
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon: Icon(Icons.visibility_off),
            )
            : null,
        errorStyle: TextStyle(
            fontWeight: FontWeight.bold
        ),
        hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w600
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: Colors.transparent
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: Colors.transparent
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: Colors.transparent
            )
        ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: Colors.transparent
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: Colors.transparent
            )
        ),
      ),
    );
  }
}
