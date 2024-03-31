import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/constants/colors_info.dart';

enum WithSchoolStatus { beforeUpVoteThreshold, beforeSchoolConfirm, answerDone }

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

bool isBeforeUpVoteThreshold(int? communicationArticleStatus) {
  return communicationArticleStatus ==
      WithSchoolStatus.beforeUpVoteThreshold.index;
}

bool isBeforeSchoolConfirm(int? communicationArticleStatus) {
  return communicationArticleStatus ==
      WithSchoolStatus.beforeSchoolConfirm.index;
}

bool isAnswerDone(int? communicationArticleStatus) {
  return communicationArticleStatus == WithSchoolStatus.answerDone.index;
}

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
