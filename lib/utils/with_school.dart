import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/constants/colors_info.dart';

/// ArticleModel의 communication_article_status가 가질 수 있는 값 0, 1, 2에 각각 대응되도록 enum 선언.
/// beforeUpVoteThreshold: 0, '달성 전'
/// beforeSchoolconfirm: 1, '답변 대기 중'
/// answerDone: 2, '답변 완료'
/// 가독성을 위해 추가함.
enum WithSchoolStatus { beforeUpVoteThreshold, beforeSchoolConfirm, answerDone }

/// magicNum: communication_article_status 값 (0, 1, 2 중 하나)
/// magincNum을 입력받고 '달성 전', '답변 대기 중', '답변 완료' 중 하나를 알맞게 리턴함.
String defineCommunicationStatus(int? magicNum) {
  late String status;
  if (magicNum == WithSchoolStatus.beforeUpVoteThreshold.index) {
    status = LocaleKeys.postPreview_beforeUpVoteThreshold.tr();
  } else if (magicNum == WithSchoolStatus.beforeSchoolConfirm.index) {
    status = LocaleKeys.postPreview_beforeSchoolConfirm.tr();
  } else if (magicNum == WithSchoolStatus.answerDone.index) {
    status = LocaleKeys.postPreview_answerDone.tr();
  } else {
    // 위 경우에 해당하지 않는 경우에는 우선 '달성 전'으로 표기
    debugPrint("with-school status: undefined status $magicNum");
    status = LocaleKeys.postPreview_beforeUpVoteThreshold.tr();
  }

  return status;
}

/// communicationArticleStatus를 전달받고 '달성 전' 상태인지 여부를 리턴
/// '달성 전' 상태이면 true, 아니면 false.
bool isBeforeUpVoteThreshold(int? communicationArticleStatus) {
  return communicationArticleStatus ==
      WithSchoolStatus.beforeUpVoteThreshold.index;
}

/// communicationArticleStatus를 전달받고 '답변 대기 중' 상태인지 여부를 리턴
/// '답변 대기 중' 상태이면 true, 아니면 false.
bool isBeforeSchoolConfirm(int? communicationArticleStatus) {
  return communicationArticleStatus ==
      WithSchoolStatus.beforeSchoolConfirm.index;
}

/// communicationArticleStatus를 전달받고 '답변 완료' 상태인지 여부를 리턴.
/// '답변 완료' 상태이면 true, 아니면 false 리턴.
bool isAnswerDone(int? communicationArticleStatus) {
  return communicationArticleStatus == WithSchoolStatus.answerDone.index;
}

/// PostViewPage에 communicationArticleStatus에 맞게 텍스트가 추가된 위젯을 리턴
/// PostViewPage에서만 사용함.
Widget buildWithSchoolStatusBox(int? communicationArticleStatus) {
  return Row(
    children: [
      const SizedBox(width: 10),
      Container(
        decoration: BoxDecoration(
            color: isAnswerDone(communicationArticleStatus)
                ? ColorsInfo.newara
                : Colors.white,
            border: Border.all(
                color: isBeforeUpVoteThreshold(communicationArticleStatus)
                    ? const Color(0xFFBBBBBB)
                    : ColorsInfo.newara,
                width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
            child: Text(
              defineCommunicationStatus(communicationArticleStatus),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isBeforeUpVoteThreshold(communicationArticleStatus)
                    ? const Color(0xFFBBBBBB)
                    : (isBeforeSchoolConfirm(communicationArticleStatus)
                        ? ColorsInfo.newara
                        : Colors.white),
              ),
            )),
      ),
    ],
  );
}
