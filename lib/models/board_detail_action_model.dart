import 'package:new_ara_app/models/topic_model.dart';

class BoardDetailActionModel {
  final int? id;
  final List<TopicModel>? topics;
  final String? user_readable;
  final String? user_writable;
  final String? created_at;
  final String? updated_at;
  final String? deleted_at;
  final String? slug;
  final String? ko_name;
  final String? en_name;
  final String? ko_description;
  final String? en_description;
  final int? read_access_mask;
  final int? write_access_mask;
  final int? comment_access_mask;
  final bool? is_readonly;
  final bool? is_hidden;
  final int? name_type;
  final bool? is_school_communication;
  final int? group_id;
  final String? banner_image;
  final String? ko_banner_description;
  final String? en_banner_description;
  final String? banner_url;

  BoardDetailActionModel({
    this.id,
    this.topics,
    this.user_readable,
    this.user_writable,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.slug,
    this.ko_name,
    this.en_name,
    this.ko_description,
    this.en_description,
    this.read_access_mask,
    this.write_access_mask,
    this.comment_access_mask,
    this.is_readonly,
    this.is_hidden,
    this.name_type,
    this.is_school_communication,
    this.group_id,
    this.banner_image,
    this.ko_banner_description,
    this.en_banner_description,
    this.banner_url,
  });

  factory BoardDetailActionModel.fromJson(Map<String, dynamic> json) {
    return BoardDetailActionModel(
      id: json['id'],
      topics: (json['topics'] as List<dynamic>?)
          ?.map((topicJson) => TopicModel.fromJson(topicJson))
          .toList(),
      user_readable: json['user_readable'],
      user_writable: json['user_writable'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      deleted_at: json['deleted_at'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
      ko_description: json['ko_description'],
      en_description: json['en_description'],
      read_access_mask: json['read_access_mask'],
      write_access_mask: json['write_access_mask'],
      comment_access_mask: json['comment_access_mask'],
      is_readonly: json['is_readonly'],
      is_hidden: json['is_hidden'],
      name_type: json['name_type'],
      is_school_communication: json['is_school_communication'],
      group_id: json['group_id'],
      banner_image: json['banner_image'],
      ko_banner_description: json['ko_banner_description'],
      en_banner_description: json['en_banner_description'],
      banner_url: json['banner_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topics': topics?.map((topic) => topic.toJson()).toList(),
      'user_readable': user_readable,
      'user_writable': user_writable,
      'created_at': created_at,
      'updated_at': updated_at,
      'deleted_at': deleted_at,
      'slug': slug,
      'ko_name': ko_name,
      'en_name': en_name,
      'ko_description': ko_description,
      'en_description': en_description,
      'read_access_mask': read_access_mask,
      'write_access_mask': write_access_mask,
      'comment_access_mask': comment_access_mask,
      'is_readonly': is_readonly,
      'is_hidden': is_hidden,
      'name_type': name_type,
      'is_school_communication': is_school_communication,
      'group_id': group_id,
      'banner_image': banner_image,
      'ko_banner_description': ko_banner_description,
      'en_banner_description': en_banner_description,
      'banner_url': banner_url,
    };
  }
}
