import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

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
  late String selectedSubCategory;

  @override
  void initState() {
    super.initState();
    selectedSubCategory = widget.subCategoryName;
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync =
        ref.watch(categoryProductsProvider(selectedSubCategory));
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
              selectedSubCategory,
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
                loading: () => '${widget.itemCount} items',
                error: (_, __) => '${widget.itemCount} items',
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Color(0xFF1E222B)),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left subcategories panel
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
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: category.subCategories.length,
                  itemBuilder: (context, index) {
                    final subCategory = category.subCategories[index];
                    return SubcategoryListItem(
                      name: subCategory.name,
                      imageUrl: subCategory.documentUrl,
                      isSelected: selectedSubCategory == subCategory.name,
                      onTap: () {
                        setState(() {
                          selectedSubCategory = subCategory.name;
                        });
                      },
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
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: products.content.length,
                  itemBuilder: (context, index) {
                    final product = products.content[index];
                    return ProductCard(
                      isCardSmall: true,
                      id: product.id,
                      name: product.name,
                      price: product.varieties.first.discountPrice,
                      originalPrice: product.varieties.first.price,
                      imageUrl: product.varieties.first.imageUrls.first,
                      discount: product.varieties.first.discountPercent.round(),
                      unit:
                          '${product.varieties.first.value}${product.varieties.first.unit}',
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
