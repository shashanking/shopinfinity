import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/core/theme/app_colors.dart';
import '../models/create_order_request.dart';
import '../providers/cart_provider.dart';
import '../providers/loading_state_provider.dart';
import '../providers/order_provider.dart';
import '../providers/selected_address_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);
    final selectedAddress = ref.watch(selectedAddressProvider);

    if (selectedAddress == null) {
      return const Scaffold(
        body: Center(
          child: Text('No delivery address selected'),
        ),
      );
    }

    return cartAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
      data: (cart) {
        if (cart == null) {
          return const Scaffold(
            body: Center(
              child: Text('No cart data available'),
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedAddress.addressName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${selectedAddress.addressLine1}, ${selectedAddress.landmark}, ${selectedAddress.city}, ${selectedAddress.state} - ${selectedAddress.pincode}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bill Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹${itemTotal.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Charge',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹25',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'To Pay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select Preferred Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _PaymentOption(
                  icon: Icons.money,
                  title: 'Cash on Delivery',
                  subtitle: 'Pay when your order arrives',
                  onTap: () {
                    context.go('/orders/success');
                  },
                ),
                // const SizedBox(height: 16),
                // _PaymentOption(
                //   icon: Icons.credit_card,
                //   title: 'Credit/Debit Card',
                //   subtitle: 'Add and secure your card as per RBI guidelines',
                //   onTap: () {},
                //   isEnabled: false,
                // ),
                // const SizedBox(height: 16),
                // _PaymentOption(
                //   icon: Icons.account_balance,
                //   title: 'UPI',
                //   subtitle: 'Pay using any UPI app',
                //   onTap: () {},
                //   isEnabled: false,
                // ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: totalAmount < 799 ? null : () async {
                // Prevent multiple taps
                if (ref.read(loadingStateProvider)) return;
                
                try {
                  // Set loading state
                  ref.read(loadingStateProvider.notifier).state = true;

                  // Create order request
                  final request = CreateOrderRequest(
                    paymentId: 'PICKUP_AT_SHOP',
                    boughtProductDetailsList: cartItems.map((item) => BoughtProductDetails(
                      varietyId: item.varietyId,
                      boughtQuantity: item.boughtQuantity,
                    )).toList(),
                    shippingInfo: ShippingInfo(id: selectedAddress.id),
                    paymentMode: 'PICKUP_AT_SHOP',
                  );

                  // Create order
                  final orderResponse = await ref.read(
                    createOrderProvider(request).future,
                  );

                  // Clear the cart after successful order
                  ref.invalidate(cartProvider);

                  if (mounted) {
                    // Reset loading state and navigate
                    Future.microtask(() {
                      ref.read(loadingStateProvider.notifier).state = false;
                      context.go('/orders/success');
                    });
                  }
                } catch (e) {
                  // Reset loading state
                  ref.read(loadingStateProvider.notifier).state = false;

                  // Show error
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceAll('Exception: ', ''),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: totalAmount < 799 ? Colors.grey : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final isLoading = ref.watch(loadingStateProvider);
                  
                  if (isLoading) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${cartItems.length} Item${cartItems.length > 1 ? 's' : ''} | ₹${totalAmount.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Place Order >',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (totalAmount < 799) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Minimum order amount is ₹799',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isEnabled;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? AppColors.primary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isEnabled ? AppColors.primary : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isEnabled ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isEnabled ? Colors.grey : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (isEnabled)
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
