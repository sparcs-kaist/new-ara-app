import 'package:new_ara_app/models/base_article_model.dart';

class NotificationModel {
  int id;
  bool? is_read;
  BaseArticleModel related_article;
  String created_at;
  String updated_at;
  String deleted_at;
  String? type;
  String title;
  String content;

  NotificationModel({
    required this.id,
    this.is_read,
    required this.related_article,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    this.type,
    required this.title,
    required this.content,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      is_read: json['is_read'],
      related_article: BaseArticleModel.fromJson(json['related_article']),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_read': is_read,
    'related_article': related_article.toJson(),
    'created_at': created_at,
    'updated_at': updated_at,
    'type': type,
    'title': title,
    'content': content,
  };
}
