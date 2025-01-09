import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'dart:developer' as dev;

import '../../../../core/services/product_service.dart';

final bestSellerProductsProvider =
    AsyncNotifierProvider<BestSellerProductsNotifier, ProductListResponse?>(
  () => BestSellerProductsNotifier(),
);

class BestSellerProductsNotifier extends AsyncNotifier<ProductListResponse?> {
  late final ProductService _productService;

  @override
  Future<ProductListResponse?> build() async {
    _productService = ref.read(productServiceProvider);
    await loadBestSellerProducts();
    return state.value;
  }

  Future<void> loadBestSellerProducts({int page = 20}) async {
    try {
      state = const AsyncValue.loading();

      dev.log('Starting to fetch best seller products from page $page...',
          name: 'BestSellerProductsNotifier');
      final startTime = DateTime.now();

      final products = await _productService.listProducts(
        pageNo: page,
        perPage: 20,
        sortDirection: 'DESC',
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      dev.log(
          'Best seller products fetch completed in ${duration.inMilliseconds}ms',
          name: 'BestSellerProductsNotifier');
      dev.log('Loaded ${products.content.length} products from page $page',
          name: 'BestSellerProductsNotifier');

      state = AsyncValue.data(products);
    } catch (e, stack) {
      dev.log('Error loading best seller products: $e',
          name: 'BestSellerProductsNotifier', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }
}
