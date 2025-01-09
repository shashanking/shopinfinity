import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/presentation/features/shop/providers/exclusive_products_provider.dart';

import '../../../shared/widgets/product_card.dart';
import '../../categories/models/category_product.dart';
import '../../product/widgets/product_details_overlay.dart';

class ExclusiveProductsGrid extends ConsumerWidget {
  const ExclusiveProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exclusiveProductsState = ref.watch(exclusiveProductsProvider);

    return exclusiveProductsState.when(
      data: (productResponse) {
        if (productResponse == null || 
            productResponse.content.isEmpty) {
          return const Center(child: Text('No exclusive products found'));
        }

        final products = productResponse.content.take(20).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Exclusive Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                      color: Color(0xFF1E222B),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                        color: Color(0xFF3669C9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (product.varieties.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final variety = product.varieties.first;

                  return Padding(
                    padding: EdgeInsets.only(right: index != products.length - 1 ? 16 : 0),
                    child: ProductCard(
                      imageUrl: variety.imageUrls.isNotEmpty
                          ? variety.imageUrls.first
                          : 'assets/images/banana.png',
                      name: product.name,
                      price: variety.discountPrice,
                      originalPrice: variety.price,
                      unit: '${variety.value} ${variety.unit}',
                      discount: variety.discountPercent.toInt(),
                      id: product.id,
                      isCardSmall: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ProductDetailsOverlay(
                            product: CategoryProduct(
                              id: product.id,
                              name: product.name,
                              price: variety.discountPrice,
                              originalPrice: variety.price,
                              unit: '${variety.value} ${variety.unit}',
                              discount: '${variety.discountPercent}% OFF',
                              imageUrl: variety.imageUrls.isNotEmpty
                                  ? variety.imageUrls.first
                                  : 'assets/images/banana.png',
                              category: product.category,
                              subCategory: product.subCategory,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
