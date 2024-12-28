import 'package:flutter/material.dart';
import '../../categories/models/category_product.dart';

class ProductDetailsOverlay extends StatefulWidget {
  final CategoryProduct product;

  const ProductDetailsOverlay({super.key, required this.product});

  @override
  State<ProductDetailsOverlay> createState() => _ProductDetailsOverlayState();
}

class _ProductDetailsOverlayState extends State<ProductDetailsOverlay> {
  int selectedUnit = 0;
  bool isDescriptionExpanded = false;
  final List<Map<String, dynamic>> units = [
    {'weight': '1 kg', 'price': 42, 'originalPrice': 58},
    {'weight': '2 kg', 'price': 84, 'originalPrice': 116},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Semi-transparent background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Content
          DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with close button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.product.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF1E222B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Product image and thumbnails
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: const BoxDecoration(color: Colors.white),
                                  padding: const EdgeInsets.all(24),
                                  child: Image.asset(
                                    widget.product.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                if (widget.product.discount != null)
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF5EC985),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        widget.product.discount!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Container(
                              color: Colors.white,
                              height: 80,
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE5E7EB)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        widget.product.imageUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Product details
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select Unit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                      color: Color(0xFF1E222B),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Unit selection
                                  Row(
                                    children: List.generate(
                                      units.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedUnit = index;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 12),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: selectedUnit == index
                                                ? const Color(0xFFE8FFF0)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: selectedUnit == index
                                                  ? const Color(0xFF5EC985)
                                                  : Colors.white,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                units[index]['weight'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Lato',
                                                  color: Color(0xFF1E222B),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹${units[index]['price']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Lato',
                                                      color: Color(0xFF1E222B),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '₹${units[index]['originalPrice']}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: 'Lato',
                                                      decoration: TextDecoration.lineThrough,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Product description
                                  const Text(
                                    'Product Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                      color: Color(0xFF1E222B),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Lorem ipsum dolor sit amet consectetur. Vulutpat arcu vitae tellus in dui mattis cursus lacus. Amet nisl a urna arcu senectus viverra congue adipiscing. Viverra in natoque nec feugiat. Elit laoreet amet enim nulla euismod mattis augue.',
                                    maxLines: isDescriptionExpanded ? null : 2,
                                    overflow: isDescriptionExpanded ? null : TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Lato',
                                      color: Color(0xFF8891A5),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDescriptionExpanded = !isDescriptionExpanded;
                                      });
                                    },
                                    child: Text(
                                      isDescriptionExpanded ? 'View less' : 'View more',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF5EC985),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  units[selectedUnit]['weight'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Lato',
                                    color: Color(0xFF8891A5),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '₹${units[selectedUnit]['price']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF1E222B),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${units[selectedUnit]['originalPrice']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Lato',
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A4BA0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Lato',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
