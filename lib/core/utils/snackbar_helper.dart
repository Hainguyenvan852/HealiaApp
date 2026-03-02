import 'package:flutter/material.dart';

class SnackBarHelper {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showError(String errorMessage) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      backgroundColor: const Color(0xFFC91A3E), // Màu đỏ lỗi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Tắt SnackBar thông qua GlobalKey
              messengerKey.currentState?.hideCurrentSnackBar();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    // Xóa SnackBar cũ và hiện cái mới thông qua GlobalKey
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccess(String errorMessage) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      backgroundColor: const Color(0xFF32E816),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              messengerKey.currentState?.hideCurrentSnackBar();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    // Xóa SnackBar cũ và hiện cái mới thông qua GlobalKey
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}