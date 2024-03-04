// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "boardListPage": {
    "boards": "Boards",
    "searchBoardsPostsComments": "Search boards, posts, and comments",
    "viewAll": "View All",
    "topPosts": "Top Posts",
    "bookmarks": "Bookmarks"
  },
  "bulletinSearchPage": {
    "searchIn": "Search in {en_name}",
    "searchInAllPosts": "Search in all posts",
    "searchInHistory": "Search in recently viewed posts",
    "searchInTopPosts": "Search in real-time popular posts",
    "searchInBookmarks": "Search in saved posts",
    "search": "Search",
    "pleaseEnter": "Please enter a search term",
    "noResults": "No results found."
  },
  "inquiryPage": {
    "title": "Inquiries and Suggestions",
    "reLoginErrorWithWithdrawalGuide": "This account has already been withdrawn.\nIf you wish to re-register, please click this link to contact us via email.",
    "reLoginErrorWithWithdrawalEmailTitle": "Re-registration Inquiry",
    "reLoginErrorWithWithdrawalEmailContents": "If you have any additional comments, please write them below.\n\n※ An Ara administrator will respond within 48 hours.※\n\nUser ID: {userID}\nNickname: {nickname}\nEmail: {email}\nPlatform: App\n"
  },
  "loginPage": {
    "login": "Sign in with SPARCS SSO"
  },
  "mainPage": {
    "topPost": "Top Posts",
    "notice": "Notice",
    "portalNotice": "Portal Notice",
    "facility": "Facility",
    "araAdmins": "Ara Admins",
    "trades": "Trades",
    "realEstate": "Real Estate",
    "market": "Market",
    "jobsWanted": "Jobs Wanted",
    "organizationsAndClubs": "Organizations and Clubs",
    "gradAssoc": "Grad Assoc",
    "undergradAssoc": "Undergrad Assoc",
    "freshmanCouncil": "Freshman Council",
    "talk": "Talk"
  },
  "notificationPage": {
    "notifications": "Notifications",
    "noNotifications": "No notifications.",
    "today": "Today",
    "post": "Post",
    "newComment": "New comment to your post.",
    "allNotificationsChecked": "You've already check all the notifications."
  },
  "postListShowPage": {
    "boards": "Boards",
    "history": "History",
    "topPosts": "Top Posts",
    "allPosts": "All Posts",
    "bookmarks": "Bookmarks",
    "testBoard": "Test Board"
  },
  "settingPage": {
    "title": "Setting",
    "postSetting": "Post Setting",
    "adult": "Allow Access to Sexual Posts",
    "politics": "Allow Access to Political Posts",
    "block": "Blocked Users",
    "viewBlockedUsers": "View Blocked Users",
    "howToBlock": "You can block accounts through the detail function in posts or comments.",
    "information": "Information",
    "termsAndConditions": "Terms and Conditions of Service",
    "contactAdmins": "Contact the Admins",
    "signOut": "Sign out",
    "withdrawal": "Withdrawal",
    "withdrawalGuide": "Membership withdrawal will be processed after confirmation by the Ara administrator, and it may take up to 24 hours.",
    "userBlockingGuide": "User blocking can be done through the 'More' option in posts. You can change it up to 10 times per day.",
    "settingsSaved": "The settings have been saved.",
    "errorSavingSettings": "An error occurred, and the settings could not be applied. Please try again.",
    "myReplies": "Comments and Nested Comments of My Posts",
    "replies": "Nested Comments",
    "hotNotifications": "Hot Notifications",
    "hotPosts": "Hot Posts",
    "hotInfo": "We deliver hot announcements and posts every day at 8:30 a.m.",
    "emailNotAvailable": "The default mail application cannot be opened, please contact ara@sparcs.org ."
  },
  "userPage": {
    "change": "Chg.",
    "myPosts": "My Posts",
    "bookmarks": "Scrapped",
    "history": "History",
    "totalNPosts": "{curCount} posts",
    "noEmailInfo": "No email information"
  },
  "postViewPage": {
    "reply": "Reply",
    "scrap": "Scrap",
    "scrapped": "Scrapped",
    "share": "Share",
    "launchInBrowserNotAvailable": "The URL could not be opened by browser.",
    "blockedUsersPost": "This post was written by blocked user.",
    "showHiddenPosts": "Show hidden posts",
    "hit": "Hit",
    "noSelfVotingInfo": "You cannot vote for your post or comment!",
    "failedToBlock": "Failed to block.",
    "unblock": "Unblock",
    "block": "Block",
    "delete": "Delete",
    "report": "Report",
    "edit": "Edit",
    "blockedUsersComment": "This comment was written by blocked user.",
    "commentHintText": "Type your comment here.",
    "noCommentWarning": "No comment has been written!",
    "displayCommentCount": " comments",
    "copyLinkToClipBoard": "Copied URL to the clipboard."
  },
  "postViewUtils": {
    "letUsKnowPostReportReason": "Let us know your reason for reporting the post.",
    "letUsKnowCommentReportReason": "Let us know your reason for reporting the comment.",
    "reportPostSucceed": "Post is successfully reported.",
    "alreadyReported": "You've already report this post.",
    "reportButton": "Report",
    "cancel": "Cancel"
  },
  "dialogs": {
    "deleteConfirm": "Do you really want to delete this post?",
    "blockConfirm": "Do you really want to block this user?",
    "logoutConfirm": "Do you really want to sign out?",
    "withdrawalConfirm": "Do you really want to withdraw the membership?",
    "withdrawalEmailInfo": "If you leave the membership, you can't re-sign up with the email you're using now",
    "cancel": "Cancel",
    "confirm": "OK",
    "noBlockedUsers": "There are no blocked users.",
    "noNickname": "No nickname"
  },
  "popUpMenuButtons": {
    "downloadSucceed": "Downloading File succeed",
    "downloadFailed": "Downloading File failed",
    "attachments": "Attachments",
    "report": "Report",
    "edit": "Edit",
    "delete": "Delete"
  },
  "postPreview": {
    "blockedUsersPost": "This post was written by blocked user."
  },
  "profileEditPage": {
    "settingInfoText": "There was a problem changing the settings.",
    "editProfile": "Edit Profile",
    "complete": "Complete",
    "nickname": "Nickname",
    "email": "Email",
    "noEmail": "Email not exist",
    "nicknameInfo": "Once you change your nickname, you can't change it for three months.",
    "nicknameHintText": "Please enter the nickname you want to change.",
    "nicknameEmptyInfo": "Nickname not written!"
  }
};
static const Map<String,dynamic> ko = {
  "boardListPage": {
    "boards": "게시판",
    "searchBoardsPostsComments": "게시판, 게시글 및 댓글 검색",
    "viewAll": "전체보기",
    "topPosts": "인기글",
    "bookmarks": "담아둔 글"
  },
  "bulletinSearchPage": {
    "searchIn": "{koName}에서 검색",
    "searchInAllPosts": "전체 보기에서 검색",
    "searchInHistory": "최근 본 글에서 검색",
    "searchInTopPosts": "실시간 인기글에서 검색",
    "searchInBookmarks": "담아둔 글에서 검색",
    "pleaseEnter": "검색어를 입력하세요",
    "search": "검색",
    "noResults": "검색 결과가 없습니다."
  },
  "inquiryPage": {
    "title": "문의 및 건의",
    "reLoginErrorWithWithdrawalGuide": "이미 탈퇴 했던 계정입니다.\n재가입을 하고 싶다면 이 링크를 눌러 이메일로 문의하세요.",
    "reLoginErrorWithWithdrawalEmailTitle": "재가입 문의",
    "reLoginErrorWithWithdrawalEmailContents": "추가로 말하실 말이 있다면 여기 아래에 적어주세요.\n\n※ Ara 관리자가 48시간 이내로 답변드립니다.※\n\n유저 번호: {userID}\n닉네임: {nickname}\n이메일: {email}\n플랫폼: App\n"
  },
  "loginPage": {
    "login": "SPARCS SSO로 로그인"
  },
  "mainPage": {
    "topPost": "실시간 인기글",
    "notice": "공지",
    "portalNotice": "포탈 공지",
    "facility": "입주 업체",
    "araAdmins": "Ara 운영진",
    "trades": "거래",
    "realEstate": "부동산",
    "market": "중고거래",
    "jobsWanted": "구인구직",
    "organizationsAndClubs": "학생 단체",
    "gradAssoc": "원총",
    "undergradAssoc": "총학",
    "freshmanCouncil": "새학",
    "talk": "자유게시판"
  },
  "notificationPage": {
    "notifications": "알림",
    "noNotifications": "알림이 없습니다.",
    "today": "오늘",
    "post": "게시물",
    "newComment": "회원님의 게시물에 새로운 댓글이 작성되었습니다.",
    "allNotificationsChecked": "이미 알림을 모두 읽으셨습니다."
  },
  "postListShowPage": {
    "boards": "게시판",
    "history": "최근 본 글",
    "topPosts": "실시간 인기글",
    "allPosts": "전체보기",
    "bookmarks": "담아둔 글",
    "testBoard": "테스트 게시판"
  },
  "settingPage": {
    "title": "설정",
    "postSetting": "게시글 설정",
    "adult": "성인글 보기",
    "politics": "정치글 보기",
    "block": "차단",
    "viewBlockedUsers": "차단한 유저 목록",
    "howToBlock": "유저 차단은 게시글이나 댓글에서 더보기 기능을 통해 가능합니다.",
    "information": "정보",
    "termsAndConditions": "이용약관",
    "contactAdmins": "운영진에게 문의하기",
    "signOut": "로그아웃",
    "withdrawal": "회원탈퇴",
    "withdrawalGuide": "회원 탈퇴는 Ara 관리자가 확인 후 처리해드리며, 최대 24시간이 소요될 수 있습니다.",
    "userBlockingGuide": "유저 차단은 게시글의 '더보기' 기능에서 하실 수 있습니다. 하루에 최대 10번만 변경 가능합니다.",
    "settingsSaved": "설정이 저장되었습니다.",
    "errorSavingSettings": "에러가 발생하여 설정 반영에 실패했습니다. 다시 시도해주십시오.",
    "myReplies": "내 글에 달린 댓글 및 대댓글",
    "replies": "댓글에 달린 대댓글",
    "hotNotifications": "인기 공지글",
    "hotPosts": "인기글",
    "hotInfo": "인기 공지글 및 인기 글을 매일 오전 8시 30분에 전달해 드립니다.",
    "emailNotAvailable": "기본 메일 어플리케이션을 열 수 없습니다. ara@sparcs.org로 문의 부탁드립니다."
  },
  "userPage": {
    "change": "수정",
    "myPosts": "작성한 글",
    "bookmarks": "담아둔 글",
    "history": "최근 본 글",
    "totalNPosts": "총 {curCount}개의 글",
    "noEmailInfo": "이메일 정보가 없습니다."
  },
  "postViewPage": {
    "reply": "답글 쓰기",
    "scrap": "담아두기",
    "scrapped": "담아둔 글",
    "share": "공유",
    "launchInBrowserNotAvailable": "브라우저로 URL을 열 수 없습니다.",
    "blockedUsersPost": "차단한 사용자의 게시물입니다.",
    "showHiddenPosts": "숨긴내용 보기",
    "hit": "조회",
    "noSelfVotingInfo": "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다.",
    "failedToBlock": "차단에 실패했습니다.",
    "unblock": "차단 해제",
    "block": "차단",
    "delete": "삭제",
    "report": "신고",
    "edit": "수정",
    "blockedUsersComment": "차단한 사용자의 댓글입니다.",
    "commentHintText": "댓글을 입력해주세요.",
    "noCommentWarning": "댓글이 작성되지 않았습니다!",
    "displayCommentCount": "개의 댓글",
    "copyLinkToClipBoard": "URL을 클립 보드에 복사했습니다."
  },
  "postViewUtils": {
    "letUsKnowPostReportReason": "게시글 신고 사유를 알려주세요.",
    "letUsKnowCommentReportReason": "댓글 신고 사유를 알려주세요.",
    "reportPostSucceed": "해당 게시글을 신고했습니다.",
    "alreadyReported": "이미 신고한 게시글입니다.",
    "reportButton": "신고하기",
    "cancel": "취소"
  },
  "dialogs": {
    "deleteConfirm": "정말로 삭제하시겠습니까?",
    "blockConfirm": "정말로 차단하시겠습니까?",
    "logoutConfirm": "정말로 로그아웃 하시겠습니까?",
    "withdrawalConfirm": "정말로 회원탈퇴 하시겠습니까?",
    "withdrawalEmailInfo": "회원탈퇴하시면 지금 쓰시는 이메일로는 재가입이 불가능합니다",
    "cancel": "취소",
    "confirm": "확인",
    "noBlockedUsers": "차단한 유저가 없습니다.",
    "noNickname": "닉네임이 없음"
  },
  "popUpMenuButtons": {
    "downloadSucceed": "파일 다운로드에 성공했습니다",
    "downloadFailed": "파일 다운로드에 실패했습니다",
    "attachments": "첨부파일 모아보기",
    "report": "신고",
    "edit": "수정",
    "delete": "삭제"
  },
  "postPreview": {
    "blockedUsersPost": "차단한 사용자의 게시물입니다."
  },
  "profileEditPage": {
    "settingInfoText": "설정 변경 중 문제가 발생했습니다.",
    "editProfile": "프로필 수정",
    "complete": "완료",
    "nickname": "닉네임",
    "email": "이메일",
    "noEmail": "이메일 정보가 없습니다.",
    "nicknameInfo": "닉네임은 한번 변경할 시 3개월간 변경이 불가합니다.",
    "nicknameHintText": "변경하실 닉네임을 입력해주세요.",
    "nicknameEmptyInfo": "닉네임이 작성되지 않았습니다!"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ko": ko};
}
