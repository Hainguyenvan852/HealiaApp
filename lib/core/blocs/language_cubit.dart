import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/core/services/user_setting_service.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('vi'));

  void loadLanguage(String languageCode) async{
    emit(Locale(languageCode));
  }

  void changeLanguage(String languageCode) async{
    await UserSettingService.saveLanguageSetting(languageCode);
    emit(Locale(languageCode));
  }
}