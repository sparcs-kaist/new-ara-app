import 'package:new_ara_app/models/topic_model.dart';
import 'package:new_ara_app/models/simple_board_model.dart';

class BoardDetailActionModel {
  int id;
  String slug;
  String ko_name;
  String en_name;
  bool? is_readonly; // 활성화했을 때 관리자만 글을 쓸 수 있음
  int? name_type;
  SimpleBoardModel group;
  String? banner_image; // $uri
  String? ko_banner_description;
  String? en_banner_description;
  int? top_threshold; // 인기글 달성 기준 좋아요 갯수
  List<TopicModel> topics;
  bool user_readable;
  bool user_writable;

  BoardDetailActionModel({
    required this.id,
    required this.topics,
    required this.user_readable,
    required this.user_writable,
    required this.slug,
    required this.ko_name,
    required this.en_name,
    this.is_readonly,
    this.name_type,
    required this.group,
    this.banner_image,
    this.ko_banner_description,
    this.en_banner_description,
    this.top_threshold,
  });

  factory BoardDetailActionModel.fromJson(Map<String, dynamic> json) {
    return BoardDetailActionModel(
      id: json['id'],
      topics: (json['topics'] as List<dynamic>)
          .map((topicJson) => TopicModel.fromJson(topicJson))
          .toList(),
      user_readable: json['user_readable'],
      user_writable: json['user_writable'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
      is_readonly: json['is_readonly'],
      name_type: json['name_type'],
      group: SimpleBoardModel.fromJson(json['group']),
      banner_image: json['banner_image'],
      ko_banner_description: json['ko_banner_description'],
      en_banner_description: json['en_banner_description'],
      top_threshold: json['top_threshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topics': topics.map((topic) => topic.toJson()).toList(),
      'user_readable': user_readable,
      'user_writable': user_writable,
      'slug': slug,
      'ko_name': ko_name,
      'en_name': en_name,
      'is_readonly': is_readonly,
      'name_type': name_type,
      'group': group.toJson(),
      'banner_image': banner_image,
      'ko_banner_description': ko_banner_description,
      'en_banner_description': en_banner_description,
      'top_threshold': top_threshold,
    };
  }
}
