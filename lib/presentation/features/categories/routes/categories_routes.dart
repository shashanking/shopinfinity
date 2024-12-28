import 'package:go_router/go_router.dart';
import '../screens/categories_screen.dart';
import '../screens/category_products_screen.dart';

final categoriesRoutes = [
  GoRoute(
    path: '/categories',
    builder: (context, state) => const CategoriesScreen(),
  ),
  GoRoute(
    path: '/category-products',
    builder: (context, state) {
      final extra = state.extra as Map<String, String>;
      return CategoryProductsScreen(
        categoryName: extra['categoryName']!,
        subCategoryName: extra['subCategoryName']!,
        itemCount: extra['itemCount']!,
      );
    },
  ),
];
