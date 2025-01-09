import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/category/category_response.dart';
import '../../shop/providers/categories_provider.dart';

final categoriesScreenProvider = Provider.autoDispose<AsyncValue<CategoryResponse?>>(
  (ref) {
    return ref.watch(categoriesProvider);
  },
);
