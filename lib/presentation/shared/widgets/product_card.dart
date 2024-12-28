import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopinfinity/core/theme/app_colors.dart';
import 'package:shopinfinity/presentation/features/cart/models/cart_item.dart';
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
                      top: isCardSmall ? 24.0 : 30.0,
                      bottom: isCardSmall ? 2.0 : 4.0,
                    ),
                    child: Image.asset(imageUrl,
                        height: isCardSmall ? 70 : 90, fit: BoxFit.contain),
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
                            GestureDetector(
                              onTap: () {
                                final cartItem = CartItem(
                                  id: id,
                                  name: name,
                                  imageUrl: imageUrl,
                                  price: price,
                                  originalPrice: originalPrice,
                                  weight: unit,
                                  quantity: 1,
                                );
                                ref
                                    .read(cartProvider.notifier)
                                    .addItem(cartItem);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to cart'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: isCardSmall
                                  ? CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.iconPrimary,
                                      child: Image.asset(
                                        'assets/icons/shopping_bag.png',
                                        height: 18,
                                        width: 18,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.iconPrimary,
                                      child: Image.asset(
                                        'assets/icons/shopping_bag.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
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
