import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/network/api_exception.dart';
import 'package:shopinfinity/core/services/product_service.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'dart:developer' as dev;

final productListProvider = StateNotifierProvider<ProductListNotifier, AsyncValue<ProductListResponse>>((ref) {
  final productService = ref.watch(productServiceProvider);
  dev.log('Creating product list notifier', name: 'ProductProvider');
  return ProductListNotifier(productService);
});

class ProductListNotifier extends StateNotifier<AsyncValue<ProductListResponse>> {
  final ProductService _productService;
  String? _currentCategory;
  String? _currentSubCategory;
  String? _searchQuery;
  String _sortBy = 'createdAt';
  String _sortDirection = 'DESC';
  int _currentPage = 1;
  bool _hasMorePages = true;

  ProductListNotifier(this._productService) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    try {
      state = const AsyncValue.loading();
      
      final products = await _productService.listProducts(
        pageNo: _currentPage,
        category: _currentCategory,
        subCategory: _currentSubCategory,
        sortDirection: _sortDirection,
      );

      _hasMorePages = products.content.length >= products.perPage;
      
      if (!refresh && state.hasValue) {
        // Append new products to existing list
        final currentProducts = state.value!;
        final updatedProducts = ProductListResponse(
          perPage: products.perPage,
          pageNo: products.pageNo,
          sortBy: products.sortBy,
          sortDirection: products.sortDirection,
          content: [...currentProducts.content, ...products.content],
          count: products.count,
        );
        state = AsyncValue.data(updatedProducts);
      } else {
        state = AsyncValue.data(products);
      }

      _currentPage++;
    } on ApiException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void setCategory(String? category) {
    if (_currentCategory == category) return;
    _currentCategory = category;
    loadProducts(refresh: true);
  }

  void setSubCategory(String? subCategory) {
    if (_currentSubCategory == subCategory) return;
    _currentSubCategory = subCategory;
    loadProducts(refresh: true);
  }

  void setSearchQuery(String? query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    loadProducts(refresh: true);
  }

  void setSortBy(String sortBy, String direction) {
    if (_sortBy == sortBy && _sortDirection == direction) return;
    _sortBy = sortBy;
    _sortDirection = direction;
    loadProducts(refresh: true);
  }

  void refreshProducts() {
    loadProducts(refresh: true);
  }

  bool get canLoadMore => _hasMorePages;
}
