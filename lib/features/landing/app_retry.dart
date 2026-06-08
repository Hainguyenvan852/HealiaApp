import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/injector/dependency_injector.dart';
import '../user/auth/domain/usecases/check_user_session_usecase.dart';
import '../user/profile/data/models/user_model.dart';
import '../user/profile/domain/usecases/get_user_info_usecase.dart';
import 'no_internet_page.dart';

class AppRetryPoint extends StatefulWidget {
  const AppRetryPoint({super.key});

  @override
  State<AppRetryPoint> createState() => _AppRetryPointState();
}

class _AppRetryPointState extends State<AppRetryPoint> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await prefs.setBool('isFirstLaunch', false);
        if (mounted) context.go('/landing');
        return;
      }

      final session = inj<CheckUserSessionUseCase>().call();

      if (session != null) {
        UserModel userInfo = await inj<GetUserInfoUseCase>().call(
          session.user.id,
        );

        if (!mounted) return;

        if (userInfo.role == 'manager') {
          if (userInfo.verifyStore != null && userInfo.verifyStore!) {
            context.go('/manager-navigator', extra: userInfo);
          } else {
            context.go('/incomplete-registration');
          }
        } else {
          context.go('/home');
        }
      } else {
        if (mounted) context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _hasError
          ? NoInternetPage(
              onTryAgain: () {
                _initializeApp();
              },
            )
          : Center(
              child: Image.asset(
                'assets/images/logo-healio-app.png',
                width: 200,
              ),
            ),
    );
  }
}
