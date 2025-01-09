import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'dart:developer' as dev;

import '../../../../core/services/product_service.dart';

final exclusiveProductsProvider = StateNotifierProvider<ExclusiveProductsNotifier, AsyncValue<ProductListResponse?>>((ref) {
  final productService = ref.watch(productServiceProvider);
  dev.log('Creating exclusive products notifier', name: 'ExclusiveProductsProvider');
  final notifier = ExclusiveProductsNotifier(productService: productService);
  notifier.loadExclusiveProducts(); // Load products immediately
  return notifier;
});

class ExclusiveProductsNotifier extends StateNotifier<AsyncValue<ProductListResponse?>> {
  final ProductService _productService;

  ExclusiveProductsNotifier({required ProductService productService})
      : _productService = productService,
        super(const AsyncValue.loading());

  Future<void> loadExclusiveProducts({int page = 3}) async {
    try {
      state = const AsyncValue.loading();
      
      dev.log('Starting to fetch exclusive products from page $page...', 
             name: 'ExclusiveProductsNotifier');
      final startTime = DateTime.now();
      
      final products = await _productService.listProducts(
        pageNo: page,
        perPage: 20,
        sortDirection: 'DESC',
      );
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      dev.log('Exclusive products fetch completed in ${duration.inMilliseconds}ms', 
             name: 'ExclusiveProductsNotifier');
      dev.log('Loaded ${products.content.length} products from page $page', 
             name: 'ExclusiveProductsNotifier');
      
      state = AsyncValue.data(products);
    } catch (e, stack) {
      dev.log('Error loading exclusive products: $e', 
             name: 'ExclusiveProductsNotifier',
             error: e,
             stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    loadExclusiveProducts();
  }
}
