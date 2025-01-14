import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/core/theme/app_colors.dart';
import '../models/cart_response.dart';
import '../overlays/add_address_overlay.dart';
import '../overlays/select_address_overlay.dart';
import '../providers/cart_provider.dart';
import '../providers/selected_address_provider.dart';
import '../../profile/providers/address_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final addressAsync = ref.watch(addressProvider);

    return cartAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E222B),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(cartProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (cart) {
        if (cart == null || cart.boughtProductDetailsList.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                'Cart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E222B),
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add items to start shopping',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/shop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 210, 221, 249),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(color: Color(0xFF2A4BA0)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final cartItems = cart.boughtProductDetailsList;
        final itemTotal = cartItems.fold(
          0.0,
          (sum, item) => sum + item.boughtPrice,
        );
        const deliveryCharge = 25.0;
        final totalAmount = itemTotal + deliveryCharge;
        final saving = cartItems.fold(
          0.0,
          (sum, item) => sum + item.savings,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => context.pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shopping Cart (${cartItems.length})',
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${cartItems.length} Item | Total ₹${totalAmount.toStringAsFixed(2)}',
                  style:
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItem(
                      item: item,
                      onIncrement: () =>
                          ref.read(cartProvider.notifier).updateCart(
                                varietyId: item.varietyId,
                                quantity: item.boughtQuantity + 1,
                              ),
                      onDecrement: () =>
                          ref.read(cartProvider.notifier).updateCart(
                                varietyId: item.varietyId,
                                quantity: item.boughtQuantity - 1,
                              ),
                      onRemove: () =>
                          ref.read(cartProvider.notifier).updateCart(
                                varietyId: item.varietyId,
                                quantity: 0,
                              ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bill Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Item Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '₹${itemTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Charge',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '₹${deliveryCharge.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    if (saving > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Savings',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF059669),
                            ),
                          ),
                          Text(
                            '₹${saving.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'To Pay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    addressAsync.when(
                      data: (addressData) {
                        if (addressData == null ||
                            addressData.content.isEmpty) {
                          return TextButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AddAddressOverlay(),
                              );
                            },
                            icon: const Icon(Icons.add_location_outlined),
                            label: const Text('Add Delivery Address'),
                          );
                        }

                        final selectedAddress =
                            ref.watch(selectedAddressProvider);
                        if (selectedAddress == null)
                          return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 20, color: Color(0xFF6B7280)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${selectedAddress.addressLine1}, ${selectedAddress.landmark}, ${selectedAddress.city}, ${selectedAddress.state} - ${selectedAddress.pincode}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          const SelectAddressOverlay(),
                                    );
                                  },
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => TextButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddAddressOverlay(),
                          );
                        },
                        icon: const Icon(Icons.add_location_outlined),
                        label: const Text('Add Delivery Address'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedAddress =
                              ref.read(selectedAddressProvider);
                          if (selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please select a delivery address'),
                              ),
                            );
                            return;
                          }
                          context.push('/cart/payment');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem({
    required BoughtProductDetails item,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.documents.isNotEmpty ? item.documents.first : '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value + item.unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.boughtPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.savings > 0)
                      Text(
                        '₹${(item.boughtPrice + item.savings).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(
                      icon: Icons.add,
                      onPressed: onIncrement,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.boughtQuantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildIconButton(
                      icon: Icons.remove,
                      onPressed: onDecrement,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // TextButton(
                //   onPressed: onRemove,
                //   child: const Text(
                //     'Remove',
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Color(0xFFDC2626),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          // color: const Color(0xFF10B981).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
