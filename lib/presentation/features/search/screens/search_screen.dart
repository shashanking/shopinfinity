import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/recent_search_chip.dart';
import '../../../shared/widgets/product_card.dart';
import '../../product/widgets/product_details_overlay.dart';
import '../../categories/models/category_product.dart';
import '../overlays/filter_overlay.dart'; // Add this import

class SearchScreen extends StatelessWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
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
                      controller: TextEditingController(text: initialQuery),
                      autofocus: true,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                      color: Color(0xFF1E222B),
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      RecentSearchChip(label: 'Cat Food'),
                      RecentSearchChip(label: 'Cat Food'),
                      RecentSearchChip(label: 'Cat Food'),
                      RecentSearchChip(label: 'Cat Food'),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing Results for Product Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          color: Color(0xFF1E222B),
                        ),
                      ),
                      Text(
                        '246 items',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lato',
                          color: Color(0xFF8891A5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final product = CategoryProduct(
                    imageUrl: 'assets/images/tomato.png',
                    name: 'Desi Tomato\n(Nattu Thakkali)',
                    price: 42,
                    originalPrice: 58,
                    unit: '1kg',
                    discount: '20% OFF',
                    id: index.toString(),
                    category: 'Vegetables',
                    subCategory: 'Fresh Vegetables',
                  );
                  return ProductCard(
                    imageUrl: product.imageUrl,
                    name: product.name,
                    price: product.price,
                    originalPrice: product.originalPrice!,
                    unit: product.unit,
                    discount: int.parse(
                      product.discount?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
                    ),
                    id: product.id,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ProductDetailsOverlay(product: product),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
