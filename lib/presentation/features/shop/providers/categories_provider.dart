import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/category/category_response.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/services/category_service.dart';
import 'dart:developer' as dev;

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<CategoryResponse?>>(
        (ref) {
  final categoryService = ref.watch(categoryServiceProvider);
  // dev.log('Creating categories notifier', name: 'CategoriesProvider');
  final notifier = CategoriesNotifier(categoryService: categoryService);
  notifier.loadCategories(); // Load categories immediately
  return notifier;
});

class CategoriesNotifier extends StateNotifier<AsyncValue<CategoryResponse?>> {
  final CategoryService _categoryService;

  CategoriesNotifier({required CategoryService categoryService})
      : _categoryService = categoryService,
        super(const AsyncValue.loading());

  Future<void> loadCategories() async {
    try {
      state = const AsyncValue.loading();

      // dev.log('Starting to fetch categories...', name: 'CategoriesNotifier');
      // final startTime = DateTime.now();

      final categories = await _categoryService.getAllCategories();

      // final endTime = DateTime.now();
      // final duration = endTime.difference(startTime);
      // dev.log('Categories fetch completed in ${duration.inMilliseconds}ms',
      //     name: 'CategoriesNotifier');

      state = AsyncValue.data(categories);
    } catch (e, stack) {
      dev.log('Error loading categories: $e',
          name: 'CategoriesNotifier', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    loadCategories();
  }
}
