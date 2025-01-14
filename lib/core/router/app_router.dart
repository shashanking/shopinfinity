import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'package:shopinfinity/presentation/features/authentication/routes/auth_routes.dart';
import 'package:shopinfinity/presentation/features/address/routes/address_routes.dart';
import 'package:shopinfinity/presentation/features/cart/routes/cart_routes.dart';
import 'package:shopinfinity/presentation/features/orders/routes/orders_routes.dart';
import 'package:shopinfinity/presentation/features/profile/routes/profile_routes.dart';
import 'package:shopinfinity/presentation/features/settings/routes/settings_routes.dart';
import 'package:shopinfinity/presentation/features/categories/routes/categories_routes.dart';
import 'package:shopinfinity/presentation/features/shop/routes/shop_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final storageService = ref.watch(storageServiceProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      // Allow splash screen to be shown
      if (state.matchedLocation == '/') {
        return null;
      }

      // Allow welcome screen
      if (state.matchedLocation == '/welcome') {
        return null;
      }

      // Check if user is logged in
      final isLoggedIn = await storageService.isLoggedIn();

      // If user is logged in and trying to access auth pages, redirect to shop
      if (isLoggedIn && (
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/otp' ||
          state.matchedLocation == '/personal-details'
        )) {
        return '/shop';
      }

      // If user is not logged in and trying to access protected pages, redirect to login
      if (!isLoggedIn && 
          !state.matchedLocation.startsWith('/login') &&
          !state.matchedLocation.startsWith('/otp') &&
          !state.matchedLocation.startsWith('/personal-details') &&
          !state.matchedLocation.startsWith('/welcome')) {
        return '/login';
      }

      return null;
    },
    routes: [
      ...authRoutes,
      ...addressRoutes,
      ...cartRoutes,
      ...ordersRoutes,
      ...profileRoutes,
      ...settingsRoutes,
      ...categoriesRoutes,
      ...shopRoutes,
    ],
  );
});
