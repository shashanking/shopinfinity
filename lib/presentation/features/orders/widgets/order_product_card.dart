import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/order_item.dart';

class OrderProductCard extends StatelessWidget {
  final OrderItem item;

  const OrderProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.image.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: item.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    item.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  item.weight,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF97316),
                ),
              ),
              Text(
                '₹${item.originalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
