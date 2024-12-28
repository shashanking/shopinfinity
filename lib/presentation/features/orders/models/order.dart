import 'order_item.dart';

class Order {
  final String id;
  final DateTime placedAt;
  final DateTime deliveredAt;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double itemTotal;
  final double deliveryCharge;
  final double totalBill;
  final double saving;
  final String status;

  const Order({
    required this.id,
    required this.placedAt,
    required this.deliveredAt,
    required this.deliveryAddress,
    required this.items,
    required this.itemTotal,
    required this.deliveryCharge,
    required this.totalBill,
    required this.saving,
    required this.status,
  });
}
