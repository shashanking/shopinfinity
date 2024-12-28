import 'package:flutter/material.dart';

class RecentSearchChip extends StatelessWidget {
  final String label;

  const RecentSearchChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
              color: Color(0xFF1E222B),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.close,
            size: 16,
            color: Color(0xFF1E222B),
          ),
        ],
      ),
    );
  }
}
