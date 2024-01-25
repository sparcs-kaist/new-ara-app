import 'package:new_ara_app/models/article_list_action_model.dart';

/// ArticleListActionModel을 입력받고 해당하는 글의 상태에 따라 적절한 제목을 리턴하는 함수.
/// UserViewPage, UserPage, PostListShowPage 등등 글 리스트를 보여주는 페이지에서 활용.
String getTitle(ArticleListActionModel articleModel) {
  // 글 제목은 ArticleListActionModel why_hidden의 마지막 원소에 따라 결정됨
  int targetIdx = articleModel.why_hidden.length - 1;

  /* 숨겨진 글이 아닐 경우 */
  if (articleModel.is_hidden == false) {
    return articleModel.title.toString();
  }
  /* 숨겨졌으나 why_hidden이 지정되지 않은 경우 */
  // TODO: 이 경우가 실제로 가능한지 확인해보기
  else if (targetIdx == -1) {
    return '숨겨진 게시물입니다.';
  }
  /* 숨겨졌으며 why_hidden이 지정된 경우 why_hidden의 마지막 원소로 제목 결정 */
  // 차단한 사용자의 게시물인 경우
  else if (articleModel.why_hidden[targetIdx] == "BLOCKED_USER_CONTENT") {
    return '차단한 사용자의 게시물입니다.';
  }
  // 정치글인 경우
  else if (articleModel.why_hidden[targetIdx] == "SOCIAL_CONTENT") {
    return '정치/사회성 내용의 게시물입니다.';
  }
  // 성인글인 경우
  else if (articleModel.why_hidden[targetIdx] == "ADULT_CONTENT") {
    return '성인/음란성 내용의 게시물입니다.';
  }
  // 그 외의 경우
  // TODO: 새로운 경우 나올때마다 조건에 추가해놓기
  else {
    return '숨겨진 게시물입니다.';
  }
}