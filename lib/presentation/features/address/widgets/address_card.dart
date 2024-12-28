import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../cart/models/delivery_address.dart';
import '../../cart/providers/address_provider.dart';

class AddressCard extends ConsumerWidget {
  final DeliveryAddress address;
  final bool showDivider;

  const AddressCard({
    super.key,
    required this.address,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullAddress = '${address.landmark}, ${address.address}, ${address.city}, ${address.state} - ${address.pincode}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.label.substring(0, 1).toUpperCase() + address.label.substring(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fullAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF6B7280),
                onPressed: () {
                  context.go('/addresses/edit/${address.id}', extra: address);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: const Color(0xFFEF4444),
                onPressed: () {
                  ref.read(addressProvider.notifier).removeAddress(address.id);
                },
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),
      ],
    );
  }
}
