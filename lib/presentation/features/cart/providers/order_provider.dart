import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/create_order_request.dart';
import '../repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio: dio);
});

final createOrderProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, CreateOrderRequest>((ref, request) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.createOrder(request);
});
