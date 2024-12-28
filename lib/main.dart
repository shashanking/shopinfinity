import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/features/authentication/routes/auth_routes.dart';
import 'presentation/features/address/routes/address_routes.dart';
import 'presentation/features/cart/routes/cart_routes.dart';
import 'presentation/features/orders/routes/orders_routes.dart';
import 'presentation/features/profile/routes/profile_routes.dart';
import 'presentation/features/settings/routes/settings_routes.dart';
import 'presentation/features/categories/routes/categories_routes.dart';
import 'presentation/features/shop/routes/shop_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      ...authRoutes,
      ...shopRoutes,
      ...cartRoutes,
      ...ordersRoutes,
      ...profileRoutes,
      ...settingsRoutes,
      ...addressRoutes,
      ...categoriesRoutes,
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Shop Infinity',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
