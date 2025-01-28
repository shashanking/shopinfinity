import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/product/product.dart';
import '../../../shared/widgets/product_card.dart';
import '../../product/widgets/product_details_overlay.dart';
import '../providers/exclusive_products_provider.dart';

class ExclusiveProductsScreen extends ConsumerStatefulWidget {
  const ExclusiveProductsScreen({super.key});

  @override
  ConsumerState<ExclusiveProductsScreen> createState() =>
      _ExclusiveProductsScreenState();
}

class _ExclusiveProductsScreenState
    extends ConsumerState<ExclusiveProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(allExclusiveProductsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(allExclusiveProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Exclusive Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: productsState.when(
        data: (products) => _buildProductGrid(products.content),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading products: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
      ],
    );
  }
}
