import 'package:new_ara_app/models/board_model.dart';
import 'package:new_ara_app/models/public_user.dart';
import 'package:new_ara_app/models/topic_model.dart';

class ArticleListActionModel {
  int? id;
  bool? is_hidden;
  String? why_hidden;
  bool? can_override_hidden;
  TopicModel? parent_topic;
  BoardModel? parent_board;
  String? title;
  PublicUserModel? createdBy;
  String? read_status;
  String? attachment_type;
  String? communication_article_status;
  String? days_left;
  String? created_at;
  String? updated_at;
  String? deleted_at;
  int? name_type;
  bool? is_content_sexual;
  bool? is_content_social;
  int? hit_count;
  int? comment_count;
  int? report_count;
  int? positive_vote_count;
  int? negative_vote_count;
  String? commented_at;
  String? url;
  String? content_updated_at;
  String? hidden_at;

  ArticleListActionModel({
    this.id,
    this.is_hidden,
    this.why_hidden,
    this.can_override_hidden,
    this.parent_topic,
    this.parent_board,
    this.title,
    this.createdBy,
    this.read_status,
    this.attachment_type,
    this.communication_article_status,
    this.days_left,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.name_type,
    this.is_content_sexual,
    this.is_content_social,
    this.hit_count,
    this.comment_count,
    this.report_count,
    this.positive_vote_count,
    this.negative_vote_count,
    this.commented_at,
    this.url,
    this.content_updated_at,
    this.hidden_at,
  });

  factory ArticleListActionModel.fromJson(Map<String, dynamic> json) {
    return ArticleListActionModel(
      id: json['id'],
      is_hidden: json['is_hidden'],
      why_hidden: json['why_hidden'],
      can_override_hidden: json['can_override_hidden'],
      parent_topic: TopicModel.fromJson(json['parent_topic']),
      parent_board: BoardModel.fromJson(json['parent_board']),
      title: json['title'],
      createdBy: PublicUserModel.fromJson(json['created_by']),
      read_status: json['read_status'],
      attachment_type: json['attachment_type'],
      communication_article_status: json['communication_article_status'],
      days_left: json['days_left'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      name_type: json['name_type'],
      is_content_sexual: json['is_content_sexual'],
      is_content_social: json['is_content_social'],
      hit_count: json['hit_count'],
      comment_count: json['comment_count'],
      report_count: json['report_count'],
      positive_vote_count: json['positive_vote_count'],
      negative_vote_count: json['negative_vote_count'],
      commented_at: json['commented_at'],
      url: json['url'],
      content_updated_at: json['content_updated_at'],
      hidden_at: json['hidden_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_hidden': is_hidden,
      'why_hidden': why_hidden,
      'can_override_hidden': can_override_hidden,
      'parent_topic': parent_topic?.toJson(),
      'parent_board': parent_board?.toJson(),
      'title': title,
      'created_by': createdBy?.toJson(),
      'read_status': read_status,
      'attachment_type': attachment_type,
      'communication_article_status': communication_article_status,
      'days_left': days_left,
      'created_at': created_at,
      'updated_at': updated_at,
      'deleted_at': deleted_at,
      'name_type': name_type,
      'is_content_sexual': is_content_sexual,
      'is_content_social': is_content_social,
      'hit_count': hit_count,
      'comment_count': comment_count,
      'report_count': report_count,
      'positive_vote_count': positive_vote_count,
      'negative_vote_count': negative_vote_count,
      'commented_at': commented_at,
      'url': url,
      'content_updated_at': content_updated_at,
      'hidden_at': hidden_at,
    };
  }
}

