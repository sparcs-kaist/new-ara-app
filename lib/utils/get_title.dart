import 'package:new_ara_app/models/article_list_action_model.dart';

/// ArticleListActionModel을 입력받고 해당하는 글의 상태에 따라
/// 적절한 제목을 리턴하는 함수.
/// UserViewPage, UserPage, PostListShowPage 등등 글 리스트를 보여주는 페이지에서 활용.
String getTitle(ArticleListActionModel articleModel) {
  // 숨겨진 글인 경우
  if (articleModel.is_hidden == true || articleModel.title == null) {
    // 차단한 사용자의 게시물인 경우
    if (articleModel.why_hidden.contains("BLOCKED_USER_CONTENT")) {
      return '차단한 사용자의 게시물입니다.';
    }
    // 숨겨졌지만 사유가 차단은 아닌 경우
    // TODO: 글이 숨겨지는 경우 더 있는지 확인해보기
    else {
      return '숨겨진 게시물입니다.';
    }
  }
  // 숨겨진 글이 아닌 경우
  else {
    return articleModel.title.toString();
  }
}