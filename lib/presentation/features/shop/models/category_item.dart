class CategoryItem {
  final String name;
  final String imageUrl;
  final bool isLarge;

  const CategoryItem({
    required this.name,
    required this.imageUrl,
    this.isLarge = false,
  });
}
