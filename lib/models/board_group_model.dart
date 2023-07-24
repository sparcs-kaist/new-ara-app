import 'package:new_ara_app/models/simple_board_model.dart';

class BoardGroupModel {
  int id;
  String slug;
  String ko_name;
  String en_name;
  List<SimpleBoardModel> boards;

  BoardGroupModel({
    required this.id,
    required this.slug,
    required this.ko_name,
    required this.en_name,
    required this.boards,
  });

  factory BoardGroupModel.fromJson(Map<String, dynamic> json) {
    return BoardGroupModel(
      id: json['id'],
      slug: json['slug'],
      ko_name: json['ko_name'],
      en_name: json['en_name'],
      boards: json['boards']
          .map((jsonBoard) => SimpleBoardModel.fromJson(jsonBoard))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'ko_name': ko_name,
        'en_name': en_name,
        'boards': boards.map((model) => model.toJson()).toList(),
      };
}
