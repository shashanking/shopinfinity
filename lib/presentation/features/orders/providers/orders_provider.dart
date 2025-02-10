import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/order_response.dart';
import '../repositories/orders_repository.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrdersRepository(dio: dio);
});

final ordersProvider =
    AsyncNotifierProvider<OrdersNotifier, OrderListResponse?>(() {
  return OrdersNotifier();
});

final orderDetailsProvider =
    Provider.family<AsyncValue<OrderResponse?>, String>((ref, orderId) {
  final ordersAsync = ref.watch(ordersProvider);

  return ordersAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (orders) {
      if (orders == null) return const AsyncValue.data(null);
      try {
        final order = orders.content.firstWhere(
          (order) => order.id == orderId,
        );
        return AsyncValue.data(order);
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
  );
});

class OrdersNotifier extends AsyncNotifier<OrderListResponse?> {
  @override
  Future<OrderListResponse?> build() async {
    return _fetchOrders();
  }

  Future<OrderListResponse?> _fetchOrders() async {
    final repository = ref.read(ordersRepositoryProvider);
    try {
      final orders = await repository.fetchOrders();

      // Sort orders by creation date in descending order (latest first)
      if (orders.content.isNotEmpty) {
        final sortedOrders = List<OrderResponse>.from(orders.content)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return OrderListResponse(
          perPage: orders.perPage,
          pageNo: orders.pageNo,
          sortBy: orders.sortBy,
          sortDirection: orders.sortDirection,
          content: sortedOrders,
          count: orders.count,
        );
      }

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
