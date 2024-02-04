class UserProfileModel {
  final int user;
  final String? email;
  final bool is_official;
  final String created_at; // $date-time
  final String updated_at; // $date-time
  final String deleted_at; // $date-time
  final String uid; // SPARCS SSO uid
  final String sid; // SPARCS SSO sid
  final Map<String, dynamic> sso_user_info;
  final String? picture; // $uri, 프로필
  final String nickname;
  final String? nickname_updated_at; // $date-time, 최근 닉네임 변경 일시
  final bool? see_sexual;
  final bool? see_social;
  final int? group;
  final bool? is_newara; // 뉴아라 사용자 여부
  final String? ara_id; // 이전 아라 아이디
  final String? agree_terms_of_service_at; // $date-time
  final String? inactive_due_at; // $date-time

  UserProfileModel({
    required this.user,
    required this.email,
    required this.is_official,
    required this.created_at,
    required this.deleted_at,
    required this.updated_at,
    required this.uid,
    required this.sid,
    required this.sso_user_info,
    this.picture,
    this.nickname = "",
    required this.nickname_updated_at,
    required this.see_sexual,
    required this.see_social,
    required this.group,
    required this.is_newara,
    required this.ara_id,
    required this.agree_terms_of_service_at,
    this.inactive_due_at,
  });

  //아래 코드는 NAUser 클래스에 대한 fromJson 팩토리 메소드를 정의한 것입니다. 이 메소드는 JSON 데이터를 파라미터로 받아서 NAUser 객체를 생성하고 반환합니다.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      user: json['user'],
      email: json['email'],
      is_official: json['is_official'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      uid: json['uid'],
      sid: json['sid'],
      sso_user_info: json['sso_user_info'],
      picture: json['picture'],
      nickname: json['nickname'],
      nickname_updated_at: json['nickname_updated_at'],
      see_sexual: json['see_sexual'],
      see_social: json['see_social'],
      group: json['group'],
      is_newara: json['is_newara'],
      ara_id: json['ara_id'],
      agree_terms_of_service_at: json['agree_terms_of_service_at'],
      inactive_due_at: json['inactive_due_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user,
        "email": email,
        "is_official": is_official,
        "created_at": created_at,
        "updated_at": updated_at,
        "deleted_at": deleted_at,
        "uid": uid,
        "sid": sid,
        "sso_user_info": sso_user_info,
        "picture": picture,
        "nickname": nickname,
        "nickname_updated_at": nickname_updated_at,
        "see_sexual": see_sexual,
        "see_social": see_social,
        "group": group,
        "is_newara": is_newara,
        "ara_id": ara_id,
        "agree_terms_of_service_at": agree_terms_of_service_at,
        "inactive_due_at": inactive_due_at,
      };
}
