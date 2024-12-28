import 'package:flutter/material.dart';
import '../models/category_item.dart';

class CategoryCard extends StatelessWidget {
  static const double _cardHeight = 80;
  static const double _regularWidth = 80;
  static const double _largeWidth = 170;
  static const double _borderRadius = 16;
  static const double _imagePadding = 12;

  final CategoryItem item;

  const CategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: _cardHeight,
          width: item.isLarge ? _largeWidth : _regularWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Padding(
              padding: const EdgeInsets.all(_imagePadding),
              child: Image.asset(item.imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: item.isLarge ? _largeWidth : _regularWidth,
          child: Text(
            item.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lato',
            ),
          ),
        ),
      ],
    );
  }
}
