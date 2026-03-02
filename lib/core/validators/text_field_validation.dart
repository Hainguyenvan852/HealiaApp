import 'package:flutter/material.dart';

String? emailValidation(String? email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (email == null || email.isEmpty) {
    return 'Email is required';
  }

  if (!emailRegex.hasMatch(email)) {
    return 'Please provide a valid email address';
  }
  return null;
}

String? emptyPasswordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  return null;
}

String? emptyValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field is required';
  }

  return null;
}

String? intValidation(String? value) {
  final numRegex = RegExp(r'^\d+$');
  if (value == null || value.isEmpty) {
    return 'Field is required!';
  }
  if (!numRegex.hasMatch(value)) {
    return 'Value should be [0-9] only';
  }

  return null;
}

String? doubleValidation(String? value) {
  final numRegex = RegExp(r'^\d+(\.\d{1,})?$');
  if (value == null || value.trim().isEmpty) {
    return 'Field is required!';
  }
  if (!numRegex.hasMatch(value.trim())) {
    return 'Invalid number format';
  }
  return null;
}

String? confirmPasswordValidation(
    String? value,
    TextEditingController controller,
    ) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (controller.text.toString() != value) {
    return 'Password is not matched';
  }
  return null;
}