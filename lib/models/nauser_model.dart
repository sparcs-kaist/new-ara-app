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
  final Map<String, dynamic> extra_preferences;
  final int group;
  final bool is_newara;
  final String ara_id;
  final String agree_terms_of_service_at;
  final inactive_due_at = null;

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
    required this.extra_preferences,
    required this.group,
    required this.is_newara,
    required this.ara_id,
    required this.agree_terms_of_service_at,
  });

  //아래 코드는 NAUser 클래스에 대한 fromJson 팩토리 메소드를 정의한 것입니다. 이 메소드는 JSON 데이터를 파라미터로 받아서 NAUser 객체를 생성하고 반환합니다.
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
        see_social = json['see_social'],
        extra_preferences = json['extra_preferences'],
        group = json['group'],
        is_newara = json['is_newara'],
        ara_id = json['ara_id'],
        agree_terms_of_service_at = json['agree_terms_of_service_at'];


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
        'extra_preferences': extra_preferences,
        'group': group,
        'is_newara': is_newara,
        'ara_id': ara_id,
        'agree_terms_of_service_at': agree_terms_of_service_at,
        'inactive_due_at': inactive_due_at,
      };
}
