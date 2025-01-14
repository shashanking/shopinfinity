import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/search_bar.dart';
import '../widgets/exclusive_products_grid.dart';
import '../widgets/best_seller_products_grid.dart';
import '../widgets/section_title.dart';
import '../widgets/location_header.dart';
import '../models/category_item.dart';
import '../widgets/category_card.dart';
import '../providers/exclusive_products_provider.dart';
import '../providers/categories_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

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
              _buildExclusiveProducts(ref),
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
                    _buildGroceryCategories(ref),
                    const SizedBox(height: 32),
                    const SectionTitle(title: 'Snacks & Drinks'),
                    const SizedBox(height: 16),
                    _buildSnacksCategories(context, ref),
                    const SizedBox(height: 24),
                    Image.asset(
                      'assets/images/home_banner2.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 32),
                    const SectionTitle(title: 'Beauty & Personal Care'),
                    const SizedBox(height: 16),
                    _buildBeautyCategories(context, ref),
                    const SizedBox(height: 32),
                    const SectionTitle(title: 'Household Essentials'),
                    const SizedBox(height: 16),
                    _buildHouseholdCategories(context, ref),
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

  Widget _buildGroceryCategories(WidgetRef ref) {
    return ref.watch(categoriesProvider).when(
          data: (categoryResponse) {
            if (categoryResponse == null) return const SizedBox();

            final groceryCategory = categoryResponse.categories
                .firstWhere((cat) => cat.name == 'Grocery & Kitchen');

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.73,
                crossAxisSpacing: 12,
                mainAxisSpacing: 30,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groceryCategory.subCategories.length,
              itemBuilder: (_, index) => CategoryCard(
                item: CategoryItem(
                  name: groceryCategory.subCategories[index].name,
                  imageUrl: groceryCategory.subCategories[index].documentUrl,
                  isLarge: false,
                ),
                categoryName: groceryCategory.name,
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        );
  }

  Widget _buildSnacksCategories(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return ref.watch(categoriesProvider).when(
          data: (categoryResponse) {
            if (categoryResponse == null) return const SizedBox();

            final snacksCategory = categoryResponse.categories
                .firstWhere((cat) => cat.name == 'Snacks & Drinks');

            return Wrap(
              spacing: spacing,
              runSpacing: 30,
              children:
                  List.generate(snacksCategory.subCategories.length, (index) {
                final subCategory = snacksCategory.subCategories[index];
                final isLarge =
                    subCategory.name.toLowerCase().contains('paan corner');
                return SizedBox(
                  width:
                      isLarge ? (screenWidth - 44) / 2 : (screenWidth - 68) / 4,
                  height: 120,
                  child: CategoryCard(
                    item: CategoryItem(
                      name: subCategory.name,
                      imageUrl: subCategory.documentUrl,
                      isLarge: isLarge,
                    ),
                    categoryName: snacksCategory.name,
                  ),
                );
              }),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        );
  }

  Widget _buildBeautyCategories(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return ref.watch(categoriesProvider).when(
          data: (categoryResponse) {
            if (categoryResponse == null) return const SizedBox();

            final beautyCategory = categoryResponse.categories
                .firstWhere((cat) => cat.name == 'Beauty & Personal Care');

            return Wrap(
              spacing: spacing,
              runSpacing: 30,
              children:
                  List.generate(beautyCategory.subCategories.length, (index) {
                final subCategory = beautyCategory.subCategories[index];
                final isLarge =
                    subCategory.name.toLowerCase().contains('personal care');
                return SizedBox(
                  width:
                      isLarge ? (screenWidth - 44) / 2 : (screenWidth - 68) / 4,
                  height: 120,
                  child: CategoryCard(
                    item: CategoryItem(
                      name: subCategory.name,
                      imageUrl: subCategory.documentUrl,
                      isLarge: isLarge,
                    ),
                    categoryName: beautyCategory.name,
                  ),
                );
              }),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        );
  }

  Widget _buildHouseholdCategories(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02;

    return ref.watch(categoriesProvider).when(
          data: (categoryResponse) {
            if (categoryResponse == null) return const SizedBox();

            final householdCategory = categoryResponse.categories
                .firstWhere((cat) => cat.name == 'Household Essentials');

            return Wrap(
              spacing: spacing,
              runSpacing: 30,
              children:
                  List.generate(householdCategory.subCategories.length, (index) {
                final subCategory = householdCategory.subCategories[index];
                return SizedBox(
                  width: (screenWidth - 44) / 2, // All items are large with double width
                  height: 120,
                  child: CategoryCard(
                    item: CategoryItem(
                      name: subCategory.name,
                      imageUrl: subCategory.documentUrl,
                      isLarge: true, // Set all items to large
                    ),
                    categoryName: householdCategory.name,
                  ),
                );
              }),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        );
  }

  Widget _buildBestSellingProducts() {
    return const SizedBox(
      child: BestSellerProductsGrid(),
    );
  }

  Widget _buildExclusiveProducts(WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final productsAsyncValue = ref.watch(exclusiveProductsProvider);

        return productsAsyncValue.when(
          data: (products) {
            if (products == null) {
              return const SizedBox();
            }

            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: ExclusiveProductsGrid(),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        );
      },
    );
  }
}
