import 'package:flutter/cupertino.dart';

class ScreenHelper {
  static Size getScreenSize(BuildContext context){
    return MediaQuery.of(context).size;
  }
}