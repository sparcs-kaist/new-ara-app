class TopicModel {
  final int? id;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final String? slug;
  final String? ko_name;
  final String? en_name;
  final String? ko_description;
  final String? en_description;
  final int? parent_board;

  TopicModel({
    this.id,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.slug,
    this.ko_name,
    this.en_name,
    this.ko_description,
    this.en_description,
    this.parent_board,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
      ko_description: json['ko_description'],
      en_description: json['en_description'],
      parent_board: json['parent_board'],
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'deleted_at': deleted_at,
      'slug': slug,
      'ko_name': ko_name,
      'en_name': en_name,
      'ko_description': ko_description,
      'en_description': en_description,
      'parent_board': parent_board,
    };
  }
}
