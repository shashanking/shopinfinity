import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/product_card.dart';
import '../constants/categories_data.dart';
import '../constants/category_products_data.dart';
import '../widgets/subcategory_list_item.dart';
import '../../product/widgets/product_details_overlay.dart';

class CategoryProductsScreen extends StatefulWidget {
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
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late String selectedSubCategory;

  @override
  void initState() {
    super.initState();
    selectedSubCategory = widget.subCategoryName;
  }

  @override
  Widget build(BuildContext context) {
    final category = CategoriesData.categories.firstWhere(
      (c) => c.name == widget.categoryName,
    );
    final products = CategoryProductsData.products[selectedSubCategory] ?? [];

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
              '${widget.itemCount} items',
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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: category.subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = category.subCategories[index];
                return SubcategoryListItem(
                  name: subCategory.name,
                  imageUrl: subCategory.imageUrl,
                  isSelected: selectedSubCategory == subCategory.name,
                  onTap: () {
                    setState(() {
                      selectedSubCategory = subCategory.name;
                    });
                  },
                );
              },
            ),
          ),
          Container(width: 1, color: const Color(0xFFE5E7EB)),
          // Right products grid
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FB),
              padding: const EdgeInsets.all(12),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    isCardSmall: true,
                    imageUrl: product.imageUrl,
                    name: product.name,
                    price: product.price,
                    originalPrice: product.originalPrice!,
                    unit: product.unit,
                    discount: int.parse(
                      product.discount?.replaceAll(RegExp(r'[^0-9]'), '') ??
                          '0',
                    ),
                    id: product.id,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            ProductDetailsOverlay(product: product),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
