import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;

import '../../../../core/models/product/product.dart';
import '../../../../core/providers/providers.dart';

final categoryProductsProvider = AutoDisposeStateNotifierProvider.family<
    CategoryProductsNotifier,
    AsyncValue<ProductListResponse>,
    String?>((ref, subCategory) {
  return CategoryProductsNotifier(ref, subCategory);
});

class CategoryProductsNotifier
    extends StateNotifier<AsyncValue<ProductListResponse>> {
  final Ref _ref;
  final String? _subCategory;
  // String? _parentSubCategory;
  bool _isSubCategory2;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _mounted = true;

  CategoryProductsNotifier(this._ref, this._subCategory)
      : _isSubCategory2 = false,
        // _parentSubCategory = null,
        super(const AsyncValue.loading()) {
    loadInitial();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void setParentSubCategory(String? parentSubCategory) {
    if (!_mounted) return;
    // _parentSubCategory = parentSubCategory;
  }

  void setIsSubCategory2(bool value) {
    if (!_mounted) return;
    _isSubCategory2 = value;
    _currentPage = 1;
    loadInitial();
  }

  Future<void> loadInitial() async {
    if (!_mounted) return;
    try {
      state = const AsyncValue.loading();
      final productService = _ref.read(productServiceProvider);

      if (_isSubCategory2) {
        dev.log('Fetching products for subCategory2: $_subCategory');
        final products = await productService.listProducts(
          subCategory2: _subCategory,
          pageNo: 1,
        );

        dev.log(
            'Raw response for subCategory2: ${products.content.length} products');
        if (products.content.isNotEmpty) {
          dev.log('First product: ${products.content.first.toJson()}');
          for (var product in products.content) {
            dev.log(
                'Product ${product.name}: ${product.varieties.length} varieties');
            if (product.varieties.isEmpty) {
              dev.log('Product ${product.name} has no varieties');
            }
          }
        }

        if (!_mounted) return;

        // Filter out products without varieties
        final validProducts =
            products.content.where((p) => p.varieties.isNotEmpty).toList();
        dev.log('Valid products (with varieties): ${validProducts.length}');

        state = AsyncValue.data(
          ProductListResponse(
            content: validProducts,
            totalPages: products.totalPages,
            totalElements: products.totalElements,
            isLastPage: products.isLastPage,
            pageNumber: products.pageNumber,
            pageSize: products.pageSize,
          ),
        );

        _currentPage = 2;
        dev.log(
            'Fetched ${validProducts.length} valid products for subCategory2: $_subCategory');
      } else {
        // For main subcategory view
        dev.log('Fetching products for subCategory: $_subCategory');
        final products = await productService.listProducts(
          subCategory: _subCategory,
          pageNo: 1,
        );

        if (!_mounted) return;

        final validProducts =
            products.content.where((p) => p.varieties.isNotEmpty).toList();
        dev.log('Valid products (with varieties): ${validProducts.length}');

        state = AsyncValue.data(
          ProductListResponse(
            content: validProducts,
            totalPages: products.totalPages,
            totalElements: products.totalElements,
            isLastPage: products.isLastPage,
            pageNumber: products.pageNumber,
            pageSize: products.pageSize,
          ),
        );
        _currentPage = 2;
        dev.log(
            'Fetched ${validProducts.length} valid products for subCategory: $_subCategory');
      }
    } catch (error, stackTrace) {
      dev.log('Error loading products: $error',
          error: error, stackTrace: stackTrace);
      if (!_mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (!_mounted) return;
    if (_isLoading || state.value?.isLastPage == true) return;

    _isLoading = true;
    try {
      final productService = _ref.read(productServiceProvider);

      final response = await productService.listProducts(
        subCategory: _isSubCategory2 ? null : _subCategory,
        subCategory2: _isSubCategory2 ? _subCategory : null,
        pageNo: _currentPage,
      );

      if (!_mounted) return;

      if (state case AsyncData(value: final currentProducts)) {
        final validNewProducts =
            response.content.where((p) => p.varieties.isNotEmpty).toList();
        final newContent = [...currentProducts.content, ...validNewProducts];

        state = AsyncValue.data(
          ProductListResponse(
            content: newContent,
            totalPages: response.totalPages,
            totalElements: response.totalElements,
            isLastPage: response.isLastPage,
            pageNumber: response.pageNumber,
            pageSize: response.pageSize,
          ),
        );

        dev.log(
            'Loaded ${validNewProducts.length} more valid products. Total: ${newContent.length}');
      }

      _currentPage++;
    } catch (error) {
      dev.log('Error loading more products: $error', error: error);
    } finally {
      if (_mounted) {
        _isLoading = false;
      }
    }
  }

  Future<void> refresh() async {
    if (!_mounted) return;
    _currentPage = 1;
    loadInitial();
  }
}
