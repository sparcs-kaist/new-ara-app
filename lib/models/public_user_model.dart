import 'package:new_ara_app/models/public_user_profile_model.dart';

class PublicUserModel {
  final dynamic id;
  final String username;
  final PublicUserProfileModel profile;
  final bool? is_blocked;

  PublicUserModel({
    required this.id,
    required this.username,
    required this.profile,
    this.is_blocked,
  });

  factory PublicUserModel.fromJson(Map<String, dynamic> json) {
    return PublicUserModel(
        id: json['id'],
        username: json['username'],
        profile: PublicUserProfileModel.fromJson(json['profile']),
        is_blocked: json['is_blocked']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile': profile.toJson(),
      'is_blocked': is_blocked,
    };
  }
}
