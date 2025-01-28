import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/models/product/product.dart';
import 'package:shopinfinity/core/providers/providers.dart';

import '../../../../core/services/product_service.dart';

class BestSellerProductsNotifier
    extends StateNotifier<AsyncValue<ProductListResponse>> {
  final ProductService _productService;
  int _currentPage;
  bool _isLoading = false;
  static const int _pageSize = 300;
  final bool _isAllProductsView;

  BestSellerProductsNotifier(this._productService,
      {bool isAllProductsView = false})
      : _isAllProductsView = isAllProductsView,
        _currentPage = 1,
        super(const AsyncValue.loading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final response = await _productService.listProducts(
        pageNo: _currentPage,
        perPage: _isAllProductsView ? _pageSize : 20,
        sortDirection: 'DESC',
      );
      state = AsyncValue.data(response);
      _currentPage = _isAllProductsView ? 2 : 21;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || state.value?.isLastPage == true) return;

    if (_isAllProductsView && (state.value?.content.length ?? 0) >= 200) {
      return;
    }

    _isLoading = true;
    try {
      final response = await _productService.listProducts(
        pageNo: _currentPage,
        perPage: _isAllProductsView ? 200 : 20,
        sortDirection: 'DESC',
      );

      if (state case AsyncData(value: final currentProducts)) {
        final newContent = [...currentProducts.content, ...response.content];
        final limitedContent =
            _isAllProductsView ? newContent.take(200).toList() : newContent;

        state = AsyncValue.data(
          ProductListResponse(
            content: limitedContent,
            totalPages: response.totalPages,
            totalElements: response.totalElements,
            isLastPage: _isAllProductsView
                ? limitedContent.length >= 200
                : response.isLastPage,
            pageNumber: response.pageNumber,
            pageSize: response.pageSize,
          ),
        );
      }

      _currentPage++;
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  void refresh() {
    _currentPage = _isAllProductsView ? 1 : 20;
    loadInitial();
  }
}

// Provider for home screen best seller products (20 per page)
final bestSellerProductsProvider = StateNotifierProvider<
    BestSellerProductsNotifier, AsyncValue<ProductListResponse>>(
  (ref) => BestSellerProductsNotifier(
    ref.watch(productServiceProvider),
    isAllProductsView: false,
  ),
);

// Provider for "See All" screen (50 per page, up to 200 products)
final allBestSellerProductsProvider = StateNotifierProvider<
    BestSellerProductsNotifier, AsyncValue<ProductListResponse>>(
  (ref) => BestSellerProductsNotifier(
    ref.watch(productServiceProvider),
    isAllProductsView: true,
  ),
);
