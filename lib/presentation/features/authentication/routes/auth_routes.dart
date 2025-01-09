import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'package:shopinfinity/presentation/features/authentication/screens/login_screen.dart';
import 'package:shopinfinity/presentation/features/authentication/screens/otp_screen.dart';
import 'package:shopinfinity/presentation/features/authentication/screens/personal_details_screen.dart';
import 'package:shopinfinity/presentation/features/authentication/screens/welcome_screen.dart';
import 'package:shopinfinity/presentation/features/authentication/screens/splash_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../categories/screens/category_products_screen.dart';
import '../../product/screens/product_details_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../shop/screens/shop_screen.dart';

List<RouteBase> authRoutes = [
  GoRoute(
    path: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      dev.log('Root route redirect check', name: 'Router');
      
      final ref = ProviderScope.containerOf(context);
      final storage = ref.read(storageServiceProvider);
      
      // First priority: Check if user is logged in
      final isLoggedIn = await storage.isLoggedIn();
      dev.log('Root route: isLoggedIn = $isLoggedIn', name: 'Router');
      
      if (isLoggedIn) {
        dev.log('Root route: Redirecting to shop (logged in)', name: 'Router');
        return '/shop';
      }

      // Second priority: Check if it's first time launch
      final prefs = await SharedPreferences.getInstance();
      final hasLaunchedBefore = prefs.getBool('has_launched_before') ?? false;
      dev.log('Root route: hasLaunchedBefore = $hasLaunchedBefore', name: 'Router');
      
      if (!hasLaunchedBefore) {
        dev.log('Root route: First launch, redirecting to welcome', name: 'Router');
        await prefs.setBool('has_launched_before', true);
        return '/welcome';
      }
      
      dev.log('Root route: Not first launch, redirecting to welcome', name: 'Router');
      return '/welcome';
    },
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/welcome',
    redirect: (BuildContext context, GoRouterState state) async {
      dev.log('Welcome route redirect check', name: 'Router');
      final ref = ProviderScope.containerOf(context);
      final storage = ref.read(storageServiceProvider);
      final isLoggedIn = await storage.isLoggedIn();
      dev.log('Welcome route: isLoggedIn = $isLoggedIn', name: 'Router');
      
      if (isLoggedIn) {
        dev.log('Welcome route: Redirecting to shop', name: 'Router');
        return '/shop';
      }
      return null;
    },
    builder: (context, state) => const WelcomeScreen(),
  ),
  GoRoute(
    path: '/login',
    redirect: (BuildContext context, GoRouterState state) async {
      dev.log('Login route redirect check', name: 'Router');
      final ref = ProviderScope.containerOf(context);
      final storage = ref.read(storageServiceProvider);
      final isLoggedIn = await storage.isLoggedIn();
      dev.log('Login route: isLoggedIn = $isLoggedIn', name: 'Router');
      
      if (isLoggedIn) {
        dev.log('Login route: Redirecting to shop', name: 'Router');
        return '/shop';
      }
      return null;
    },
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/otp',
    redirect: (BuildContext context, GoRouterState state) async {
      dev.log('OTP route redirect check', name: 'Router');
      final ref = ProviderScope.containerOf(context);
      final storage = ref.read(storageServiceProvider);
      final isLoggedIn = await storage.isLoggedIn();
      dev.log('OTP route: isLoggedIn = $isLoggedIn', name: 'Router');
      
      if (isLoggedIn) {
        dev.log('OTP route: Redirecting to shop', name: 'Router');
        return '/shop';
      }
      
      // Check if phone number is provided
      if (state.extra == null) {
        dev.log('OTP route: No phone number provided, redirecting to login', name: 'Router');
        return '/login';
      }
      return null;
    },
    builder: (context, state) {
      final phone = state.extra as String;
      return OtpScreen(phoneNumber: phone);
    },
  ),
  GoRoute(
    path: '/personal-details',
    builder: (context, state) {
      final phone = state.extra as String;
      return PersonalDetailsScreen(phoneNumber: phone);
    },
  ),
  GoRoute(path: '/shop', builder: (context, state) => const ShopScreen()),
  GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
  GoRoute(
    path: '/categories',
    builder: (context, state) => const CategoriesScreen(),
  ),
  GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
  GoRoute(
    path: '/category-products',
    builder: (context, state) {
      final params = state.extra as Map<String, String>;
      return CategoryProductsScreen(
        categoryName: params['categoryName']!,
        subCategoryName: params['subCategoryName']!,
        itemCount: params['itemCount']!,
      );
    },
  ),
  GoRoute(
    path: '/product/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return ProductDetailsScreen(id: id);
    },
  ),
];
