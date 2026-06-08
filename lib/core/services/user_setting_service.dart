import 'package:shared_preferences/shared_preferences.dart';

class UserSettingService {
  static final String _languageKey = "language";

  static Future<String?> getLanguageSetting() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = prefs.getString(_languageKey);
    return response;
  }

  static Future<void> saveLanguageSetting(String language) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_languageKey, language);
  }
}