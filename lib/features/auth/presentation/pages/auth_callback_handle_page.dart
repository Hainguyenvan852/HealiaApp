import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/landing/splash_screen.dart';

class AuthCallbackHandlePage extends StatefulWidget { //kiểm tra xem App được mở lên bởi đường link nào không
  const AuthCallbackHandlePage({super.key});

  @override
  State<AuthCallbackHandlePage> createState() => _AuthCallbackHandlePageState();
}

class _AuthCallbackHandlePageState extends State<AuthCallbackHandlePage> {

  @override
  void initState() {
    super.initState();
    _handleDeepLink();

    // Xử lý khi app đang chạy ngầm
    AppLinks().uriLinkStream.listen((uri) {
      final type = uri.queryParameters['type'];
      if (type == 'recovery') {
        context.go('/reset-password');
      } else {
        context.go('/home');
      }
    });
  }

  Future<void> _handleDeepLink() async{
    final uri = await AppLinks().getInitialLink();

    final type  = uri?.queryParameters['type'];

    if(uri == null){
      context.go('/home');
    } else{
      if(type == 'recovery'){
        context.go('/reset-password');
      } else{
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
