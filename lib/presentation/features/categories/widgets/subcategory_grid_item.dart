import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/category/category_response.dart';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF8F9FB),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    subCategory.documentUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subCategory.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                      color: Color(0xFF1E222B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '703 items',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                      color: Color(0xFF616A7D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
