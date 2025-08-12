import 'package:flutter/material.dart';
import '../models/meal_allergen_model.dart';

class AllergyFilterDialog extends StatefulWidget {
  final List<Allergen> allergens;
  final Function(List<Allergen>) onAllergyChange;

  const AllergyFilterDialog({
    Key? key,
    required this.allergens,
    required this.onAllergyChange,
  }) : super(key: key);

  @override
  State<AllergyFilterDialog> createState() => _AllergyFilterDialogState();
}

class _AllergyFilterDialogState extends State<AllergyFilterDialog> {
  late List<Allergen> _allergens;

  @override
  void initState() {
    super.initState();
    _allergens = widget.allergens;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '알러지 필터',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _allergens.length,
              itemBuilder: (context, index) {
                final allergen = _allergens[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      allergen.selected = !allergen.selected;
                    });
                    widget.onAllergyChange(_allergens);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: allergen.selected ? Colors.red : Colors.red,
                        width: 1,
                      ),
                      color: allergen.selected ? Colors.red : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          allergen.name,
                          style: TextStyle(
                            color: allergen.selected ? Colors.white : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}