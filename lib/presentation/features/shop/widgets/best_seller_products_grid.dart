import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/product_mapper.dart';
import '../../../shared/widgets/product_card.dart';
import '../../product/widgets/product_details_overlay.dart';
import '../providers/best_seller_products_provider.dart';

class BestSellerProductsGrid extends ConsumerWidget {
  const BestSellerProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestSellerProductsState = ref.watch(bestSellerProductsProvider);

    return bestSellerProductsState.when(
      data: (productResponse) {
        if (productResponse.content.isEmpty) {
          return const Center(child: Text('No best seller products found'));
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
                    'Best Selling',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/best-seller-products');
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (product.varieties.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final variety = product.varieties.first;

                  return Padding(
                    padding: EdgeInsets.only(
                        right: index != products.length - 1 ? 16 : 0),
                    child: SizedBox(
                      width: 180,
                      child: ProductCard(
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
                              product: mapToUiProduct(product),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error loading best seller products: $error'),
      ),
    );
  }
}
