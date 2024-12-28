class CategoryProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String unit;
  final String? discount;
  final String category;
  final String subCategory;

  const CategoryProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.unit,
    this.discount,
    required this.category,
    required this.subCategory,
  });
}
