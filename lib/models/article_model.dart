import 'package:flutter/material.dart';

import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/models/board_model.dart';
import 'package:new_ara_app/models/article_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/public_user_model.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';
import 'package:new_ara_app/models/attachment_model.dart';

class ArticleModel {
  int id;
  bool is_hidden;
  List<dynamic> why_hidden;
  bool? can_override_hidden;
  TopicModel? parent_topic;
  BoardModel parent_board;
  List<AttachmentModel> attachments;
  Map<String, dynamic> my_comment_profile;
  List<ArticleNestedCommentListAction> comments;
  bool is_mine;
  String? title;
  String? content;
  bool? my_vote;
  ScrapCreateActionModel? my_scrap; // 변수의 타입 및 용도 불분명
  PublicUserModel created_by;
  int? article_current_page;
  dynamic side_articles; // 변수의 타입 및 용도 불분명
  dynamic communication_article_status; // 타입 및 용도 불분명
  dynamic days_left; // 타입 불분명
  String created_at;
  String updated_at;
  String deleted_at;

  /// name_type이 1이면 기본 이름, 2이면 익명 이름
  /// TODO: 현재 데브랑 본섭이랑 name_type 명명 규칙이 다름
  /// https://sparcs.slack.com/archives/CV6H8N4EM/p1699094779620889
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
  String? topped_at;

  ArticleModel({
    required this.id,
    required this.is_hidden,
    required this.why_hidden,
    required this.can_override_hidden,
    required this.parent_topic,
    required this.parent_board,
    required this.attachments,
    required this.my_comment_profile,
    required this.comments,
    required this.is_mine,
    this.title,
    this.content,
    this.my_vote,
    this.my_scrap,
    required this.created_by,
    this.article_current_page,
    this.side_articles,
    this.communication_article_status,
    this.days_left,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
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
    this.topped_at,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    List<ArticleNestedCommentListAction> tmpList = [];
    for (dynamic commentJson in json['comments']) {
      try {
        tmpList.add(ArticleNestedCommentListAction.fromJson(commentJson));
      } catch (error) {
        debugPrint(
            "During ArticleModel.fromJson, adding commentID ${commentJson['id']} failed: $error");
      }
    }
    List<AttachmentModel> fileList = [];
    // attachments 필드가 null이 아닐 때만 파일 정보를 받아옴.
    if (json['attachments'] != null) {
      for (dynamic fileJson in json['attachments']) {
        try {
          fileList.add(AttachmentModel.fromJson(fileJson));
        } catch (error) {
          debugPrint(
              "During ArticleModel.fromJson, adding attachment ${fileJson['id']} failed: $error");
        }
      }
    }
    return ArticleModel(
      id: json['id'],
      is_hidden: json['is_hidden'],
      why_hidden: json['why_hidden'],
      can_override_hidden: json['can_override_hidden'],
      parent_topic: json['parent_topic'] == null
          ? null
          : TopicModel.fromJson(json['parent_topic']),
      parent_board: BoardModel.fromJson(json['parent_board']),
      attachments: fileList,
      my_comment_profile: json['my_comment_profile'],
      comments: tmpList,
      is_mine: json['is_mine'],
      title: json['title'],
      content: json['content'],
      my_vote: json['my_vote'],
      my_scrap: json['my_scrap'] == null
          ? null
          : ScrapCreateActionModel.fromJson(json['my_scrap']),
      created_by: PublicUserModel.fromJson(json['created_by']),
      article_current_page: json['article_current_page'],
      side_articles: json['side_articles'],
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
      topped_at: json['topped_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_hidden': is_hidden,
        'why_hidden': why_hidden,
        'can_override_hidden': can_override_hidden,
        'parent_topic': parent_topic?.toJson(),
        'parent_board': parent_board.toJson(),
        'attachments': attachments == []
            ? []
            : attachments.map((model) => model.toJson()).toList(),
        'my_comment_profile': my_comment_profile,
        'comments': comments == []
            ? []
            : comments.map((comment) => comment.toJson()).toList(),
        'is_mine': is_mine,
        'title': title,
        'content': content,
        'my_vote': my_vote,
        'my_scrap': my_scrap?.toJson(),
        'created_by': created_by.toJson(),
        'article_current_page': article_current_page,
        'side_articles': side_articles,
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
        'topped_at': topped_at,
      };
}
