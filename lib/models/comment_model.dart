// ignore_for_file: non_constant_identifier_names

import 'package:new_ara_app/models/public_user_model.dart';

class CommentModel {
  final int id;
  final bool is_hidden;
  final List<dynamic> why_hidden;
  final bool? can_override_hidden;
  final bool? my_vote;
  final String? content;
  final PublicUserModel created_by;
  final String created_at;
  final String updated_at;
  final String deleted_at;
  final int? name_type;
  final int? report_count;
  final int? positive_vote_count;
  final int? negative_vote_count;
  final String? hidden_at;
  final int? parent_article;
  final int? parent_comment;

  CommentModel({
    required this.id,
    required this.is_hidden,
    required this.why_hidden,
    required this.can_override_hidden,
    required this.my_vote,
    required this.content,
    required this.created_by,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    this.name_type,
    this.report_count,
    this.positive_vote_count,
    this.negative_vote_count,
    this.hidden_at,
    this.parent_article,
    this.parent_comment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      is_hidden: json['is_hidden'],
      why_hidden: json['why_hidden'],
      can_override_hidden: json['can_override_hidden'],
      my_vote: json['my_vote'],
      content: json['content'],
      created_by: PublicUserModel.fromJson(json['created_by']),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      name_type: json['name_type'],
      report_count: json['report_count'],
      positive_vote_count: json['positive_vote_count'],
      negative_vote_count: json['negative_vote_count'],
      hidden_at: json['hidden_at'],
      parent_article: json['parent_article'],
      parent_comment: json['parent_comment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_hidden': is_hidden,
        'why_hidden': why_hidden,
        'can_override_hidden': can_override_hidden,
        'my_vote': my_vote,
        'content': content,
        'created_by': created_by.toJson(),
        'created_at': created_at,
        'updated_at': updated_at,
        'deleted_at': deleted_at,
        'name_type': name_type,
        'report_count': report_count,
        'positive_vote_count': positive_vote_count,
        'negative_vote_count': negative_vote_count,
        'hidden_at': hidden_at,
        'parent_article': parent_article,
        'parent_comment': parent_comment,
      };
}
