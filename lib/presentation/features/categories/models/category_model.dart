class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<SubCategory> subCategories;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.subCategories,
  });
}

class SubCategory {
  final String id;
  final String name;
  final String imageUrl;

  const SubCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
