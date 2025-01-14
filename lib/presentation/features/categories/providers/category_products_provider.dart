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
  String? _parentSubCategory;
  bool _isSubCategory2;
  int _currentPage = 1;
  bool _isLoading = false;
  static const int _pageSize = 20;
  bool _mounted = true;

  CategoryProductsNotifier(this._ref, this._subCategory)
      : _isSubCategory2 = false,
        _parentSubCategory = null,
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
    _parentSubCategory = parentSubCategory;
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
        // For subCategory2, we need both parent subcategory and subcategory2
        if (_parentSubCategory == null) {
          dev.log('Error: Parent subcategory is null for subcategory2 view');
          state = const AsyncValue.error(
              'Parent subcategory is required', StackTrace.empty);
          return;
        }

        dev.log(
            'Fetching products for subCategory2: $_subCategory with parent: $_parentSubCategory');
        final products = await productService.listProducts(
          subCategory: _parentSubCategory, // Pass the parent subcategory
          subCategory2:
              _subCategory, // Pass the current subcategory as subCategory2
          pageNo: 1,
          perPage: 100,
        );

        dev.log(
            'Raw response for subCategory2: ${products.content.length} products');
        if (products.content.isNotEmpty) {
          dev.log('First product: ${products.content.first.toJson()}');
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
            totalElements: validProducts.length,
            isLastPage: true,
            pageNumber: products.pageNumber,
            pageSize: products.pageSize,
          ),
        );

        dev.log(
            'Fetched ${validProducts.length} valid products for subCategory2: $_subCategory');
      } else {
        // For main subcategory, use pagination
        dev.log('Fetching products for subCategory: $_subCategory');
        final products = await productService.listProducts(
          subCategory: _subCategory,
          pageNo: 1,
          perPage: _pageSize,
        );

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
    // Only load more for main subcategory view
    if (_isSubCategory2) return;
    if (!_mounted) return;
    if (_isLoading || state.value?.isLastPage == true) return;

    _isLoading = true;
    try {
      final productService = _ref.read(productServiceProvider);
      final response = await productService.listProducts(
        subCategory: _subCategory,
        pageNo: _currentPage,
        perPage: _pageSize,
      );

      if (!_mounted) return;

      if (state case AsyncData(value: final currentProducts)) {
        // Filter out products without varieties
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
