import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product/product.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/providers/providers.dart';

class ExclusiveProductsNotifier
    extends StateNotifier<AsyncValue<ProductListResponse>> {
  final ProductService _productService;
  int _currentPage = 3;
  bool _isLoading = false;
  static const int _pageSize = 300;
  final bool _isAllProductsView;

  ExclusiveProductsNotifier(this._productService,
      {bool isAllProductsView = false})
      : _isAllProductsView = isAllProductsView,
        super(const AsyncValue.loading()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final response = await _productService.listProducts(
        pageNo: _isAllProductsView ? 1 : 3,
        perPage: _isAllProductsView ? _pageSize : 20,
        sortDirection: 'DESC',
      );
      state = AsyncValue.data(response);
      _currentPage = _isAllProductsView ? 2 : 4;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (_isLoading || state.value?.isLastPage == true) return;

    _isLoading = true;
    try {
      final response = await _productService.listProducts(
        pageNo: _currentPage,
        perPage: _isAllProductsView ? _pageSize : 20,
        sortDirection: 'DESC',
      );

      if (state case AsyncData(value: final currentProducts)) {
        final newContent = [...currentProducts.content, ...response.content];

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
      }

      _currentPage++;
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  void refresh() {
    _currentPage = _isAllProductsView ? 1 : 3;
    loadInitial();
  }
}

final exclusiveProductsProvider = StateNotifierProvider<
    ExclusiveProductsNotifier, AsyncValue<ProductListResponse>>(
  (ref) => ExclusiveProductsNotifier(
    ref.watch(productServiceProvider),
    isAllProductsView: false,
  ),
);

final allExclusiveProductsProvider = StateNotifierProvider<
    ExclusiveProductsNotifier, AsyncValue<ProductListResponse>>(
  (ref) => ExclusiveProductsNotifier(
    ref.watch(productServiceProvider),
    isAllProductsView: true,
  ),
);
