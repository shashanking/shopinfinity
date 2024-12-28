import 'package:flutter/material.dart';

class FilterOverlay extends StatefulWidget {
  const FilterOverlay({super.key});

  @override
  State<FilterOverlay> createState() => _FilterOverlayState();
}

class _FilterOverlayState extends State<FilterOverlay> {
  final Set<String> selectedBrands = {};
  final List<String> brands = [
    'Garnier',
    'Ponds',
    'Mama Earth',
    'MCaffeine',
    'Dove',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[200]),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: ListView(
                    children: [
                      _buildFilterCategory('Brands', isSelected: true),
                      // _buildFilterCategory('Price'),
                      // _buildFilterCategory('Rating'),
                      // _buildFilterCategory('Discount'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...brands.map(
                        (brand) => CheckboxListTile(
                          title: Text(brand),
                          value: selectedBrands.contains(brand),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedBrands.add(brand);
                              } else {
                                selectedBrands.remove(brand);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedBrands.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters and close overlay
                      Navigator.pop(context, selectedBrands.toList());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(String title, {bool isSelected = false}) {
    return Container(
      // color: isSelected ? Colors.white : null,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.green[200]!, width: 2)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
      ),
    );
  }
}
