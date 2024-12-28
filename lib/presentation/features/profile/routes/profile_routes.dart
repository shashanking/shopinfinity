import 'package:go_router/go_router.dart';
import '../screens/profile_screen.dart';

final profileRoutes = [
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfileScreen(),
  ),
];
