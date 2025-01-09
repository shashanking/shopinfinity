import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/presentation/features/search/overlays/filter_overlay.dart';
import '../../../../core/models/product/product.dart';
import '../../../../core/utils/product_mapper.dart';
import '../widgets/recent_search_chip.dart';
import '../../../shared/widgets/product_card.dart';
import '../../product/widgets/product_details_overlay.dart';
import '../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null) {
      _search(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _search(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print('Searching for: $query'); // Debug print
      ref.read(searchProvider.notifier).search(query);
    });
  }

  Widget _buildSearchResults(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final variety = product.varieties.first;

        return ProductCard(
          isCardSmall: true,
          id: product.id,
          name: product.name,
          price: variety.discountPrice,
          originalPrice: variety.price,
          imageUrl: variety.imageUrls.first,
          discount: variety.discountPercent.round(),
          unit: '${variety.value}${variety.unit}',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ProductDetailsOverlay(
                product: mapToUiProduct(product),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    print(
        'Current search results: ${state.searchResults.length}'); // Debug print

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF8F9FB),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF1E222B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _search,
                      decoration: InputDecoration(
                        hintText: 'Search "Bread"',
                        hintStyle: const TextStyle(
                          color: Color(0xFF8891A5),
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF8891A5),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _search('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterOverlay(),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        color: Color(0xFF1E222B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_searchController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Lato',
                            color: Color(0xFF1E222B),
                          ),
                        ),
                        if (state.recentSearches.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(searchProvider.notifier)
                                  .clearRecentSearches();
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                color: Color(0xFF53B175),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.recentSearches
                          .map(
                            (search) => RecentSearchChip(
                              label: search,
                              onTap: () {
                                _searchController.text = search;
                                _search(search);
                              },
                              onDelete: () {
                                ref
                                    .read(searchProvider.notifier)
                                    .removeRecentSearch(search);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
            if (_searchController.text.isNotEmpty && !state.isLoading) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing Results for "${_searchController.text}"',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                        color: Color(0xFF1E222B),
                      ),
                    ),
                    Text(
                      '${state.searchResults.length} items',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                        color: Color(0xFF8891A5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (state.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_searchController.text.isNotEmpty &&
                state.searchResults.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8891A5),
                    ),
                  ),
                ),
              )
            else if (_searchController.text.isNotEmpty)
              Expanded(
                child: _buildSearchResults(state.searchResults),
              ),
          ],
        ),
      ),
    );
  }
}
