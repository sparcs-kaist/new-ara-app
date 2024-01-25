/// 글 정보를 입력받고 그에 상태에 따라 적절한 제목을 리턴하는 함수.
/// UserViewPage, UserPage, PostListShowPage, PostViewPage에서 사용함.
String getTitle(String? orignialTitle, bool isHidden, List<dynamic> whyHidden) {
  // 글 제목은 ArticleListActionModel why_hidden의 마지막 원소에 따라 결정됨
  int targetIdx = whyHidden.length - 1;

  /* 숨겨진 글이 아닐 경우 */
  if (isHidden == false) {
    return orignialTitle.toString();
  }
  /* 숨겨졌으나 why_hidden이 지정되지 않은 경우 */
  // TODO: 이 경우가 실제로 가능한지 확인해보기
  else if (targetIdx == -1) {
    return '숨겨진 게시물입니다.';
  }
  /* 숨겨졌으며 why_hidden이 지정된 경우 why_hidden의 마지막 원소로 제목 결정 */
  // 차단한 사용자의 게시물인 경우
  else if (whyHidden[targetIdx] == "BLOCKED_USER_CONTENT") {
    return '차단한 사용자의 게시물입니다.';
  }
  // 정치글인 경우
  else if (whyHidden[targetIdx] == "SOCIAL_CONTENT") {
    return '정치/사회성 내용의 게시물입니다.';
  }
  // 성인글인 경우
  else if (whyHidden[targetIdx] == "ADULT_CONTENT") {
    return '성인/음란성 내용의 게시물입니다.';
  }
  // 그 외의 경우
  // TODO: 새로운 경우 나올때마다 조건에 추가해놓기
  else {
    return '숨겨진 게시물입니다.';
  }
}