import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/search_bar.dart';
import '../../product/widgets/product_details_overlay.dart';
import '../../categories/models/category_product.dart';
import '../widgets/section_title.dart';
import '../widgets/location_header.dart';
import '../models/category_item.dart';
import '../widgets/category_card.dart';

class ShopScreen extends StatelessWidget {
  static const List<CategoryItem> groceryCategories = [
    CategoryItem(
      name: 'Vegetables & Fruits',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Atta, Rice & Dal',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Oil, Ghee & Masala',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Dairy, Bread & Eggs',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Bakery & Biscuits',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Dry Fruits & Cereals',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Chicken, Meat & Fish',
      imageUrl: 'assets/images/category_1.png',
    ),
    CategoryItem(
      name: 'Kitchenware & Appliances',
      imageUrl: 'assets/images/category_1.png',
    ),
  ];

  static const List<CategoryItem> snacksCategories = [
    CategoryItem(
      name: 'Chips & Namkeen',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Sweets & Chocolates',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Drinks & Juices',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Tea & Coffee',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Instant Food',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Sauces & Spreads',
      imageUrl: 'assets/images/category_2.png',
    ),
    CategoryItem(
      name: 'Paan Corner',
      imageUrl: 'assets/images/category_big.png',
      isLarge: true,
    ),
  ];

  static const List<CategoryItem> beautyCategories = [
    CategoryItem(name: 'Skin Care', imageUrl: 'assets/images/category_3.png'),
    CategoryItem(name: 'Hair Care', imageUrl: 'assets/images/category_3.png'),
    CategoryItem(name: 'Make Up', imageUrl: 'assets/images/category_3.png'),
    CategoryItem(name: 'Fragrances', imageUrl: 'assets/images/category_3.png'),
    CategoryItem(
      name: 'Men\'s Grooming',
      imageUrl: 'assets/images/category_3.png',
    ),
    CategoryItem(name: 'Bath & Body', imageUrl: 'assets/images/category_3.png'),
    CategoryItem(
      name: 'Personal Care',
      imageUrl: 'assets/images/category_big2.png',
      isLarge: true,
    ),
  ];

  static const List<CategoryItem> householdCategories = [
    CategoryItem(
      name: 'Cleaning & Repellents',
      imageUrl: 'assets/images/household1.png',
      isLarge: true,
    ),
    CategoryItem(
      name: 'Stationery & Games',
      imageUrl: 'assets/images/household2.png',
      isLarge: true,
    ),
  ];

  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LocationHeader(),
              const CustomSearchBar(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset(
                  'assets/images/home_banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              _buildExclusiveProducts(),
              const SizedBox(height: 24),
              _buildBestSellingProducts(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Grocery & Kitchen'),
                    const SizedBox(height: 16),
                    _buildGroceryCategories(),
                    const SizedBox(height: 32),
                    const SectionTitle(title: 'Snacks & Drinks'),
                    const SizedBox(height: 16),
                    _buildSnacksCategories(context),
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/images/home_banner2.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                   const SizedBox(height: 32),
                    const SectionTitle(title: 'Beauty & Personal Care'),
                    const SizedBox(height: 16),
                    _buildBeautyCategories(context),
                    const SizedBox(height: 32),
                    const SectionTitle(title: 'Household Essentials'),
                    const SizedBox(height: 16),
                    _buildHouseholdCategories(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () => context.push('/categories'),
          backgroundColor: const Color(0xFF111827),
          shape: const CircleBorder(),
          tooltip: 'Categories',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/category.png', width: 24, height: 24),
              const SizedBox(height: 4),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroceryCategories() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.73,
        crossAxisSpacing: 12,
        mainAxisSpacing: 30,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groceryCategories.length,
      itemBuilder: (_, index) => CategoryCard(item: groceryCategories[index]),
    );
  }

  Widget _buildSnacksCategories(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return Wrap(
      spacing: spacing,
      runSpacing: 30,
      children: List.generate(snacksCategories.length, (index) {
        final item = snacksCategories[index];
        return SizedBox(
          width: item.isLarge ? (screenWidth - 44) / 2 : (screenWidth - 68) / 4,
          height: 120,
          child: CategoryCard(item: item),
        );
      }),
    );
  }

  Widget _buildBeautyCategories(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return Wrap(
      spacing: spacing,
      runSpacing: 30,
      children: List.generate(beautyCategories.length, (index) {
        final item = beautyCategories[index];
        return SizedBox(
          width: item.isLarge ? (screenWidth - 44) / 2 : (screenWidth - 68) / 4,
          height: 120,
          child: CategoryCard(item: item),
        );
      }),
    );
  }

  Widget _buildHouseholdCategories(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return Wrap(
      spacing: spacing,
      runSpacing: 30,
      children: List.generate(householdCategories.length, (index) {
        final item = householdCategories[index];
        return SizedBox(
          width: (screenWidth - 44) / 2, // All items are large
          height: 120,
          child: CategoryCard(item: item),
        );
      }),
    );
  }

  Widget _buildBestSellingProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Selling',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lato',
                  color: Color(0xFF1E222B),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                    color: Color(0xFF3669C9),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index != 4 ? 16 : 0),
                child: ProductCard(
                  imageUrl: 'assets/images/banana.png',
                  name: 'Best Seller ${index + 1}',
                  price: 42,
                  originalPrice: 58,
                  unit: '1kg',
                  discount: 20,
                  id: 'bestseller_${index + 1}',
                  isCardSmall: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ProductDetailsOverlay(
                        product: CategoryProduct(
                          id: 'bestseller_${index + 1}',
                          name: 'Best Seller ${index + 1}',
                          price: 42,
                          originalPrice: 58,
                          unit: '1kg',
                          discount: '20% OFF',
                          imageUrl: 'assets/images/banana.png',
                          category: 'Fruits',
                          subCategory: 'Fresh Fruits',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExclusiveProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exclusive Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lato',
                  color: Color(0xFF1E222B),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                    color: Color(0xFF3669C9),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index != 4 ? 16 : 0),
                child: ProductCard(
                  imageUrl: 'assets/images/banana.png',
                  name: 'Product ${index + 1}',
                  price: 42,
                  originalPrice: 58,
                  unit: '1kg',
                  discount: 20,
                  id: 'product_${index + 1}',
                  isCardSmall: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ProductDetailsOverlay(
                        product: CategoryProduct(
                          id: 'product_${index + 1}',
                          name: 'Product ${index + 1}',
                          price: 42,
                          originalPrice: 58,
                          unit: '1kg',
                          discount: '20% OFF',
                          imageUrl: 'assets/images/banana.png',
                          category: 'Fruits',
                          subCategory: 'Fresh Fruits',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
