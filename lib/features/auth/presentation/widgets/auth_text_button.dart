import 'package:flutter/material.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({super.key, required this.onTap, required this.title, required this.content});
  final String title;
  final String content;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          content,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(width: 5,),
        GestureDetector(
          onTap: onTap,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
