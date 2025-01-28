import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/product/product.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/providers/providers.dart';

const kRecentSearchesBoxName = 'recent_searches';
const kMaxRecentSearches = 10;

class SearchState {
  final List<Product> searchResults;
  final List<String> recentSearches;
  final bool isLoading;
  final String? error;

  SearchState({
    required this.searchResults,
    required this.recentSearches,
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<Product>? searchResults,
    List<String>? recentSearches,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;
  final ProductService _productService;
  late final Box<String> _recentSearchesBox;

  SearchNotifier(this.ref)
      : _productService = ref.read(productServiceProvider),
        super(SearchState(searchResults: [], recentSearches: [])) {
    _initHive();
  }

  Future<void> _initHive() async {
    _recentSearchesBox = await Hive.openBox<String>(kRecentSearchesBoxName);
    final recentSearches = _recentSearchesBox.values.toList();
    state = state.copyWith(recentSearches: recentSearches);
  }

  Future<void> search(String query) async {
    dev.log(
        'Starting search with query: \\${query.isEmpty ? "empty (all products)" : query}',
        name: 'SearchProvider');
    state = state.copyWith(isLoading: true, error: null);

    try {
      dev.log('Fetching products...', name: 'SearchProvider');
      final response = await _productService.listProducts(
        name: query.isEmpty ? null : query,
        pageNo: 1,
        perPage: 50,
      );

      dev.log('Received \\${response.content.length} products',
          name: 'SearchProvider');

      // Add to recent searches if we have results and query is not empty
      if (query.isNotEmpty && query.length > 2 && response.content.isNotEmpty) {
        await addToRecentSearches(query);
      }

      state = state.copyWith(
        searchResults: response.content,
        isLoading: false,
        error: null,
      );
      dev.log('Search completed successfully', name: 'SearchProvider');
    } catch (e) {
      dev.log('Error during search: \\$e', name: 'SearchProvider', error: e);
      state = state.copyWith(
        searchResults: [],
        error: 'Failed to search products',
        isLoading: false,
      );
    }
  }

  Future<void> addToRecentSearches(String query) async {
    final searches = List<String>.from(state.recentSearches);

    // Remove if already exists
    searches.remove(query);

    // Add to the beginning
    searches.insert(0, query);

    // Keep only the most recent searches
    if (searches.length > kMaxRecentSearches) {
      searches.removeLast();
    }

    // Update Hive and state
    await _recentSearchesBox.clear();
    await _recentSearchesBox.addAll(searches);

    state = state.copyWith(recentSearches: searches);
  }

  Future<void> removeRecentSearch(String query) async {
    final searches = List<String>.from(state.recentSearches);
    searches.remove(query);

    // Update Hive and state
    await _recentSearchesBox.clear();
    await _recentSearchesBox.addAll(searches);

    state = state.copyWith(recentSearches: searches);
  }

  Future<void> clearRecentSearches() async {
    await _recentSearchesBox.clear();
    state = state.copyWith(recentSearches: []);
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
