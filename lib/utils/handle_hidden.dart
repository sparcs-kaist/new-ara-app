/// (2023.02.01) 현재 BE에 있는 모든 글 숨김 사유
/// BE가 변경되면 새로 확인해볼 필요 있음.
Map<String, String> hiddenReasons = {
  "REPORTED_CONTENT": "신고 누적으로 숨김된 게시물입니다.",
  "BLOCKED_USER_CONTENT": "차단한 사용자의 게시물입니다.",
  "ADULT_CONTENT": "성인/음란성 내용의 게시물입니다.",
  "SOCIAL_CONTENT": "정치/사회성 내용의 게시물입니다.",
  "ACCESS_DENIED_CONTENT": "접근 권한이 없는 게시물입니다." // BE에서 안전상 만들어둔 것으로 거의 쓰이지 않음
};

/// (2023.02.01) 현재 BE에 있는 글 숨김 사유에 따른 사용자 안내 메시지
Map<String, String> hiddenReasonNotices = {
  "REPORTED_CONTENT": "",
  "BLOCKED_USER_CONTENT": "차단 사용자 설정은 설정페이지에서 하실 수 있습니다.",
  "ADULT_CONTENT": "게시글 보기 설정은 설정페이지에서 하실 수 있습니다.",
  "SOCIAL_CONTENT": "게시글 보기 설정은 설정페이지에서 하실 수 있습니다.",
  "ACCESS_DENIED_CONTENT": "",
};

/// 글 정보를 입력받고 그에 상태에 따라 적절한 제목을 리턴하는 함수.
/// UserViewPage, UserPage, PostListShowPage, PostViewPage에서 사용함.
String getTitle(String? orignialTitle, bool isHidden, List<dynamic> whyHidden) {
  // 숨겨진 글이 아닌 경우
  if (isHidden == false) {
    return orignialTitle.toString();
  }
  // 숨겨졌으나 why_hidden이 지정되지 않은 경우. 혹시 모를 에러 방지를 위해 추가함.
  else if (whyHidden.isEmpty) {
    return '숨겨진 게시물입니다.';
  }

  // TODO: hiddenReasons에 없는 사유가 있을 경우 코드에 반영하기.
  return hiddenReasons[whyHidden[0]] ?? "숨겨진 게시물입니다.";
}

/// Article 모델의 why_hidden 값을 입력으로 받아 해당하는 모든 사유에 대한 내용을 담은 리스트를 반환
/// PostViewPage에서 숨김, 차단된 글에 사용됨.
List<String> getAllHiddenReasons(List<dynamic> whyHidden) {
  List<String> reasons = [];

  for (String reason in whyHidden) {
    // TODO: hiddenReasons에 없는 사유가 있을 경우 코드에 반영하기.
    reasons.add(hiddenReasons[reason] ?? "숨겨진 게시물입니다.");
  }

  return reasons;
}

/// 사용자에게 숨겨진 글에 대한 처리 방법을 알려주는 함수.
String getHiddenInfo(List<dynamic> whyHidden) {
  // 숨김 사유가 없을 경우
  if (whyHidden.isEmpty) return "";
  
  return hiddenReasonNotices[whyHidden[0]] ?? "";
}
