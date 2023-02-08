class NAUser {
  final int user;
  final String email;
  final String nickname;
  final bool is_official;
  final int num_articles;
  final int num_positive_votes;
  final String created_at;
  final String updated_at;
  final String deleted_at;
  final String uid;
  final String sid;
  final Map<String, dynamic> sso_user_info;
  final String picture;
  final String nickname_updated_at;
  final bool see_sexual;
  final bool see_social;

  NAUser({
    required this.user,
    required this.email,
    required this.nickname,
    required this.is_official,
    required this.num_articles,
    required this.num_positive_votes,
    required this.created_at,
    required this.deleted_at,
    required this.updated_at,
    required this.uid,
    required this.sid,
    required this.sso_user_info,
    required this.picture,
    required this.nickname_updated_at,
    required this.see_sexual,
    required this.see_social,
  });

  NAUser.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        email = json['email'],
        nickname = json['nickname'],
        is_official = json['is_official'],
        num_articles = json['num_articles'],
        num_positive_votes = json['num_positive_votes'],
        created_at = json['created_at'],
        deleted_at = json['deleted_at'],
        updated_at = json['updated_at'],
        uid = json['uid'],
        sid = json['sid'],
        sso_user_info = json['sso_user_info'],
        picture = json['picture'],
        nickname_updated_at = json['nickname_updated_at'],
        see_sexual = json['see_sexual'],
        see_social = json['see_social'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'email': email,
        'nickname': nickname,
        'is_official': is_official,
        'num_articles': num_articles,
        'num_positive_votes': num_positive_votes,
        'created_at': created_at,
        'deleted_at': deleted_at,
        'updated_at': updated_at,
        'uid': uid,
        'sid': sid,
        'sso_user_info': sso_user_info,
        'picture': picture,
        'nickname_updated_at': nickname_updated_at,
        'see_sexual': see_sexual,
        'see_social': see_social,
      };
}
