import 'package:go_router/go_router.dart';
import '../screens/settings_screen.dart';
import '../screens/account_privacy_screen.dart';
import '../screens/about_us_screen.dart';

final settingsRoutes = [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
    routes: [
      GoRoute(
        path: 'privacy',
        builder: (context, state) => const AccountPrivacyScreen(),
      ),
      GoRoute(
        path: 'about',
        builder: (context, state) => const AboutUsScreen(),
      ),
    ],
  ),
];
