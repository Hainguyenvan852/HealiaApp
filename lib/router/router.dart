import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/features/auth/data/models/user_model.dart';
import 'package:healio_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:healio_app/features/auth/presentation/pages/login_page.dart';
import 'package:healio_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:healio_app/features/auth/presentation/pages/signup_page.dart';
import 'package:healio_app/features/auth/presentation/pages/verification_page.dart';
import 'package:healio_app/features/appointment/presentation/pages/appointment_page.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/presentation/pages/category_search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/explore_page.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';
import 'package:healio_app/features/home/data/models/review_model.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';
import 'package:healio_app/features/home/presentation/pages/confirm_booking_page.dart';
import 'package:healio_app/features/home/presentation/pages/home_page.dart';
import 'package:healio_app/features/auth/presentation/pages/main_page.dart';
import 'package:healio_app/features/explore/presentation/pages/location_search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/search_page.dart';
import 'package:healio_app/features/explore/presentation/pages/time_search_page.dart';
import 'package:healio_app/features/home/presentation/pages/reviews_page.dart';
import 'package:healio_app/features/home/presentation/pages/select_professional_page.dart';
import 'package:healio_app/features/home/presentation/pages/select_time_page.dart';
import 'package:healio_app/features/home/presentation/pages/service_page.dart';
import 'package:healio_app/features/home/presentation/pages/store_detail_page.dart';
import 'package:healio_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:healio_app/features/profile/presentation/pages/my_profile_page.dart';
import 'package:healio_app/features/profile/presentation/pages/personal_setting_page.dart';
import 'package:healio_app/features/landing/app_retry.dart';
import 'package:healio_app/features/landing/landing_page.dart';

class AppRouter {
  late final GoRouter route;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorHomeKey = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final shellNavigatorExploreKey = GlobalKey<NavigatorState>(
    debugLabel: 'explore',
  );
  static final shellNavigatorAppointmentKey = GlobalKey<NavigatorState>(
    debugLabel: 'appointment',
  );
  static final shellNavigatorProfileKey = GlobalKey<NavigatorState>(
    debugLabel: 'profile',
  );

  AppRouter() {
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
          builder: (context, state) => const AppRetryPoint(),
        ),
        GoRoute(
          path: '/landing',
          name: 'landing',
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginPage(),
              transitionDuration: const Duration(milliseconds: 180),
              transitionsBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
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
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/verify-email/:email',
          name: 'verify-email',
          builder: (context, state) =>
              VerificationPage(email: state.pathParameters['email'] ?? 'error'),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/reset-password',
          name: 'reset-password',
          builder: (context, state) => const ResetPasswordPage(),
        ),
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
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      path: 'store-detail',
                      builder: (context, state) => const StoreDetailPage(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          path: 'select-service',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data = state.extra as List<CategoryModel>;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: ServicesScreen(categories: data),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                            curve: Curves.easeInOut,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                );
                              },
                          routes: [],
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          path: 'select-datetime',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data =
                                    state.extra as Map<String, dynamic>?;

                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: data != null
                                      ? SelectTimePage(
                                          professionals: data['professionals'],
                                          selectedProfessional:
                                              data['selected'],
                                        )
                                      : SelectTimePage(),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                            curve: Curves.easeInOut,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                );
                              },
                          routes: [],
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          path: 'select-professional',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data =
                                    state.extra as List<TeamMemberModel>;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: SelectProfessionalPage(
                                    professionals: data,
                                  ),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                            curve: Curves.easeInOut,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                );
                              },
                          routes: [],
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          path: 'review-confirm',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: ConfirmBookingPage(),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                            curve: Curves.easeInOut,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                );
                              },
                          routes: [],
                        ),
                        GoRoute(
                          parentNavigatorKey: rootNavigatorKey,
                          path: 'all-reviews',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data =
                                    state.extra as Map<String, dynamic>;
                                final allReviews =
                                    data['all-reviews'] as List<ReviewModel>;
                                final store = data['store'] as StoreModel;

                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: ReviewsScreen(
                                    allReviews: allReviews,
                                    store: store,
                                  ),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurveTween(
                                            curve: Curves.easeInOut,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                );
                              },
                          routes: [],
                        ),
                      ],
                    ),
                  ],
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
                      parentNavigatorKey: rootNavigatorKey,
                      path: 'store-detail',
                      builder: (context, state) => const HomePage(),
                      routes: [
                      
                      ]
                    ),
                    GoRoute(
                      path: 'search', // route con không có dấu '/' ở đầu
                      parentNavigatorKey:
                          rootNavigatorKey, // Dòng này giúp che BottomBar
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: const SearchPage(),
                          transitionDuration: const Duration(milliseconds: 180),
                          transitionsBuilder:
                              (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) {
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
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: const CategorySearchPage(),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
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
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: const LocationSearchPage(),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
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
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data =
                                    state.extra as Map<String, dynamic>;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: TimeSearchPage(
                                    date: data['date'],
                                    startTime: data['startTime'],
                                    endTime: data['endTime'],
                                    timeText: data['timeText'],
                                    dateText: data['dateText'],
                                  ),
                                  transitionDuration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
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
                      ],
                    ),
                  ],
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
                  path: '/personal-setting',
                  builder: (context, state) => const PersonalSettingPage(),
                  routes: [
                    GoRoute(
                      path: 'my-profile',
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final data = state.extra as UserModel;
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: MyProfilePage(
                            user: data,
                          ),
                          transitionDuration: const Duration(milliseconds: 180),
                          transitionsBuilder:
                              (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) {
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
                      path: 'edit-profile',
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final data = state.extra as UserModel;
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: EditProfilePage(
                            user: data,
                          ),
                          transitionDuration: const Duration(milliseconds: 180),
                          transitionsBuilder:
                              (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) {
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
