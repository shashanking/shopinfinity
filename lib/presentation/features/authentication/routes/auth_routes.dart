import 'package:go_router/go_router.dart';
import '../../search/screens/search_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../categories/screens/category_products_screen.dart';
import '../../product/screens/product_details_screen.dart';
import '../../categories/models/category_product.dart';
import '../../cart/screens/cart_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/personal_details_screen.dart';
import '../../shop/screens/shop_screen.dart';

final authRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
    // builder: (context, state) => const ShopScreen(),
  ),
  GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(
    path: '/otp',
    builder: (context, state) {
      final phoneNumber = state.extra as String;
      return OtpScreen(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: '/personal-details',
    builder: (context, state) {
      final isEnabled = (state.extra as bool?) ?? true;
      return PersonalDetailsScreen(isEnabled: isEnabled);
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
    path: '/product',
    builder: (context, state) {
      final product = state.extra as CategoryProduct;
      return ProductDetailsScreen(product: product);
    },
  ),
];
