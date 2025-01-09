import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as dev;
import 'core/services/storage_service.dart';
import 'core/providers/providers.dart';
import 'presentation/features/address/routes/address_routes.dart';
import 'presentation/features/authentication/routes/auth_routes.dart';
import 'presentation/features/cart/routes/cart_routes.dart';
import 'presentation/features/orders/routes/orders_routes.dart';
import 'presentation/features/profile/routes/profile_routes.dart';
import 'presentation/features/settings/routes/settings_routes.dart';
import 'presentation/features/categories/routes/categories_routes.dart';
import 'presentation/features/shop/routes/shop_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        // Provide the initialized storage service
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final storage = ref.read(storageServiceProvider);
  
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      dev.log('Global redirect check for path: ${state.uri.path}', name: 'Router');
      // Wait for storage to be ready
      try {
        final isLoggedIn = await storage.isLoggedIn();
        final path = state.uri.path;
        
        // Don't redirect if we're in the auth flow
        if (path == '/login' || path == '/otp' || path == '/personal-details') {
          dev.log('In auth flow, no redirect needed', name: 'Router');
          return null;
        }
        
        if (isLoggedIn) {
          if (path == '/') {
            dev.log('Logged in, redirecting to shop', name: 'Router');
            return '/shop';
          }
        } else {
          if (path == '/' || path == '/shop') {
            dev.log('Not logged in, redirecting to login', name: 'Router');
            return '/login';
          }
        }
        return null;
      } catch (e) {
        dev.log('Router redirect error: $e', name: 'Router');
        return '/login';
      }
    },
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
