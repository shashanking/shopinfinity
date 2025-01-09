import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product/product.dart';
import '../../../../core/providers/providers.dart';

final categoryProductsProvider = AutoDisposeStateNotifierProvider.family<
    CategoryProductsNotifier, AsyncValue<ProductListResponse>, String?>((ref, subCategory) {
  return CategoryProductsNotifier(ref, subCategory);
});

class CategoryProductsNotifier
    extends StateNotifier<AsyncValue<ProductListResponse>> {
  final Ref _ref;
  final String? _subCategory;

  CategoryProductsNotifier(this._ref, this._subCategory)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final productService = _ref.read(productServiceProvider);
      final products = await productService.listProducts(
        subCategory: _subCategory,
        pageNo: 1,
        perPage: 20,
      );
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    loadProducts();
  }
}
