import '../models/category_model.dart';

class CategoriesData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: 'Grocery & Kitchen',
      imageUrl: 'assets/images/category_1.png',
      subCategories: [
        SubCategory(
          id: '1',
          name: 'Vegetables & Fruits',
          imageUrl: 'assets/images/tomato.png',
        ),
        SubCategory(
          id: '2',
          name: 'Atta, Rice & Dal',
          imageUrl: 'assets/images/category_2.png',
        ),
        SubCategory(
          id: '3',
          name: 'Oil, Ghee & Masala',
          imageUrl: 'assets/images/category_3.png',
        ),
      ],
    ),
    CategoryModel(
      id: '2',
      name: 'Snacks & Drinks',
      imageUrl: 'assets/images/category_big.png',
      subCategories: [
        SubCategory(
          id: '4',
          name: 'Dairy, Bread & Eggs',
          imageUrl: 'assets/images/category_big2.png',
        ),
        SubCategory(
          id: '5',
          name: 'Bakery & Biscuits',
          imageUrl: 'assets/images/category_1.png',
        ),
      ],
    ),
    CategoryModel(
      id: '3',
      name: 'Beauty & Personal Care',
      imageUrl: 'assets/images/category_2.png',
      subCategories: [
        SubCategory(
          id: '6',
          name: 'Chicken, Meat & Fish',
          imageUrl: 'assets/images/category_3.png',
        ),
      ],
    ),
    CategoryModel(
      id: '4',
      name: 'Household Essentials',
      imageUrl: 'assets/images/household1.png',
      subCategories: [
        SubCategory(
          id: '7',
          name: 'Gifts',
          imageUrl: 'assets/images/household2.png',
        ),
        SubCategory(
          id: '8',
          name: 'Kitchenware & Appliances',
          imageUrl: 'assets/images/category_big.png',
        ),
      ],
    ),
  ];
}
