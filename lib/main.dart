import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healio_app/app.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/services/user_setting_service.dart';
import 'package:healio_app/core/utils/bloc_observer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Đã nhận thông báo khi đang tắt app: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: '.env'); // Đọc dữ liệu từ file .env
  await initDependencies(); // Tiêm các dependency
  Bloc.observer = AppBlocObserver(); // Đăng ký lắng nghe sự kiện của bloc hiển thị lên log

  final response = await UserSettingService.getLanguageSetting(); 
  if(response == null){
    await UserSettingService.saveLanguageSetting('en');
  }
  final savedLanguage = response ?? 'en';

  // Cấu hình cho phép giao diện chiếm toàn bộ màn hình
  const uiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,

    systemNavigationBarContrastEnforced: false,

    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  );

  runApp(AnnotatedRegion<SystemUiOverlayStyle>( // Áp dụng style này lên toàn giao diện
      value: uiStyle,
      child: App(initialLanguage: savedLanguage,)
  ));
}




