import 'package:new_ara_app/models/public_user_model.dart';

class BlockModel {
  int id;
  /// 차단당한 유저의 PublicUserModel
  PublicUserModel user;
  String createdAt;
  String updatedAt;
  String deletedAt;
  /// 차단한 유저의 id
  int blockedBy;

  BlockModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.blockedBy,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'],
      user: PublicUserModel.fromJson(json['user']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      blockedBy: json['blocked_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'blocked_by': blockedBy,
    };
  }
}