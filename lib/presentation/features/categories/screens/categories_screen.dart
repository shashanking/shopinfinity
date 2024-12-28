import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/categories_data.dart';
import '../widgets/category_list_item.dart';
import '../widgets/subcategory_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          _buildCategoryList(),
          Container(
            width: 1,
            height: double.infinity,
            color: const Color(0xFFE5E7EB),
          ),
          _buildSubcategoriesSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF8F9FB),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1E222B),
            size: 20,
          ),
        ),
      ),
      title: const Text(
        'Categories',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Lato',
          color: Color(0xFF1E222B),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCategoryList() {
    return Container(
      width: 86,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: CategoriesData.categories.length,
        itemBuilder: (context, index) {
          return CategoryListItem(
            category: CategoriesData.categories[index],
            isSelected: selectedCategoryIndex == index,
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSubcategoriesSection() {
    final selectedCategory = CategoriesData.categories[selectedCategoryIndex];

    return Expanded(
      child: Container(
        color: const Color(0xFFF8F9FB),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCategory.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lato',
                color: Color(0xFF1E222B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: selectedCategory.subCategories.length,
                itemBuilder: (context, index) {
                  return SubcategoryGridItem(
                    subCategory: selectedCategory.subCategories[index],
                    categoryName: selectedCategory.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
