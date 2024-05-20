// ignore_for_file: non_constant_identifier_names

class ScrapCreateActionModel {
  int id;
  String created_at;
  String updated_at;
  String deleted_at;
  int parent_article;
  int scrapped_by;

  ScrapCreateActionModel({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    required this.parent_article,
    required this.scrapped_by,
  });

  factory ScrapCreateActionModel.fromJson(Map<String, dynamic> json) {
    return ScrapCreateActionModel(
      id: json['id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      parent_article: json['parent_article'],
      scrapped_by: json['scrapped_by'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': created_at,
        'updated_at': updated_at,
        'deleted_at': deleted_at,
        'parent_article': parent_article,
        'scrapped_by': scrapped_by,
      };
}
