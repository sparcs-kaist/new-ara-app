class BoardModel {
  int? id;
  String? created_at;
  String? updated_at;
  String? deleted_at;
  String? slug;
  String? ko_name;
  String? en_name;
  String? ko_description;
  String? en_description;
  int? read_access_mask;
  int? write_access_mask;
  int? comment_access_mask;
  bool? is_readonly;
  bool? is_hidden;
  int? name_type;
  bool? is_school_communication;
  int? group_id;
  String? banner_image;
  String? ko_banner_description;
  String? en_banner_description;
  String? banner_url;

  BoardModel({
    this.id,
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

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'],
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
