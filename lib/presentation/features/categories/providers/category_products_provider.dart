import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;

import '../../../../core/models/product/product.dart';
import '../../../../core/providers/providers.dart';

// Create a class to hold the provider parameters
class CategoryProductsParams {
  final String subCategory;
  final String? parentCategory;

  const CategoryProductsParams({
    required this.subCategory,
    this.parentCategory,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryProductsParams &&
          runtimeType == other.runtimeType &&
          subCategory == other.subCategory &&
          parentCategory == other.parentCategory;

  @override
  int get hashCode => Object.hash(subCategory, parentCategory);
}

final categoryProductsProvider = AutoDisposeStateNotifierProvider.family<
    CategoryProductsNotifier,
    AsyncValue<ProductListResponse>,
    CategoryProductsParams>((ref, params) {
  return CategoryProductsNotifier(
      ref, params.subCategory, params.parentCategory);
});

class CategoryProductsNotifier
    extends StateNotifier<AsyncValue<ProductListResponse>> {
  final Ref _ref;
  final String _subCategory;
  final String? _parentSubCategory;
  final bool _isSubCategory2;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _mounted = true;
  int _lastProductCount = 0;

  CategoryProductsNotifier(
      this._ref, this._subCategory, this._parentSubCategory)
      : _isSubCategory2 = _parentSubCategory != null,
        super(const AsyncValue.loading()) {
      // dev.log(
      //     'Creating CategoryProductsNotifier - subCategory: $_subCategory, parentCategory: $_parentSubCategory, isSubCategory2: $_isSubCategory2',
      //     name: 'CategoryProducts');
    loadInitial();
  }

  @override
  void dispose() {
    // dev.log('Disposing CategoryProductsNotifier for subcategory: $_subCategory',
    //     name: 'CategoryProducts');
    _mounted = false;
    super.dispose();
  }

  void _checkProductCountTransition(List<Product> newProducts) {
    if (_lastProductCount > 0 && newProducts.length > _lastProductCount) {
      // dev.log(
      //     '⚠️ Product count increased unexpectedly: $_lastProductCount → ${newProducts.length}',
      //     name: 'CategoryProducts');
      // dev.log(
      //     'Current filters - subCategory: $_subCategory, parentSubCategory: $_parentSubCategory, isSubCategory2: $_isSubCategory2',
      //     name: 'CategoryProducts');
    }
    _lastProductCount = newProducts.length;
  }

  Future<void> loadInitial() async {
    if (!_mounted) return;
    try {
      // dev.log('Starting initial load for subcategory: $_subCategory',
      //     name: 'CategoryProducts');
      // dev.log(
      //     'Current state - isSubCategory2: $_isSubCategory2, parentSubCategory: $_parentSubCategory',
      //     name: 'CategoryProducts');

      state = const AsyncValue.loading();
      final productService = _ref.read(productServiceProvider);

      if (_isSubCategory2 && _parentSubCategory != null) {
        // dev.log(
        //     'Fetching subCategory2 products - subCategory2: $_subCategory, parent: $_parentSubCategory',
        //     name: 'CategoryProducts');
        final products = await productService.listProducts(
          subCategory: _parentSubCategory,
          subCategory2: _subCategory,
          pageNo: 1,
        );

        if (!_mounted) return;

        final validProducts =
            products.content.where((p) => p.varieties.isNotEmpty).toList();
        // dev.log(
        //     'Filtered products for subCategory2 - total: ${products.content.length}, valid: ${validProducts.length}',
        //     name: 'CategoryProducts');

        _checkProductCountTransition(validProducts);

        state = AsyncValue.data(ProductListResponse(
          content: validProducts,
          totalPages: products.totalPages,
          totalElements: products.totalElements,
          isLastPage: products.isLastPage,
          pageNumber: products.pageNumber,
          pageSize: products.pageSize,
        ));
      } else {
        // dev.log(
        //     'Fetching main subcategory products - subcategory: $_subCategory',
        //     name: 'CategoryProducts');
        final products = await productService.listProducts(
          subCategory: _subCategory,
          pageNo: 1,
        );

        if (!_mounted) return;

        final validProducts =
            products.content.where((p) => p.varieties.isNotEmpty).toList();
        // dev.log(
        //     'Filtered products for main subcategory - total: ${products.content.length}, valid: ${validProducts.length}',
        //     name: 'CategoryProducts');

        _checkProductCountTransition(validProducts);

        state = AsyncValue.data(ProductListResponse(
          content: validProducts,
          totalPages: products.totalPages,
          totalElements: products.totalElements,
          isLastPage: products.isLastPage,
          pageNumber: products.pageNumber,
          pageSize: products.pageSize,
        ));
      }
      _currentPage = 2;
    } catch (error, stackTrace) {
      dev.log('Error loading products: $error',
          name: 'CategoryProducts', error: error, stackTrace: stackTrace);
      if (!_mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (!_mounted) return;
    if (_isLoading || state.value?.isLastPage == true) return;

    // dev.log(
    //     'Loading more products - subcategory: $_subCategory, page: $_currentPage',
    //     name: 'CategoryProducts');
    // dev.log(
    //     'Current state - isSubCategory2: $_isSubCategory2, parentSubCategory: $_parentSubCategory',
    //     name: 'CategoryProducts');

    _isLoading = true;
    try {
      final productService = _ref.read(productServiceProvider);

      final response = await productService.listProducts(
        subCategory: _isSubCategory2 ? _parentSubCategory : _subCategory,
        subCategory2: _isSubCategory2 ? _subCategory : null,
        pageNo: _currentPage,
      );

      if (!_mounted) return;

      if (state case AsyncData(value: final currentProducts)) {
        final validNewProducts =
            response.content.where((p) => p.varieties.isNotEmpty).toList();
        final newContent = [...currentProducts.content, ...validNewProducts];

        // dev.log(
        //     'Loaded more products - new: ${validNewProducts.length}, total: ${newContent.length}',
        //     name: 'CategoryProducts');

        _checkProductCountTransition(newContent);

        state = AsyncValue.data(ProductListResponse(
          content: newContent,
          totalPages: response.totalPages,
          totalElements: response.totalElements,
          isLastPage: response.isLastPage,
          pageNumber: response.pageNumber,
          pageSize: response.pageSize,
        ));
      }

      _currentPage++;
    } catch (error, stack) {
      dev.log('Error loading more products: $error',
          name: 'CategoryProducts', error: error, stackTrace: stack);
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
