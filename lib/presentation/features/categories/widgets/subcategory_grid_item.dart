import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/category_model.dart';

class SubcategoryGridItem extends StatelessWidget {
  final SubCategory subCategory;
  final String categoryName;

  const SubcategoryGridItem({
    super.key,
    required this.subCategory,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/category-products',
        extra: {
          'categoryName': categoryName,
          'subCategoryName': subCategory.name,
          'itemCount': '703',
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.asset(
                  subCategory.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                subCategory.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                  color: Color(0xFF1E222B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
