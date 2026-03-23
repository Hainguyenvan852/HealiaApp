import 'package:flutter/cupertino.dart';

class ProfileButtonModel {
  final String title;
  final Icon icon;
  final VoidCallback onPress;

  ProfileButtonModel(this.title, this.icon, this.onPress);
}