// lib/widgets/restaurant_dialog.dart
import 'package:flutter/material.dart';

class RestaurantFilterDialog extends StatefulWidget {
  final String selectedRestaurant;
  final Function(String) onRestaurantChange;

  const RestaurantFilterDialog({
    Key? key,
    required this.selectedRestaurant,
    required this.onRestaurantChange,
  }) : super(key: key);

  @override
  State<RestaurantFilterDialog> createState() => _RestaurantFilterDialogState();
}

class _RestaurantFilterDialogState extends State<RestaurantFilterDialog> {
  final List<String> restaurants = [
    "카이마루",
    "동맛골 1층",
    "동맛골 2층",
    "서맛골",
    "교수회관",
    "카페테리아"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final isSelected = widget.selectedRestaurant == restaurant;
                
                return InkWell(
                  onTap: () {
                    widget.onRestaurantChange(restaurant);
                    Navigator.pop(context);  // 선택 후 다이얼로그 닫기
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.red,
                        width: 1,
                      ),
                      color: isSelected ? Colors.red : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          restaurant,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.red,
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