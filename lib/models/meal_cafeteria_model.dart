// lib/models/cafeteria_menu_model.dart
class CafeteriaMenuItem {
  final String menuName;
  final int price;
  final List<int> allergy;

  CafeteriaMenuItem({
    required this.menuName,
    required this.price,
    required this.allergy,
  });

  factory CafeteriaMenuItem.fromJson(Map<String, dynamic> json) {
    return CafeteriaMenuItem(
      menuName: json['menu_name'],
      price: json['price'],
      allergy: List<int>.from(json['allergy']),
    );
  }
}