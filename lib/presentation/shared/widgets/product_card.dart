import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopinfinity/core/theme/app_colors.dart';
import 'package:shopinfinity/presentation/features/cart/providers/cart_provider.dart';

class ProductCard extends ConsumerWidget {
  final String name;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final int discount;
  final String unit;
  final String id;
  final VoidCallback? onTap;
  final bool isCardSmall;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.discount,
    required this.unit,
    required this.id,
    this.onTap,
    this.isCardSmall = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final isLoading = ref.watch(productLoadingProvider(id));

    // Check if item is in cart and get its quantity
    final cartItem = cartAsync.valueOrNull?.boughtProductDetailsList
        .where((item) => item.varietyId == id)
        .firstOrNull;
    final isInCart = cartItem != null;
    final currentQuantity = cartItem?.boughtQuantity ?? 0;
    final isMaxQuantity = currentQuantity >= 50; // Maximum allowed quantity

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: isCardSmall ? null : double.infinity,
          constraints: BoxConstraints(
            maxWidth: isCardSmall ? 160 : double.infinity,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (discount > 0)
                Positioned(
                  top: -1,
                  left: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF7CBD91),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      '$discount% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: isCardSmall ? 40.0 : 30.0,
                      bottom: isCardSmall ? 2.0 : 4.0,
                    ),
                    child: imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: isCardSmall ? 70 : 90,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                              height: isCardSmall ? 70 : 90,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              height: isCardSmall ? 70 : 90,
                              child: const Center(
                                child: Icon(Icons.error_outline),
                              ),
                            ),
                          )
                        : Image.asset(
                            imageUrl,
                            height: isCardSmall ? 70 : 90,
                            fit: BoxFit.contain,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: isCardSmall ? 8.0 : 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flex(
                              direction:
                                  isCardSmall ? Axis.vertical : Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unit,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${price.toInt()} ',
                                      style: TextStyle(
                                        fontSize: isCardSmall ? 11 : 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (originalPrice > price)
                                      Text(
                                        '₹${originalPrice.toInt()}',
                                        style: TextStyle(
                                          fontSize: isCardSmall ? 11 : 12,
                                          color: Colors.grey[600],
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: (isLoading || isMaxQuantity)
                                      ? null
                                      : () async {
                                          try {
                                            final newQuantity = isInCart
                                                ? currentQuantity + 1
                                                : 1;
                                            await ref
                                                .read(cartProvider.notifier)
                                                .updateCart(
                                                  varietyId: id,
                                                  quantity: newQuantity,
                                                );
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    isInCart
                                                        ? 'Updated quantity in cart'
                                                        : 'Added to cart',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  backgroundColor:
                                                      AppColors.primary,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to update cart: ${e.toString()}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  child: isCardSmall
                                      ? CircleAvatar(
                                          radius: 16,
                                          backgroundColor: isMaxQuantity
                                              ? Colors.grey
                                              : AppColors.iconPrimary,
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 14,
                                                  width: 14,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : isMaxQuantity
                                                  ? const Icon(
                                                      Icons.check,
                                                      size: 18,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .add_shopping_cart_rounded,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isMaxQuantity
                                                ? Colors.grey
                                                : AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 14,
                                                  width: 14,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  isMaxQuantity
                                                      ? 'Max Qty'
                                                      : isInCart
                                                          ? 'Add More'
                                                          : 'Add',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
