import 'package:new_ara_app/models/public_user_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';

class ScrapModel {
  final int? id;
  final ArticleListActionModel parent_article;
  final PublicUserModel? scrapped_by;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at; // default: 0001-01-01T08:28:00+08:28

  ScrapModel({
    this.id,
    required this.parent_article,
    this.scrapped_by,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  ScrapModel.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.parent_article =
            ArticleListActionModel.fromJson(json['parent_article']),
        this.scrapped_by = PublicUserModel.fromJson(json['scrapped_by']),
        this.created_at = json['created_at'],
        this.updated_at = json['updated_at'],
        this.deleted_at = json['deleted_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_article': parent_article!.toJson(),
        'scrapped_by': scrapped_by!.toJson(),
        'created_at': created_at,
        'updated_at': updated_at,
        'deleted_at': deleted_at,
      };
}
