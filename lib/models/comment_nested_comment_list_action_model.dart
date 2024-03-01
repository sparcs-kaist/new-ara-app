// ignore_for_file: non_constant_identifier_names

import 'package:new_ara_app/models/public_user_model.dart';

class CommentNestedCommentListActionModel {
  int id;
  bool is_hidden;
  List<dynamic> why_hidden;
  bool? can_override_hidden;
  bool? my_vote;
  bool is_mine;
  String? content;
  PublicUserModel created_by;
  String created_at;
  String updated_at;
  String deleted_at;
  int? name_type;
  int? report_count;
  int? positive_vote_count;
  int? negative_vote_count;
  String? hidden_at;
  int? parent_article;
  int? parent_comment;

  CommentNestedCommentListActionModel({
    required this.id,
    required this.is_hidden,
    required this.why_hidden,
    required this.can_override_hidden,
    required this.my_vote,
    required this.is_mine,
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

  factory CommentNestedCommentListActionModel.fromJson(
      Map<String, dynamic> json) {
    return CommentNestedCommentListActionModel(
      id: json['id'],
      is_hidden: json['is_hidden'],
      why_hidden: json['why_hidden'],
      can_override_hidden: json['can_override_hidden'],
      my_vote: json['my_vote'],
      is_mine: json['is_mine'],
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
        'is_mine': is_mine,
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
