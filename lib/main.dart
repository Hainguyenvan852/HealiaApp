import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healio_app/app.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/bloc_observer.dart';

void main() async{
  await dotenv.load(fileName: '.env'); // Đọc dữ liệu từ file .env
  await initDependencies(); // Tiêm các dependency
  Bloc.observer = AppBlocObserver(); // Đăng ký lắng nghe sự kiện của bloc hiển thị lên log

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
      child: App()
  ));
}




