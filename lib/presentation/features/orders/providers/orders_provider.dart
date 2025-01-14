import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/order_response.dart';
import '../repositories/orders_repository.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrdersRepository(dio: dio);
});

final ordersProvider = AsyncNotifierProvider<OrdersNotifier, OrderResponse?>(() {
  return OrdersNotifier();
});

final orderDetailsProvider = Provider.family<AsyncValue<Order?>, String>((ref, orderId) {
  final ordersAsync = ref.watch(ordersProvider);
  
  return ordersAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (orders) {
      if (orders == null) return const AsyncValue.data(null);
      final order = orders.content.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('Order not found'),
      );
      return AsyncValue.data(order);
    },
  );
});

class OrdersNotifier extends AsyncNotifier<OrderResponse?> {
  @override
  Future<OrderResponse?> build() async {
    return _fetchOrders();
  }

  Future<OrderResponse?> _fetchOrders() async {
    final repository = ref.read(ordersRepositoryProvider);
    try {
      final orders = await repository.fetchOrders();
      return orders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final orders = await _fetchOrders();
      state = AsyncValue.data(orders);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
