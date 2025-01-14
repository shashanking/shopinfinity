import 'package:go_router/go_router.dart';
import '../screens/my_orders_screen.dart';
import '../screens/order_details_screen.dart';
import '../../cart/screens/order_success_screen.dart';

final ordersRoutes = [
  GoRoute(
    path: '/orders',
    builder: (context, state) => const MyOrdersScreen(),
  ),
  GoRoute(
    path: '/orders/success',
    builder: (context, state) => const OrderSuccessScreen(),
  ),
  GoRoute(
    path: '/orders/:id',
    builder: (context, state) {
      final orderId = state.pathParameters['id']!;
      return OrderDetailsScreen(orderId: orderId);
    },
  ),
];
