import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../presentation/screens/main_navigation.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/upload_book_screen.dart';
import '../../presentation/screens/privacy_policy_screen.dart';
import '../../presentation/screens/help_center_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/reading_history_screen.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../../presentation/screens/terms_conditions_screen.dart';
import '../../presentation/screens/downloaded_books_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const signup = '/signup';
  static const forgotPassword = '/forgotPassword';
  static const uploadBook = '/uploadBook';
  static const privacyPolicy = '/privacyPolicy';
  static const helpCenter = '/helpCenter';
  static const settings = '/settings';
  static const readingHistory = '/readingHistory';
  static const notifications = '/notifications';
  static const termsConditions = '/termsConditions';
  static const downloads = '/downloads';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const MainNavigation(),
    favorites: (_) => const FavoritesScreen(),
    profile: (_) => const ProfileScreen(),
    signup: (_) => const SignupScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    uploadBook: (_) => const UploadBookScreen(),
    privacyPolicy: (_) => const PrivacyPolicyScreen(),
    helpCenter: (_) => const HelpCenterScreen(),
    settings: (_) => const SettingsScreen(),
    readingHistory: (_) => const ReadingHistoryScreen(),
    notifications: (_) => const NotificationsScreen(),
    termsConditions: (_) => const TermsConditionsScreen(),
    downloads: (_) => const DownloadedBooksScreen(),
  };
}
