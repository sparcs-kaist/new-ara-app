// 담아둔 글의 경우 parent_article을 fromJson
import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/models/board_model.dart';
import 'package:new_ara_app/models/public_user.dart';

class ArticleListActionModel {
  final dynamic parent_article;
  final int id; // ID
  final bool? is_hidden;
  final dynamic why_hidden;
  final bool? can_override_hidden;
  final Map<String, dynamic>? parent_topic;
  final Map<String, dynamic>? parent_board;
  final String? title;
  final Map<String, dynamic>? created_by;
  final String? read_status;
  final String? attachment_type;
  final dynamic communication_article_status;
  final dynamic days_left;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final int? name_type; // 익명 혹은 실명 여부
  final bool? is_content_sexual;
  final bool? is_content_social;
  final int? hit_count;
  final int? comment_count;
  final int? report_count;
  final int? positive_vote_count;
  final int? negative_vote_count;
  final String? commented_at; // 마지막 댓글이 달린 시간
  final String? url; // 포탈 링크
  final String? content_updated_at; // 제목, 본문, 첨부파일 수정 시간
  final String? hidden_at; // 숨긴 시간

  ArticleListActionModel({
    this.parent_article,
    required this.id,
    this.is_hidden,
    this.why_hidden,
    this.can_override_hidden,
    this.parent_topic,
    this.parent_board,
    this.title,
    this.created_by,
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

  ArticleListActionModel.fromJson(Map<String, dynamic> json)
      : parent_article = json['parent_article'],
        id = json['id'],
        is_hidden = json['is_hidden'],
        why_hidden = json['why_hidden'],
        can_override_hidden = json['can_override_hidden'],
        parent_topic = json['parent_topic'],
        parent_board = json['parent_board'],
        title = json['title'],
        created_by = json['created_by'],
        read_status = json['read_status'],
        attachment_type = json['attachment_type'],
        communication_article_status = json['communication_article_status'],
        days_left = json['days_left'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        deleted_at = json['deleted_at'],
        name_type = json['name_type'],
        is_content_sexual = json['is_content_sexual'],
        is_content_social = json['is_content_social'],
        hit_count = json['hit_count'],
        comment_count = json['comment_count'],
        report_count = json['report_count'],
        positive_vote_count = json['positive_vote_count'],
        negative_vote_count = json['negative_vote_count'],
        commented_at = json['commented_at'],
        url = json['url'],
        content_updated_at = json['content_updated_at'],
        hidden_at = json['hidden_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_hidden': is_hidden,
        'why_hidden': why_hidden,
        'can_override_hidden': can_override_hidden,
        'parent_topic': parent_topic,
        'parent_board': parent_board,
        'title': title,
        'created_by': created_by,
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
