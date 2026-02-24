import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final String? title;
  final String hint;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const LoginTextField({super.key, this.title, required this.hint, required this.isPassword, this.prefixIcon, this.validator, this.suffixIcon});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {

  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? Text(widget.title!, style: TextStyle(fontWeight: FontWeight.w600),)
            : SizedBox.shrink(),
        const SizedBox(height: 10,),
        TextFormField(
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
          obscureText: _obscureText,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              hintText: widget.hint,
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () => _toggleVisibility(),
                      icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                  )
                  : widget.suffixIcon,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
