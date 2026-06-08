import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key, required this.isPassword, required this.controller, required this.isFinalField, this.validator});
  final bool isPassword;
  final TextEditingController controller;
  final bool isFinalField;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isObscured = true;
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
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),
        cursorColor: Colors.black,
        focusNode: _focusNode,
        obscureText: isObscured,
        textInputAction: widget.isFinalField ? TextInputAction.done : TextInputAction.next,
        validator: widget.validator,
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          errorStyle: GoogleFonts.quicksand(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),
          suffixIcon: widget.isPassword
            ? isObscured
                ? GestureDetector(
                    child: Icon(Icons.visibility_outlined, size: 25,),
                    onTap: (){
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                )
                : GestureDetector(
                  child: Icon(Icons.visibility_off_outlined, size: 25,),
                  onTap: (){
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                )
            : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                  color: Colors.deepPurpleAccent,
                  width: 1.2
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
        )
    );
  }
}
