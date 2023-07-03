import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/models/board_model.dart';
import 'package:new_ara_app/models/public_user.dart';
import 'package:new_ara_app/models/comment_list_action.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';

class ArticleModel {
  final int id;
  final bool? is_hidden;
  final dynamic why_hidden;
  final bool? can_override_hidden;
  final TopicModel? parent_topic;
  final BoardModel? parent_board;
  final List<dynamic>? attachments;
  final PublicUserModel? my_comment_profile;
  final List<CommentListActionModel>? comments;
  final bool? is_mine;
  final String? title;
  final String? content;
  final bool? my_vote;
  final ScrapCreateActionModel? my_scrap;
  final PublicUserModel? created_by;
  final int? article_current_page;
  final dynamic side_articles; // 추후에 모델 만들어야 함
  final String? communication_article_status;
  final String? days_left;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final int? name_type;
  final bool? is_content_sexual;
  final bool? is_content_social;
  final int? hit_count;
  final int? comment_count;
  final int? report_count;
  final int? positive_vote_count;
  final int? negative_vote_count;
  final String? commented_at;
  final String? url;
  final String? content_updated_at;
  final String? hidden_at;

  ArticleModel({
    required this.id,
    this.is_hidden,
    this.why_hidden,
    this.can_override_hidden,
    this.parent_topic,
    this.parent_board,
    this.attachments,
    this.my_comment_profile,
    this.comments,
    this.is_mine,
    this.title,
    this.content,
    this.my_vote,
    this.my_scrap,
    this.created_by,
    this.article_current_page,
    this.side_articles,
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

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    List<CommentListActionModel>? tmpList = [];
    for (int i = 0; i < json['comments'].toList().length; i++) {
      tmpList.add(CommentListActionModel.fromJson(json['comments'][i]));
    }
    return ArticleModel(
        id: json['id'],
        is_hidden: json['is_hidden'],
        why_hidden: json['why_hidden'],
        can_override_hidden: json['can_override_hidden'],
        parent_topic: json['parent_topic'] == null
            ? null
            : TopicModel.fromJson(json['parent_topic']),
        parent_board: json['parent_board'] == null
            ? null
            : BoardModel.fromJson(json['parent_board']),
        attachments: json['attachments'],
        my_comment_profile:
            PublicUserModel.fromJson(json['my_comment_profile']),
        comments: tmpList,
        is_mine: json['is_mine'],
        title: json['title'],
        content: json['content'],
        my_vote: json['my_vote'],
        my_scrap: json['my_scrap'] == null
            ? null
            : ScrapCreateActionModel.fromJson(json['my_scrap']),
        created_by: json['created_by'] == null
            ? null
            : PublicUserModel.fromJson(json['created_by']),
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
        hidden_at: json['hidden_at']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_hidden': is_hidden,
        'why_hidden': why_hidden,
        'can_override_hidden': can_override_hidden,
        'parent_topic': parent_topic!.toJson(),
        'parent_board': parent_board!.toJson(),
        'attachments': attachments,
        'my_comment_profile': my_comment_profile,
        'comments': comments!.map((comment) => comment.toJson()).toList(),
        'is_mine': is_mine,
        'title': title,
        'content': content,
        'my_vote': my_vote,
        'created_by': created_by!.toJson(),
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
      };
}
