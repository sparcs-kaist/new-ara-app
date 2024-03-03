// ignore_for_file: non_constant_identifier_names

class SimpleBoardModel {
  int id;
  String slug;
  String ko_name;
  String en_name;

  SimpleBoardModel({
    required this.id,
    required this.slug,
    required this.ko_name,
    required this.en_name,
  });

  factory SimpleBoardModel.fromJson(Map<String, dynamic> json) {
    return SimpleBoardModel(
      id: json['id'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'ko_name': ko_name,
        'en_name': en_name,
      };
}
