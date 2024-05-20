// ignore_for_file: non_constant_identifier_names

import 'package:new_ara_app/models/public_user_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';

class ScrapModel {
  int id;
  ArticleListActionModel parent_article;
  PublicUserModel scrapped_by;
  String created_at;
  String updated_at;
  String deleted_at; // default: 0001-01-01T08:28:00+08:28

  ScrapModel({
    required this.id,
    required this.parent_article,
    required this.scrapped_by,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
  });

  ScrapModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        parent_article =
            ArticleListActionModel.fromJson(json['parent_article']),
        scrapped_by = PublicUserModel.fromJson(json['scrapped_by']),
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        deleted_at = json['deleted_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_article': parent_article.toJson(),
        'scrapped_by': scrapped_by.toJson(),
        'created_at': created_at,
        'updated_at': updated_at,
        'deleted_at': deleted_at,
      };
}
