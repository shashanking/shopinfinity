import 'package:go_router/go_router.dart';
import '../screens/shop_screen.dart';

final shopRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const ShopScreen(),
  ),
];
