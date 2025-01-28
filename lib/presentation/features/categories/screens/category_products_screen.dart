import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as dev;

import '../../../../core/models/category/category_response.dart';
import '../../../shared/widgets/product_card.dart';
import '../../shop/providers/categories_provider.dart';
import '../providers/category_products_provider.dart';
import '../widgets/subcategory_list_item.dart';
import '../../product/widgets/product_details_overlay.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String subCategoryName;
  final String itemCount;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.subCategoryName,
    required this.itemCount,
  });

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  late String selectedSubCategory2;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedSubCategory2 = '';
    _scrollController.addListener(_onScroll);

    // Initially load products for the main subcategory
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier =
          ref.read(categoryProductsProvider(widget.subCategoryName).notifier);
      notifier.setIsSubCategory2(false);
      dev.log('Initial load for subcategory: ${widget.subCategoryName}');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final notifier = ref.read(categoryProductsProvider(
              selectedSubCategory2.isEmpty
                  ? widget.subCategoryName
                  : selectedSubCategory2)
          .notifier);
      notifier.loadMore();
    }
  }

  void _onSubCategory2Selected(SubCategory2 subCategory2) {
    // First update the UI state
    setState(() {
      selectedSubCategory2 = subCategory2.name;
    });

    // Then set up the provider and trigger a load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier =
          ref.read(categoryProductsProvider(subCategory2.name).notifier);
      notifier.setParentSubCategory(widget.subCategoryName);
      notifier.setIsSubCategory2(true);
      dev.log(
          'Selected subcategory2: ${subCategory2.name} under parent: ${widget.subCategoryName}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // If selectedSubCategory2 is empty, show products for the main subcategory
    // Otherwise, show products for the selected subcategory2
    final productsAsync = ref.watch(categoryProductsProvider(
        selectedSubCategory2.isEmpty
            ? widget.subCategoryName
            : selectedSubCategory2));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF8F9FB),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1E222B),
              size: 20,
            ),
          ),
        ),
        title: Column(
          children: [
            Text(
              selectedSubCategory2.isEmpty
                  ? widget.subCategoryName
                  : selectedSubCategory2,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lato',
                color: Color(0xFF1E222B),
              ),
            ),
            Text(
              productsAsync.when(
                data: (data) => '${data.content.length} items',
                loading: () => 'Loading...',
                error: (_, __) => '0 items',
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Lato',
                color: Color(0xFF8891A5),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.search, color: Color(0xFF1E222B)),
          // ),
        ],
      ),
      body: Row(
        children: [
          // Left subcategories2 panel
          Container(
            width: 86,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: categoriesAsync.when(
              data: (categoryResponse) {
                final category = categoryResponse!.categories.firstWhere(
                  (c) => c.name == widget.categoryName,
                  orElse: () => throw Exception('Category not found'),
                );
                final subCategory = category.subCategories.firstWhere(
                  (s) => s.name == widget.subCategoryName,
                  orElse: () => throw Exception('Subcategory not found'),
                );
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: subCategory.subCategories.length,
                  itemBuilder: (context, index) {
                    final subCategory2 = subCategory.subCategories[index];
                    return SubcategoryListItem(
                      name: subCategory2.name,
                      imageUrl: subCategory2.documentUrl,
                      isSelected: selectedSubCategory2 == subCategory2.name,
                      onTap: () => _onSubCategory2Selected(subCategory2),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error loading subcategories')),
            ),
          ),
          Container(width: 1, color: const Color(0xFFE5E7EB)),
          // Right products grid
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FB),
              padding: const EdgeInsets.all(12),
              child: productsAsync.when(
                data: (products) => MasonryGridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: products.content.length,
                  itemBuilder: (context, index) {
                    final product = products.content[index];
                    final variety = product.varieties.first;
                    return ProductCard(
                      isCardSmall: true,
                      id: variety.id,
                      name: product.name,
                      price: variety.discountPrice,
                      originalPrice: variety.price,
                      imageUrl: variety.imageUrls.isNotEmpty
                          ? variety.imageUrls.first
                          : 'assets/images/no_image.png',
                      discount: variety.discountPercent.round(),
                      unit: '${variety.value}${variety.unit}',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ProductDetailsOverlay(
                            product: product,
                          ),
                        );
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    const Center(child: Text('Error loading products')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
