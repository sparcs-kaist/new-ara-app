class BaseArticleModel {
  int id;
  String created_at;
  String updated_at;
  String deleted_at;
  String title;
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
  int created_by;
  int? parent_topic;
  int parent_board;

  BaseArticleModel({
    required this.id,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    required this.title,
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
    required this.created_by,
    this.parent_topic,
    required this.parent_board,
  });

  factory BaseArticleModel.fromJson(Map<String, dynamic> json) {
    return BaseArticleModel(
      id: json['id'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      title: json['title'],
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
      created_by: json['created_by'],
      parent_topic: json['parent_topic'],
      parent_board: json['parent_board'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'deleted_at': deleted_at,
      'title': title,
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
      'created_by': created_by,
      'parent_topic': parent_topic,
      'parent_board': parent_board,
    };
  }
}
