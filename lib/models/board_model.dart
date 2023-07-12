class BoardModel {
  final int id;
  final String created_at;
  final String updated_at;
  final String deleted_at;
  final String slug;
  final String ko_name;
  final String en_name;
  final String ko_description;
  final String en_description;
  final int? read_access_mask;
  final int? write_access_mask;
  final int? comment_access_mask;
  final bool? is_readonly; // 활성화 했을 때 관리자만 글을 쓸 수 있음
  final bool? is_hidden; // 활성화 했을 때 메인페이지 상단바 리스트에 나타나지 않음
  final int? name_type; // 닉네임, 익명, 실명글 허용 여부 설정
  final bool? is_school_communication; // 학교 소통 게시판 글임을 표시
  final int? group_id;
  final String? banner_image; // 게시판 배너 이미지 URI
  final String? ko_banner_description; // 게시판 배너에 삽입되는 국문 소개
  final String? en_banner_description; // 게시판 배너에 삽입되는 염문 소개
  final String? banner_url; // 게시판 배너를 클릭 시에 이동하는 링크
  final int? top_threshold; // 인기글 달성 기준 좋아요 갯수

  BoardModel({
    required this.id,
    required this.created_at,
    required this.updated_at,
    this.deleted_at = "0001-01-01T08:27:52+08:27:52",
    required this.slug,
    required this.ko_name,
    required this.en_name,
    required this.ko_description,
    required this.en_description,
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
    this.top_threshold,
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
      top_threshold: json['top_threshold'],
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
      'top_threshold': top_threshold,
    };
  }
}
