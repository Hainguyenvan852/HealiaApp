import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/landing/splash_screen.dart';
import 'package:healio_app/features/manager/auth/presentation/pages/login_page.dart';
import 'package:healio_app/features/manager/main_navigator_page.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/appointment/presentation/pages/appointment_detail_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/update_password_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/helper_center_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/language_setting_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/notification_setting_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/setting_page.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/auth/presentation/pages/forgot_password_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/login_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/reset_password_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/sign_up_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/verification_page.dart';
import 'package:healio_app/features/user/appointment/presentation/pages/appointment_page.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/presentation/pages/category_search_page.dart';
import 'package:healio_app/features/user/explore/presentation/pages/explore_page.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/features/user/home/presentation/pages/confirm_booking_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/home_page.dart';
import 'package:healio_app/features/user/auth/presentation/pages/main_page.dart';
import 'package:healio_app/features/user/explore/presentation/pages/location_search_page.dart';
import 'package:healio_app/features/user/explore/presentation/pages/search_page.dart';
import 'package:healio_app/features/user/explore/presentation/pages/time_search_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/reviews_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/select_professional_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/select_time_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/select_service_page.dart';
import 'package:healio_app/features/user/home/presentation/pages/store_detail_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/edit_profile_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/favorite_store_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/my_profile_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/personal_page.dart';
import 'package:healio_app/features/landing/app_retry.dart';
import 'package:healio_app/features/landing/landing_page.dart';
import 'package:healio_app/features/user/profile/presentation/pages/terms_and_policy_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../features/manager/account setups/presentation/pages/incomplete_registration_screen.dart';

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
          path: '/auth-callback',
          name: 'auth-callback',
          builder: (context, state) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'login',
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
          path: '/professional-login',
          name: 'professional-login',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'professional-login',
              child: const ProfessionalLoginPage(),
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
          builder: (context, state) => SignupPage(role: state.extra.toString()),
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
          builder: (context, state) {
            final emailRecovery = state.extra as String?;
            return ResetPasswordPage(
              emailRecovery: emailRecovery ?? 'Not found',
            );
          },
        ),
        GoRoute(
          path: '/update-password',
          name: 'update-password',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'update-password',
              child: const UpdatePasswordPage(),
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
          parentNavigatorKey: rootNavigatorKey,
          path: '/store-detail',
          name: 'store-detail',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'store-detail',
              child: const StoreDetailPage(),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/setting',
          name: 'setting',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'setting',
              child: const SettingsPage(),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/notification-setting',
          name: 'notification-setting',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'notification-setting',
              child: const NotificationSettingsPage(),
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
          routes: [],
        ),
        GoRoute(
          path: '/language-setting',
          name: 'language-setting',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'language-setting',
              child: const LanguageSettingsPage(),
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
          path: '/helper-center',
          name: 'helper-center',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'helper-center',
              child: const HelperCenterPage(),
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
          path: '/term-and-policy',
          name: 'term-and-policy',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'term-and-policy',
              child: const TermsAndPolicyPage(),
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
          parentNavigatorKey: rootNavigatorKey,
          path: '/select-service',
          name: 'select-service',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as List<CategoryModel>;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'select-service',
              child: SelectServiceScreen(categories: data),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/select-datetime',
          name: 'select-datetime',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>?;

            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'select-datetime',
              child: data != null
                  ? SelectTimePage(
                      professionals: data['professionals'],
                      selectedProfessional: data['selected'],
                    )
                  : SelectTimePage(),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/select-professional',
          name: 'select-professional',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as List<StaffModel>;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'select-professional',
              child: SelectProfessionalPage(professionals: data),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/review-confirm',
          name: 'review-confirm',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'review-confirm',
              child: ConfirmBookingPage(),
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
          routes: [],
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: '/all-reviews',
          name: 'all-reviews',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>;
            final allReviews = data['all-reviews'] as List<ReviewModel>;
            final store = data['store'] as StoreModel;

            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'all-reviews',
              child: ReviewsScreen(allReviews: allReviews, store: store),
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
          routes: [],
        ),
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, navigationShell) {
            return MainPage(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: shellNavigatorHomeKey,
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomePage(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: shellNavigatorExploreKey,
              routes: [
                GoRoute(
                  path: '/explore',
                  name: 'explore',
                  builder: (context, state) => const ExplorePage(),
                  routes: [
                    GoRoute(
                      path: 'search',
                      name: 'search',
                      parentNavigatorKey: rootNavigatorKey, //che BottomBar
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          name: 'search',
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
                          name: 'category-search',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  name: 'category-search',
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
                          name: 'location-search',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  name: 'location-search',
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
                          name: 'time-search',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                                final data =
                                    state.extra as Map<String, dynamic>;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  name: 'time-search',
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
                  name: 'appointment',
                  builder: (context, state) => const AppointmentPage(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: rootNavigatorKey,
                      path: '/appointment-detail',
                      name: 'appointment-detail',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final appointment = state.extra as AppointmentModel;
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          name: 'appointment-detail',
                          child: AppointmentDetailPage(
                            appointment: appointment,
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
                      routes: [],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: shellNavigatorProfileKey,
              routes: [
                GoRoute(
                  path: '/personal-setting',
                  name: 'personal-setting',
                  builder: (context, state) => const PersonalPage(),
                  routes: [],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/my-profile',
          name: 'my-profile',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'my-profile',
              child: MyProfilePage(),
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
          path: '/edit-profile',
          name: 'edit-profile',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as UserModel;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'edit-profile',
              child: EditProfilePage(user: data),
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
          path: '/favorites',
          name: 'favorites',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as UserModel;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'favorites',
              child: FavoriteStoresPage(currentUser: data),
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
          path: '/manager-navigator',
          name: 'manager-navigator',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final data = state.extra as UserModel;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'manager-navigator',
              child: MainNavigatorPage(currentUser: data),
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
          path: '/incomplete-registration',
          name: 'incomplete-registration',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              name: 'incomplete-registration',
              child: IncompleteRegistrationScreen(),
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
        // GoRoute(
        //   path: '/start-screen',
        //   name: 'start-screen',
        //   parentNavigatorKey: rootNavigatorKey,
        //   pageBuilder: (BuildContext context, GoRouterState state) {
        //     final data = state.extra as UserModel;
        //     return CustomTransitionPage<void>(
        //       key: state.pageKey,
        //       name: 'start-screen',
        //       child: StartScreen(currentUser: data),
        //       transitionDuration: const Duration(milliseconds: 180),
        //       transitionsBuilder:
        //           (
        //             BuildContext context,
        //             Animation<double> animation,
        //             Animation<double> secondaryAnimation,
        //             Widget child,
        //           ) {
        //             return FadeTransition(
        //               opacity: CurveTween(
        //                 curve: Curves.easeInOut,
        //               ).animate(animation),
        //               child: child,
        //             );
        //           },
        //     );
        //   },
        // ),
      ],
    );
  }
}
