import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/providers/providers.dart';
import 'package:shopinfinity/core/services/product_service.dart';

final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListResponse>((ref) {
  final productService = ref.read(productServiceProvider);
  return ProductListNotifier(productService);
});

class ProductListNotifier extends StateNotifier<ProductListResponse> {
  final ProductService _productService;
  int _currentPage = 0;
  bool _isLoading = false;
  String? _currentCategory;
  String? _currentSubCategory;
  String? _searchQuery;
  String _sortBy = 'createdAt';
  String _sortDirection = 'DESC';

  ProductListNotifier(this._productService)
      : super(const ProductListResponse(
          content: [],
          totalPages: 0,
          totalElements: 0,
          isLastPage: true,
          pageNumber: 0,
          pageSize: 0,
        ));

  Future<void> loadProducts() async {
    if (_isLoading || state.isLastPage) return;

    _isLoading = true;
    try {
      final response = await _productService.listProducts(
        pageNo: _currentPage,
        category: _currentCategory,
        subCategory: _currentSubCategory,
        sortDirection: _sortDirection,

      );

      if (_currentPage == 0) {
        state = response;
      } else {
        state = ProductListResponse(
          content: [...state.content, ...response.content],
          totalPages: response.totalPages,
          totalElements: response.totalElements,
          isLastPage: response.isLastPage,
          pageNumber: response.pageNumber,
          pageSize: response.pageSize,
        );
      }

      _currentPage++;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
    }
  }

  void setCategory(String? category) {
    if (_currentCategory == category) return;
    _currentCategory = category;
    reset();
  }

  void setSubCategory(String? subCategory) {
    if (_currentSubCategory == subCategory) return;
    _currentSubCategory = subCategory;
    reset();
  }

  void setSearchQuery(String? query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    reset();
  }

  void setSortBy(String sortBy, String direction) {
    if (_sortBy == sortBy && _sortDirection == direction) return;
    _sortBy = sortBy;
    _sortDirection = direction;
    reset();
  }

  void reset() {
    _currentPage = 0;
    state = const ProductListResponse(
      content: [],
      totalPages: 0,
      totalElements: 0,
      isLastPage: true,
      pageNumber: 0,
      pageSize: 0,
    );
  }
}
