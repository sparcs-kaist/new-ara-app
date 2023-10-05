class TopicModel {
  final int id;
  final String slug;
  final String ko_name;
  final String en_name;

  TopicModel({
    required this.id,
    required this.slug,
    required this.ko_name,
    required this.en_name,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'ko_name': ko_name,
      'en_name': en_name,
    };
  }
}
