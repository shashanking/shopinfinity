import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: 24, color: Color(0xFF374151)),
            SizedBox(width: 12),
            Text(
              'Search Products or store',
              style: TextStyle(
                color: Color(0xFF8891A5),
                fontSize: 14,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
