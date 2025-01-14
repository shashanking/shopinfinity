import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopinfinity/presentation/features/orders/models/order_response.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/order_item.dart' as display;
import '../providers/orders_provider.dart';
import '../widgets/order_info_card.dart';
import '../widgets/order_product_card.dart';
import '../widgets/bill_summary_card.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  display.OrderItem _convertOrderItem(OrderItem item) {
    return display.OrderItem(
      id: item.varietyId,
      name: item.name,
      price: item.discountedPrice,
      originalPrice: item.price,
      weight: '${item.value}${item.unit}',
      image: item.documents.isNotEmpty
          ? item.documents.first
          : 'assets/images/placeholder.png',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return orderAsync.when(
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
      data: (order) {
        if (order == null) {
          return const Scaffold(
            body: Center(
              child: Text('Order not found'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF111827)),
              onPressed: () => context.pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  'Placed on ${order.createdAt.toLocal().day}/${order.createdAt.toLocal().month}/${order.createdAt.toLocal().year} at ${order.createdAt.toLocal().hour}:${order.createdAt.toLocal().minute}',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.orderStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  OrderInfoCard(
                    deliveryTime: order.createdAt,
                    address:
                        '${order.shippingInfo.addressLine1},${order.shippingInfo.addressLine2.toString().isEmpty ? '' : order.shippingInfo.addressLine2}${order.shippingInfo.addressLine2.toString().isEmpty ? '' : ','} ${order.shippingInfo.city}, ${order.shippingInfo.state} - ${order.shippingInfo.pincode}',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ...order.boughtProductDetailsList.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child:
                                OrderProductCard(item: _convertOrderItem(item)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        BillSummaryCard(
                          itemTotal: order.totalItemCost,
                          deliveryCharge: order.deliveryCharges,
                          totalBill: order.totalCost,
                          saving: order.boughtProductDetailsList.fold(
                            0.0,
                            (sum, item) => sum + item.savings,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
