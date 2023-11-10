/// PostViewPage의 글/댓글 신고, 댓글 수정에 사용되는 Dialog 위젯 파일.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';

/// 신고 기능이 글, 댓글 모두에게 필요하여 만든 위젯.
class ReportDialog extends StatefulWidget {
  /// 글에 대한 신고일 경우 null이 아님.
  final int? articleID;

  /// 댓글에 대한 신고일 경우 null이 아님.
  final int? commentID;
  const ReportDialog({super.key, this.articleID, this.commentID});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  /// 신고 사유 내역을 나타냄.
  List<String> reportContents = [
    "hate_speech",
    "unauthorized_sales_articles",
    "spam",
    "fake_information",
    "defamation",
    "other"
  ];

  /// 신고 사유 내역을 한국어로 나타냄.
  List<String> reportContentKor = [
    "혐오 발언",
    "허가되지 않은 판매글",
    "스팸",
    "거짓 정보",
    "명예훼손",
    "기타"
  ];

  /// 각각의 신고 내역에 대해 선택되었는지 여부를 나타냄.
  late List<bool> isChosen;

  @override
  void initState() {
    super.initState();
    isChosen = [false, false, false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 380,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/information.svg",
              width: 45,
              height: 45,
              color: ColorsInfo.newara,
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.articleID == null ? '댓글' : '게시글'} 신고 사유를 알려주세요.',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildReportButton(0),
            const SizedBox(height: 10),
            _buildReportButton(1),
            const SizedBox(height: 10),
            _buildReportButton(2),
            const SizedBox(height: 10),
            _buildReportButton(3),
            const SizedBox(height: 10),
            _buildReportButton(4),
            const SizedBox(height: 10),
            _buildReportButton(5),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상을 빨간색으로 지정
                        width: 1, // 테두리의 두께를 2로 지정
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    postReport().then((res) {
                      debugPrint("신고가 ${res ? '성공' : '실패'}하였습니다.");
                      if (res) Navigator.pop(context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara.withOpacity((isChosen[0] ||
                              isChosen[1] ||
                              isChosen[2] ||
                              isChosen[3] ||
                              isChosen[4] ||
                              isChosen[5])
                          ? 1
                          : 0.5),
                    ),
                    width: 100,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '신고하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 신고 내역을 API 요청을 통해 서버에 보내는 역할.
  Future<bool> postReport() async {
    if (!isChosen[0] &&
        !isChosen[1] &&
        !isChosen[2] &&
        !isChosen[3] &&
        !isChosen[4] &&
        !isChosen[5]) {
      // 나중에 알림 해주기
      return false;
    }
    String reportContent = "";
    for (int i = 0; i < 6; i++) {
      if (!isChosen[i]) continue;
      if (reportContent != "") reportContent += ", ";
      reportContent += reportContents[i];
    }
    debugPrint("reportContent: $reportContent");
    Map<String, dynamic> defaultPayload = {
      "content": reportContent,
      "type": "others",
    };
    defaultPayload.addAll(widget.articleID == null
        ? {"parent_comment": widget.commentID ?? 0}
        : {"parent_article": widget.articleID ?? 0});
    UserProvider userProvider = context.read<UserProvider>();
    try {
      await userProvider.postApiRes(
        "reports/",
        payload: defaultPayload,
      );
    } catch (error) {
      debugPrint("postReport() failed with error: $error");
      return false;
    }

    return true;
  }

  // 각각의 신고항목에 대한 button
  InkWell _buildReportButton(int idx) {
    return InkWell(
      onTap: () {
        if (!mounted) return;
        setState(() => isChosen[idx] = !isChosen[idx]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: isChosen[idx]
              ? ColorsInfo.newara
              : const Color.fromRGBO(220, 220, 220, 1),
        ),
        width: 180,
        height: 40,
        child: Center(
          child: Text(
            reportContentKor[idx],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isChosen[idx] ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// TODO: 글 삭제 지원
/// PostViewPage의 댓글 삭제 기능에 사용되는 Dialog
class DeleteDialog extends StatelessWidget {
  // TODO: 안 쓰이는 필드 삭제하기

  /// 삭제되는 글/댓글의 id
  final int targetID;
  final UserProvider userProvider;
  /// PostViewPage의 context. 
  final BuildContext targetContext;
  /// '확인' 버튼을 눌렀을 때 적용되는 onTap 메서드
  final void Function()? onTap;

  const DeleteDialog({
    super.key,
    required this.targetID,
    required this.userProvider,
    required this.targetContext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        width: 350,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/information.svg',
              width: 55,
              height: 55,
              color: ColorsInfo.newara,
            ),
            const Text(
              '정말로 삭제하시겠습니까?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // PostViewPage에서 pop해야 하므로
                    // targetContext 사용.
                    Navigator.pop(targetContext);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    width: 60,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  // 인자로 전달받은 onTap 사용.
                  onTap: onTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorsInfo.newara,
                    ),
                    width: 60,
                    height: 40,
                    child: const Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  
  }
}