class ScrapCreateActionModel {
  final int? id;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final int? parent_article; // 스크랩한 글
  final int? scrapped_by; // 스크랩한 사람

  ScrapCreateActionModel({
    this.id,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.parent_article,
    this.scrapped_by,
  });

  factory ScrapCreateActionModel.fromJson(Map<String, dynamic> json) {
    return ScrapCreateActionModel(
        id: json['id'],
        created_at: json['created_at'],
        updated_at: json['updated_at'],
        deleted_at: json['deleted_at'],
        parent_article: json['parent_article'],
        scrapped_by: json['scrapped_by']);
  }
}
