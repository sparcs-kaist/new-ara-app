import 'package:new_ara_app/models/public_user_profile_model.dart';

class PublicUserModel {
  final dynamic id;
  final String username;
  final PublicUserProfileModel profile;

  PublicUserModel({
    required this.id,
    required this.username,
    required this.profile,
  });

  factory PublicUserModel.fromJson(Map<String, dynamic> json) {
    return PublicUserModel(
        id: json['id'],
        username: json['username'],
        profile: PublicUserProfileModel.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile': profile.toJson(),
    };
  }
}
