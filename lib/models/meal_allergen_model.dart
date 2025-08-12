class Allergen {
  final int id;
  final String name;
  bool selected;

  Allergen({
    required this.id,
    required this.name,
    this.selected = false,
  });
}

