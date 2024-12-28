import 'package:go_router/go_router.dart';
import '../screens/my_orders_screen.dart';
import '../screens/order_details_screen.dart';
import '../models/order.dart';
import '../models/order_item.dart';

final ordersRoutes = [
  GoRoute(
    path: '/orders',
    builder: (context, state) => const MyOrdersScreen(),
  ),
  GoRoute(
    path: '/orders/:id',
    builder: (context, state) {
      final orderId = state.pathParameters['id']!;
      final order = Order(
        id: orderId,
        placedAt: DateTime(2024, 3, 7, 21, 12),
        deliveredAt: DateTime(2024, 3, 7, 21, 12),
        deliveryAddress: 'No. 46, 1st floor, near police',
        items: [
          const OrderItem(
            id: '1',
            name: 'Cadbury Bournville Rich Cocoa 70% Dark',
            price: 42,
            originalPrice: 58,
            weight: '200g',
            image: 'assets/images/chocolate.png',
          ),
          const OrderItem(
            id: '2',
            name: 'Cadbury Bournville Rich Cocoa 70% Dark',
            price: 42,
            originalPrice: 58,
            weight: '200g',
            image: 'assets/images/chocolate.png',
          ),
        ],
        itemTotal: 33,
        deliveryCharge: 25,
        totalBill: 87.49,
        saving: 9.51,
        status: 'Delivered',
      );
      return OrderDetailsScreen(order: order);
    },
  ),
];
