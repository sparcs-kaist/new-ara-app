// ignore_for_file: non_constant_identifier_names

class BoardModel {
  final int id;
  final String slug;
  final String ko_name;
  final String en_name;
  final bool? is_readonly; // 활성화 했을 때 관리자만 글을 쓸 수 있음
  final int? name_type; // 닉네임, 익명, 실명글 허용 여부 설정
  final int? group_id;
  final String? banner_image; // 게시판 배너 이미지 URI
  final String? ko_banner_description; // 게시판 배너에 삽입되는 국문 소개
  final String? en_banner_description; // 게시판 배너에 삽입되는 염문 소개
  final int? top_threshold; // 인기글 달성 기준 좋아요 갯수

  BoardModel({
    required this.id,
    required this.slug,
    required this.ko_name,
    required this.en_name,
    this.is_readonly,
    this.name_type,
    this.group_id,
    this.banner_image,
    this.ko_banner_description,
    this.en_banner_description,
    this.top_threshold,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
      is_readonly: json['is_readonly'],
      name_type: json['name_type'],
      group_id: json['group_id'],
      banner_image: json['banner_image'],
      ko_banner_description: json['ko_banner_description'],
      en_banner_description: json['en_banner_description'],
      top_threshold: json['top_threshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'ko_name': ko_name,
      'en_name': en_name,
      'is_readonly': is_readonly,
      'name_type': name_type,
      'group_id': group_id,
      'banner_image': banner_image,
      'ko_banner_description': ko_banner_description,
      'en_banner_description': en_banner_description,
      'top_threshold': top_threshold,
    };
  }
}
