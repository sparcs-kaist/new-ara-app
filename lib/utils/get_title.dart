/// ArticleModel의 why_hidden에 사용가능한 사유 모음
/// BE에서 변경할 수 있으므로 주기적인 확인 필요.
List<String> hiddenReason = [
  "REPORTED_CONTENT",  // 신고당한 게시물
  "BLOCKED_USER_CONTENT",  // 차단한 사용자의 게시물
  "ADULT_CONTENT",  // 성인 게시물
  "SOCIAL_CONTENT",  // 정치 게시물
  "ACCESS_DENIED_CONTENT"  // BE에서 안전상 만들어둔 것 (거의 쓰이지 않음)
];

/// hiddenReason의 인덱스에 따라 대응되는 한글 사유
List<String> hiddenReasonDesc = [
  "신고당한 게시물입니다.",
  "차단한 사용자의 게시물입니다.",
  "성인/음란성 내용의 게시물입니다.",
  "정치/사회성 내용의 게시물입니다.",
  "숨겨진 게시물입니다."
];

/// 글 정보를 입력받고 그에 상태에 따라 적절한 제목을 리턴하는 함수.
/// UserViewPage, UserPage, PostListShowPage, PostViewPage에서 사용함.
String getTitle(String? orignialTitle, bool isHidden, List<dynamic> whyHidden) {
  /* 숨겨진 글이 아닐 경우 */
  if (isHidden == false) {
    return orignialTitle.toString();
  }
  /* 숨겨졌으나 why_hidden이 지정되지 않은 경우. 혹시 모를 에러 방지를 위해 추가함. */
  else if (whyHidden.isEmpty) {
    return '숨겨진 게시물입니다.';
  }
  for (int i = 0; i < hiddenReason.length; i++) {
    if (whyHidden[0] == hiddenReason[i]) {
      return hiddenReasonDesc[i];
    }
  }
  // 원래 여기까지 오면 안되지만 혹시 모를 에러 방지를 위해서
  return '숨겨진 게시물입니다.';
}
