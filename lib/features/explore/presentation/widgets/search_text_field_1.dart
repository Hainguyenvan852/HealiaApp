import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextField1 extends StatefulWidget {
  const SearchTextField1({super.key, required this.controller, required this.prefixIcon, this.onTap, required this.isReadOnly, required this.isAutoFocus, this.suffixIcon, this.onChanged,});
  final TextEditingController controller;
  final bool isReadOnly;
  final bool isAutoFocus;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final void Function(String value)? onChanged;
  final void Function()? onTap;

  @override
  State<SearchTextField1> createState() => _SearchTextField1State();
}

class _SearchTextField1State extends State<SearchTextField1> {

  final FocusNode _focusNode = FocusNode();
  bool showClearButton = false;

  void onChanged(String value){
    if(widget.controller.text.isNotEmpty & !showClearButton){
      setState(() {
        showClearButton = true;
      });
    } else if(widget.controller.text.isEmpty & showClearButton){
      setState(() {
        showClearButton = false;
      });
    }

    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
        cursorColor: Colors.black,
        focusNode: _focusNode,
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        onTap: widget.onTap,
        onChanged: (value) => onChanged(value),
        readOnly: widget.isReadOnly,
        autofocus: widget.isAutoFocus,
        decoration: InputDecoration(
          hintText: "",
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 10),
            child: widget.prefixIcon,
          ),
          suffixIcon: widget.suffixIcon != null
              ? (showClearButton
                  ? GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        setState(() {
                          showClearButton = false;
                        });
                      },
                      child: widget.suffixIcon
                  )
                  : null)
              : null,
          errorStyle: GoogleFonts.quicksand(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.6),
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.6),
                  width: 1.2
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                  width: 1.2
              ),
              borderRadius: BorderRadius.circular(8)
          ),
        )
    );
  }
}
