import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/notifier/go_router_refresh_notifier.dart';
import 'package:healio_app/core/services/auth_gate.dart';
import 'package:healio_app/features/auth/presentation/pages/auth_callback_handle_page.dart';
import 'package:healio_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:healio_app/features/auth/presentation/pages/login_page.dart';
import 'package:healio_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:healio_app/features/auth/presentation/pages/signup_page.dart';
import 'package:healio_app/features/auth/presentation/pages/verification_page.dart';
import 'package:healio_app/features/appointment/presentation/pages/appointment_page.dart';
import 'package:healio_app/features/explore/presentation/pages/category_search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/explore_page.dart';
import 'package:healio_app/features/home/presentation/pages/home_page.dart';
import 'package:healio_app/features/auth/presentation/pages/main_page.dart';
import 'package:healio_app/features/explore/presentation/pages/location_search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/manage_address_page.dart';
import 'package:healio_app/features/explore/presentation/pages/search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/time_search_page.dart';
import 'package:healio_app/features/profile/presentation/pages/profile_page.dart';
import 'package:healio_app/features/landing/app_retry.dart';
import 'package:healio_app/features/landing/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter{
  late final GoRouter route;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'explore');
  static final shellNavigatorAppointmentKey = GlobalKey<NavigatorState>(debugLabel: 'appointment');
  static final shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  AppRouter(){
    route = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/',
        // refreshListenable: GoRouterRefreshNotifier(
        //     Supabase.instance.client.auth.onAuthStateChange
        // ),
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
            path: '/login',
            name: 'login',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const LoginPage(),
                transitionDuration: const Duration(milliseconds: 180),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                  return FadeTransition(
                    opacity: CurveTween(
                      curve: Curves.easeInOut,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
              path: '/signup',
              name: 'signup',
              builder: (context, state) => const SignupPage()
          ),
          GoRoute(
              path: '/verify-email/:email',
              name: 'verify-email',
              builder: (context, state) => VerificationPage(email: state.pathParameters['email'] ?? 'error',)
          ),
          GoRoute(
              path: '/forgot-password',
              name: 'forgot-password',
              builder: (context, state) => const ForgotPasswordPage()
          ),
          GoRoute(
              path: '/reset-password',
              name: 'reset-password',
              builder: (context, state) => const ResetPasswordPage()
          ),
          // GoRoute(
          //     path: '/auth-callback',
          //     name: 'auth-callback',
          //     builder: (context, state) => const AuthCallbackHandlePage()
          // ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainPage(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                navigatorKey: shellNavigatorHomeKey,
                routes: [
                  GoRoute(
                    path: '/home',
                    builder: (context, state) => const HomePage(),
                    routes: []
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: shellNavigatorExploreKey,
                routes: [
                  GoRoute(
                    path: '/explore',
                    builder: (context, state) => const ExplorePage(),
                    routes: [
                      GoRoute(
                        path: 'search', // route con không có dấu '/' ở đầu
                        parentNavigatorKey: rootNavigatorKey, // Dòng này giúp che BottomBar
                        pageBuilder: (BuildContext context, GoRouterState state) {
                            return CustomTransitionPage<void>(
                              key: state.pageKey,
                              child: const SearchPage(),
                              transitionDuration: const Duration(milliseconds: 180),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                return FadeTransition(
                                  opacity: CurveTween(
                                    curve: Curves.easeInOut,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            );
                        },
                        routes: [
                          GoRoute(
                            path: 'category-search',
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (BuildContext context, GoRouterState state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const CategorySearchPage(),
                                transitionDuration: const Duration(milliseconds: 180),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                  return FadeTransition(
                                    opacity: CurveTween(
                                      curve: Curves.easeInOut,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                          ),
                          GoRoute(
                            path: 'location-search',
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (BuildContext context, GoRouterState state) {
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: const LocationSearchPage(),
                                transitionDuration: const Duration(milliseconds: 180),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                  return FadeTransition(
                                    opacity: CurveTween(
                                      curve: Curves.easeInOut,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                          ),
                          GoRoute(
                            path: 'time-search',
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (BuildContext context, GoRouterState state) {
                              final data = state.extra as Map<String, dynamic>;
                              return CustomTransitionPage<void>(
                                key: state.pageKey,
                                child: TimeSearchPage(date: data['date'], startTime: data['startTime'], endTime: data['endTime'], timeText: data['timeText'], dateText: data['dateText'],),
                                transitionDuration: const Duration(milliseconds: 180),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                  return FadeTransition(
                                    opacity: CurveTween(
                                      curve: Curves.easeInOut,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              );
                            },
                          ),
                        ]
                      ),
                    ]
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: shellNavigatorAppointmentKey,
                routes: [
                  GoRoute(
                    path: '/appointment',
                    builder: (context, state) => const AppointmentPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: shellNavigatorProfileKey,
                routes: [
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfilePage(),
                  ),
                ],
              ),
            ],
          ),
        ]
    );
  }
}
