import 'package:flutter/material.dart';
import '../../../../core/models/category/category_response.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          border: Border(
            right: BorderSide(
              color: isSelected ? const Color(0xFF2A4BA0) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  category.documentUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                height: 1.2,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Lato',
                color: isSelected
                    ? const Color(0xFF2A4BA0)
                    : const Color(0xFF1E222B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
