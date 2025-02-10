class OrderItem {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String weight;
  final String image;
  final int quantity;

  const OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.weight,
    required this.image,
    required this.quantity,
  });
}
