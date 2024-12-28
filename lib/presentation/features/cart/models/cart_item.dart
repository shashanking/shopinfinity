class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final String weight;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.weight,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    String? weight,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
    );
  }
}
