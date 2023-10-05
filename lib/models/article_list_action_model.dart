import 'package:new_ara_app/models/public_user_model.dart';
import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/models/board_model.dart';

class ArticleListActionModel {
  final int id; // 글 마다 부여되는 id
  final bool is_hidden; // 숨김처리 되었는지 여부
  final List<dynamic> why_hidden; // 숨김처리 되었는지 여부
  final bool? can_override_hidden; // 변수의 용도 정확히 모르겠음
  final TopicModel? parent_topic; // 변수의 타입 정확하게 모르겠음
  final BoardModel parent_board;
  final String? title;
  final PublicUserModel created_by;
  final String? read_status;
  final String? attachment_type;
  final dynamic communication_article_status; // 변수의 용도 정확하게 모르겠음, string 또는 int
  final dynamic days_left; // 변수의 타입 및 용도 정확하게 모르겠음, string 또는 int
  final String created_at; // $date-time
  final String updated_at; // $date-time
  final String deleted_at; // $date-time
  final int? name_type;
  final bool? is_content_sexual;
  final bool? is_content_social;
  final int? hit_count;
  final int? comment_count;
  final int? report_count;
  final int? positive_vote_count;
  final int? negative_vote_count;
  final String? commented_at; // $date-time
  final String? url; // $uri, 포탈 링크
  final String? content_updated_at; // $date-time, 제목/본문/첨부파일 수정 시간
  final String? hidden_at; // $date-time, 숨김 시간
  final String? topped_at; // $date-time, 인기글 달성 시간

  ArticleListActionModel(
      {required this.id,
      required this.is_hidden,
      required this.why_hidden,
      this.can_override_hidden,
      this.parent_topic,
      required this.parent_board,
      this.title,
      required this.created_by,
      required this.read_status,
      required this.attachment_type,
      required this.communication_article_status,
      required this.days_left,
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
      this.topped_at});

  factory ArticleListActionModel.fromJson(Map<String, dynamic> json) {
    return ArticleListActionModel(
      id: json['id'],
      is_hidden: json['is_hidden'],
      why_hidden: json['why_hidden'],
      can_override_hidden: json['can_override_hidden'],
      parent_topic: json['parent_topic'] != null
          ? TopicModel.fromJson(json['parent_topic'])
          : null,
      parent_board: BoardModel.fromJson(json['parent_board']),
      title: json['title'],
      created_by: PublicUserModel.fromJson(json['created_by']),
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
      hidden_at: json['hidden'],
      topped_at: json['topped_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_hidden': is_hidden,
        'can_override_hidden': can_override_hidden,
        'parent_topic': parent_topic ?? parent_topic!.toJson(),
        'parent_board': parent_board.toJson(),
        'title': title,
        'created_by': created_by.toJson(),
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
        'topped_at': topped_at,
      };
}
