import 'package:go_router/go_router.dart';
import '../screens/settings_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/account_privacy_screen.dart';
import '../screens/about_us_screen.dart';

List<RouteBase> settingsRoutes = [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: '/settings/privacy',
    builder: (context, state) => const AccountPrivacyScreen(),
  ),
  GoRoute(
    path: '/settings/about',
    builder: (context, state) => const AboutUsScreen(),
  ),
  GoRoute(
    path: '/privacy-policy',
    builder: (context, state) => const PrivacyPolicyScreen(),
  ),
];
