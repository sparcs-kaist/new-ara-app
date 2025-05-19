// lib/widgets/cafeteria_menu_section.dart
import 'package:flutter/material.dart';
import '../models/meal_allergen_model.dart';

class CafeteriaMenuSection extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final List<Allergen> allergens; // 추가

  const CafeteriaMenuSection({
    super.key,
    required this.items,
    required this.allergens, // 추가
  });

  @override
  State<CafeteriaMenuSection> createState() => _CafeteriaMenuSectionState();
}

class _CafeteriaMenuSectionState extends State<CafeteriaMenuSection> {
  Set<int> selectedIndices = {};

  int get totalSelectedPrice {
    return selectedIndices.fold(0, (sum, index) => 
      sum + (widget.items[index]['price'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndices.contains(index);
            final hasSelectedAllergy = widget.allergens
                .where((allergen) => allergen.selected)
                .any((allergen) => (item['allergens'] as List<int>).contains(allergen.id));

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedIndices.remove(index);
                  } else {
                    selectedIndices.add(index);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    if (hasSelectedAllergy) ...[
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 16,
                              color: hasSelectedAllergy ? Colors.red : (isSelected ? Colors.red : Colors.black),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${item['price']}원',
                            style: TextStyle(
                              fontSize: 16,
                              color: hasSelectedAllergy ? Colors.red : (isSelected ? Colors.red : Colors.black),
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total : ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                '${totalSelectedPrice}원',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}