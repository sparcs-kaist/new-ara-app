// ignore_for_file: non_constant_identifier_names

class PublicUserProfileModel {
  String? picture;
  String? nickname;
  dynamic user;
  bool? is_official;
  bool? is_school_admin;

  PublicUserProfileModel({
    this.picture,
    this.nickname,
    required this.user,
    required this.is_official,
    required this.is_school_admin,
  });

  factory PublicUserProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicUserProfileModel(
      picture: json['picture'],
      nickname: json['nickname'],
      user: json['user'],
      is_official: json['is_official'],
      is_school_admin: json['is_school_admin'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'picture': picture,
      'nickname': nickname,
      'user': user,
      'is_official': is_official,
      'is_school_admin': is_school_admin,
    };
  }
}
