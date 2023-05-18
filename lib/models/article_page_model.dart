import 'package:new_ara_app/models/article_list_action_model.dart';

class ArticlePageModel {
  int num_pages;
  int num_items;
  int current;
  String previous;
  String next;
  List<ArticleListActionModel> result;

  ArticlePageModel({
    required this.num_pages,
    required this.num_items,
    required this.current,
    required this.previous,
    required this.next,
    required this.result,
  });

  factory ArticlePageModel.fromJson(Map<String, dynamic> json) {
    List<ArticleListActionModel> result = [];
    if (json['result'] != null) {
      // 'result' 필드의 값이 존재하면 파싱하여 result 리스트에 할당
      json['result'].forEach((item) {
        result.add(ArticleListActionModel.fromJson(item));
      });
    }

    return ArticlePageModel(
      num_pages: json['num_pages'],
      num_items: json['num_items'],
      current: json['current'],
      previous: json['previous'],
      next: json['next'],
      result: result,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> resultJson = [];
    if (result != null) {
      // result 리스트의 각 항목을 toJson() 메서드를 통해 Map으로 변환하여 resultJson 리스트에 추가
      resultJson = result.map((item) => item.toJson()).toList();
    }

    return {
      'num_pages': num_pages,
      'num_items': num_items,
      'current': current,
      'previous': previous,
      'next': next,
      'result': resultJson,
    };
  }
}
