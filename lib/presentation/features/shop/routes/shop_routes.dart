import 'dart:developer' as dev;
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/core/services/storage_service.dart';
import 'package:shopinfinity/presentation/features/shop/screens/shop_screen.dart';

final storageService = StorageService();

List<RouteBase> shopRoutes = [
  GoRoute(
    path: '/shop',
    redirect: (context, state) async {
      dev.log('Shop route redirect check', name: 'Router');
      final isLoggedIn = await storageService.isLoggedIn();
      dev.log('Shop route: isLoggedIn = $isLoggedIn', name: 'Router');
      
      if (!isLoggedIn) {
        dev.log('Shop route: Not logged in, redirecting to welcome', name: 'Router');
        return '/welcome';
      }
      dev.log('Shop route: Logged in, staying in shop', name: 'Router');
      return null;
    },
    builder: (context, state) => const ShopScreen(),
  ),
];
