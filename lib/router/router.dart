import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/notifier/go_router_refresh_notifier.dart';
import 'package:healio_app/core/services/auth_gate.dart';
import 'package:healio_app/features/auth/presentation/pages/auth_callback_handle_page.dart';
import 'package:healio_app/features/auth/presentation/pages/login_page.dart';
import 'package:healio_app/features/auth/presentation/pages/signup_page.dart';
import 'package:healio_app/features/landing/app_retry.dart';
import 'package:healio_app/features/landing/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter{
  late final GoRouter route;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouter(){
    route = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshNotifier(
        Supabase.instance.client.auth.onAuthStateChange
      ),
      routes: [
        GoRoute(
          path: '/',
          name: 'retry',
          builder: (context, state) => const AppRetryPoint()
        ),
        GoRoute(
            path: '/landing',
            name: 'landing',
            builder: (context, state) => const LandingPage()
        ),
        GoRoute(
            path: '/auth-gate',
            name: 'auth-gate',
            builder: (context, state) => const AuthGate()
        ),
        GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginPage()
        ),
        GoRoute(
            path: '/signup',
            name: 'signup',
            builder: (context, state) => const SignupPage()
        ),
        GoRoute(
            path: '/verify-email',
            name: 'verify-email',
            builder: (context, state) => const SizedBox()
        ),
        GoRoute(
            path: '/forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const SizedBox()
        ),
        GoRoute(
            path: '/reset-password',
            name: 'reset-password',
            builder: (context, state) => const SizedBox()
        ),
        GoRoute(
            path: '/auth-callback',
            name: 'auth-callback',
            builder: (context, state) => const AuthCallbackHandlePage()
        )
      ]
    );


  }
}