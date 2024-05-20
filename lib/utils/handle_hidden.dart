import 'package:flutter/material.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// 게시글 정보를 입력받고 그에 상태에 따라 적절한 제목을 리턴하는 함수.
  /// UserViewPage, UserPage, PostListShowPage, PostViewPage에서 사용함.
  String getTitle(
      String? orignialTitle, bool isHidden, List<dynamic> whyHidden) {
    // 숨겨진 글이 아닌 경우
    if (isHidden == false) {
      return orignialTitle.toString();
    }
    // 숨겨졌으나 why_hidden이 지정되지 않은 경우. 혹시 모를 에러 방지를 위해 추가함.
    else if (whyHidden.isEmpty) {
      return LocaleKeys.postPreview_hiddenPost.tr();
    }

    // TODO: 새로운 사유가 있을 경우 코드에 반영하기.
    late String title;
    switch (whyHidden[0]) {
      case "REPORTED_CONTENT":
        title = LocaleKeys.postPreview_reportedPost.tr();
        break;
      case "BLOCKED_USER_CONTENT":
        title = LocaleKeys.postPreview_blockedUsersPost.tr();
        break;
      case "ADULT_CONTENT":
        title = LocaleKeys.postPreview_adultPost.tr();
        break;
      case "SOCIAL_CONTENT":
        title = LocaleKeys.postPreview_socialPost.tr();
        break;
      case "ACCESS_DENIED_CONTENT":
        title = LocaleKeys.postPreview_accessDeniedPost.tr();
        break;
      // 새로운 whyHidden에 대해서는 숨겨진 게시글로 표기. 이후 앱에서 반영해줘야 함.
      default:
        debugPrint(
            "\n***********************\nANOTHER HIDDEN REASON FOUND: ${whyHidden[0]}\n***********************\n");
        title = LocaleKeys.postPreview_hiddenPost.tr();
    }

    return title;
  }

  /// Article 모델의 why_hidden 값을 입력으로 받아 해당하는 모든 사유에 대한 내용을 담은 리스트를 반환
  /// PostViewPage에서 숨김, 차단된 글에 사용됨.
  List<String> getAllHiddenReasons(List<dynamic> whyHidden, Locale locale) {
    List<String> reasons = [];

    for (String reason in whyHidden) {
      // TODO: hiddenReasons에 없는 사유가 있을 경우 코드에 반영하기.
      reasons.add(getTitle("", true, [reason]));
    }

    return reasons;
  }

  /// is_hidden이 True인 댓글에 대해 숨김 사유를 리턴하는 함수
  /// PostViewPage에서 숨겨진 댓글의 내용을 표시할 때 사용됨.
  String getHiddenCommentReasons(List<dynamic> whyHidden, Locale locale) {
    // 예기치 못한 에러 방지를 위해 추가함
    if (whyHidden.isEmpty) {
      return LocaleKeys.postViewPage_hiddenComment.tr();
    }

    late String hiddenReason;
    switch (whyHidden[0]) {
      case "REPORTED_CONTENT":
        hiddenReason = LocaleKeys.postViewPage_reportedComment.tr();
        break;
      case "BLOCKED_USER_CONTENT":
        hiddenReason = LocaleKeys.postViewPage_blockedUsersComment.tr();
        break;
      case "DELETED_CONTENT":
        hiddenReason = LocaleKeys.postViewPage_deletedComment.tr();
        break;
      default:
        debugPrint(
            "\n***********************\nANOTHER HIDDEN REASON FOUND: ${whyHidden[0]}\n***********************\n");
        hiddenReason = LocaleKeys.postViewPage_hiddenComment.tr();
        break;
    }

    return hiddenReason;
  }

  /// 사용자에게 숨겨진 글 관련 설정 방법을 알려주는 함수.
  String getHiddenInfo(List<dynamic> whyHidden) {
    // 숨김 사유가 없을 경우
    if (whyHidden.isEmpty) return "";

    late String hiddenInfo;

    switch (whyHidden[0]) {
      case "BLOCKED_USER_CONTENT":
        hiddenInfo = LocaleKeys.postViewPage_blockedUsersContentNotice.tr();
        break;
      case "ADULT_CONTENT":
      case "SOCIAL_CONTENT":
        hiddenInfo = LocaleKeys.postViewPage_adultContentNotice.tr();
        break;
      default:
        hiddenInfo = "";
        break;
    }

    return hiddenInfo;
  }