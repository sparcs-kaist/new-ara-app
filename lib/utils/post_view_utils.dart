// PostViewPage 내부에서 사용되는 메서드가 많아 별도의 파일로 분류함.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class ArticleController {
  ArticleModel model;
  UserProvider userProvider;

  ArticleController({
    required this.model,
    required this.userProvider,
  });

  /// 글에 대한 좋아요 및 좋아요 취소를 해주는 메서드.
  /// 요청이 성공하면 true, 아닌 경우 false를 리턴함.
  Future<bool> posVote() async {
    if (model.is_mine) return false;
    int id = model.id;
    if (model.my_vote == true) {
      try {
        await userProvider.postApiRes(
          'articles/$id/vote_cancel/',
        );
      } catch (e) {
        debugPrint("posVote() failed: $e");
        return false;
      }
    } else {
      try {
        await userProvider.postApiRes('articles/$id/vote_positive/');
      } catch (e) {
        debugPrint("posVote() failed: $e");
        return false;
      }
    }
    return true;
  }

  /// 글에 대한 싫어요, 싫어요 취소를 해주는 메서드
  /// 요청이 성공하면 true, 실패하면 false를 리턴.
  Future<bool> negVote() async {
    if (model.is_mine == true) return false;
    int id = model.id;
    if (model.my_vote == false) {
      try {
        await userProvider.postApiRes(
          "articles/$id/vote_cancel/",
        );
      } catch (e) {
        debugPrint("negVote() failed: $e");
        return false;
      }
    } else {
      try {
        await userProvider.postApiRes(
          "articles/$id/vote_negative/",
        );
      } catch (e) {
        debugPrint("negVote() failed: $e");
        return false;
      }
    }
    return true;
  }

  /// 멤버 변수 model 내부의
  /// 좋아요, 싫어요 상태를 [value]에 맞게 한번에 업데이트.
  /// value: true = 좋아요, false = 싫어요
  void setVote(bool value) {
    /* positive_vote_count, negative_vote_count 모두 int?
       타입이므로 null일 경우 0으로 초기화함. */
    model.positive_vote_count ??= 0;
    model.negative_vote_count ??= 0;

    /* 이미 좋아요한 경우 좋아요 취소,
       아닌 경우 value에 따라 좋아요 추가 혹은 현상태 유지. */
    model.positive_vote_count = model.positive_vote_count! +
        (model.my_vote == true ? -1 : (value ? 1 : 0));

    /* 이미 싫어요한 경우 싫어요 취소,
       아닌 경우 value에 따라 싫어요 추가 혹은 현상태 유지. */
    model.negative_vote_count = model.negative_vote_count! +
        (model.my_vote == false ? -1 : (value ? 0 : 1));

    /* 현재 사용자의 상태(true, false, null)를 업데이트함. */
    model.my_vote = (model.my_vote == value) ? null : value;
  }

  /// 글에 대한 스크랩, 스크랩 취소 기능을 담당하는 메서드.
  /// 스크랩 관련 API 요청이 성공하면 true, 실패하면 false를 반환.
  Future<bool> scrap() async {
    if (model.my_scrap == null) {
      var postRes = await userProvider.postApiRes(
          "scraps/",
          data: {
            "parent_article": model.id,
          },
        );
      if (postRes != null) {
        model.my_scrap = ScrapCreateActionModel.fromJson(postRes.data);
      }
      else {
        debugPrint("scrap() failed");
        return false;
      }
    } else {
      var delRes = await userProvider.delApiRes("scraps/${model.my_scrap!.id}/");
      if (delRes != null) {
        model.my_scrap = null;
      }
      else {
        debugPrint("scrap() failed");
        return false;
      }
    }
    return true;
  }

  /// 글에 대한 공유 기능을 담당하는 메서드.
  /// 클립보드에 글의 링크를 복사해줌.
  Future<void> share() async {
    String url = "$newAraDefaultUrl/post/${model.id}";
    await Clipboard.setData(ClipboardData(text: url));
  }

  // TODO: dio 요청 방식 통일하기

  /// 전달받은 id에 해당하는 글을 삭제하는 메서드.
  /// 삭제가 정상적으로 완료되면 true, 아니면 false 반환.
  Future<bool> delete() async {
    String apiUrl = "$newAraDefaultUrl/api/articles/${model.id}/";
    try {
      await userProvider.createDioWithHeadersForNonget().delete(apiUrl);
      return true;
    } on DioException catch (e) {
      debugPrint("DioException occurred");
      if (e.response != null) {
        debugPrint("${e.response!.data}");
        debugPrint("${e.response!.headers}");
        debugPrint("${e.response!.requestOptions}");
      }
      // request의 setting, sending에서 문제 발생
      // requestOption, message를 출력.
      else {
        debugPrint("${e.requestOptions}");
        debugPrint("${e.message}");
      }
    } catch (e) {
      debugPrint("error at delete: $e");
    }
    return false;
  }

  /// post의 작성자에 대한 차단 및 차단 해제 요청을 보내는 함수
  /// block이 true이면 차단, false이면 차단 해제 요청을 보냄
  /// 성공하면 true, 실패하면 false 리턴.
  Future<bool> handleBlock(bool block) async {
    String apiUrl = "$newAraDefaultUrl/api/blocks/";
    // 차단 해제하는 경우 apiUrl을 변경
    if (!block) apiUrl += "without_id/";

    int userID = model.created_by.id;

    try {
      await userProvider
          .createDioWithHeadersForNonget()
          .post(apiUrl, data: block ? {'user': userID} : {'blocked': userID});
      return true;
    } on DioException catch (e) {
      debugPrint("DioException occurred");
      if (e.response != null) {
        debugPrint("${e.response!.data}");
        debugPrint("${e.response!.headers}");
        debugPrint("${e.response!.requestOptions}");
      }
      // request의 setting, sending에서 문제 발생
      // requestOption, message를 출력.
      else {
        debugPrint("${e.requestOptions}");
        debugPrint("${e.message}");
      }
    } catch (e) {
      debugPrint("error on handleBlock: $e");
    }

    return false;
  }
}

class FileController {
  AttachmentModel model;
  UserProvider userProvider;

  FileController({
    required this.model,
    required this.userProvider,
  });

  /// 첨부파일 다운로드과정을 전체적으로 관리하는 메서드.
  /// 다운로드가 성공하면 true, 그렇지 않으면 false 리턴.
  Future<bool> download() async {
    String initFileName = Uri.parse(model.file).path.substring(7);
    late String targetDir;
    try {
      targetDir = await _getDownloadPath();
    } catch (error) {
      debugPrint("getDownloadPath failed: $error");
      return false;
    }
    String fileName = _addTimestampToFileName(initFileName);
    bool res = await _downloadFile(
        model.file, "$targetDir${Platform.pathSeparator}$fileName");
    return res;
  }

  /// 첨부파일이 다운로드될 경로를 플랫폼에 따라 리턴함.
  Future<String> _getDownloadPath() async {
    late Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      debugPrint("ios download path: ${directory.path}");
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory =
            (await getExternalStorageDirectory())!; // Android 에서는 존재가 보장됨
      }
      debugPrint("android download path: ${directory.path}");
    }
    return directory.path;
  }

  /// (2023.09.24)현재 뉴아라앱은 첨부파일 다운로드 시
  /// 파일명 뒤에 타임스탬프를 추가하여 같은 파일이 여러번 다운로드될 수 있도록 함.
  /// 이를 위해 타임스탬프가 추가된 파일명을 리턴하는 메서드.
  String _addTimestampToFileName(String fileName) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1) {
      String nameWithoutExtension = fileName.substring(0, dotIndex);
      String extension = fileName.substring(dotIndex + 1);
      return '$nameWithoutExtension-$timestamp.$extension';
    }
    return '$fileName-$timestamp';
  }

  /// 웹 상에서 [uri]에 위치한 파일을 [totalPath]로 다운로드해주는 함수.
  /// 다운로드가 성공하면 true, 그렇지 않으면 false 리턴.
  Future<bool> _downloadFile(String uri, String totalPath) async {
    try {
      await userProvider
          .createDioWithHeadersForNonget()
          .download(uri, totalPath);
    } catch (error) {
      return false;
    }
    return true;
  }
}

class CommentController {
  CommentNestedCommentListActionModel model;
  UserProvider userProvider;

  CommentController({
    required this.model,
    required this.userProvider,
  });

  /// 댓글에 대한 좋아요, 좋아요 취소 기능을 담당.
  Future<bool> posVote() async {
    if (model.is_mine) return false;
    int id = model.id;
    if (model.my_vote == true) {
      try {
        await userProvider.postApiRes(
          'comments/$id/vote_cancel/',
        );
      } catch (e) {
        debugPrint("posVote() failed: $e");
        return false;
      }
    } else {
      try {
        await userProvider.postApiRes('comments/$id/vote_positive/');
      } catch (e) {
        debugPrint("posVote() failed: $e");
        return false;
      }
    }
    return true;
  }

  /// 댓글에 대한 싫어요, 싫어요 취소 기능을 담당.
  Future<bool> negVote() async {
    if (model.is_mine == true) return false;
    int id = model.id;
    if (model.my_vote == false) {
      try {
        await userProvider.postApiRes(
          "comments/$id/vote_cancel/",
        );
      } catch (e) {
        debugPrint("negVote() failed: $e");
        return false;
      }
    } else {
      try {
        await userProvider.postApiRes(
          "comments/$id/vote_negative/",
        );
      } catch (e) {
        debugPrint("negVote() failed: $e");
        return false;
      }
    }
    return true;
  }

  /// API 요청을 통해 값이 변경될 때 모델의 값도 [value]에 맞게 설정하기
  /// 위해 만들어짐.
  void setVote(bool value) {
    model.positive_vote_count ??= 0;
    model.positive_vote_count = model.positive_vote_count! +
        (model.my_vote == true ? -1 : (value ? 1 : 0));
    model.negative_vote_count = model.negative_vote_count! +
        (model.my_vote == false ? -1 : (value ? 0 : 1));

    model.my_vote = (model.my_vote == value) ? null : value;
  }

  /// 댓글 삭제 기능을 위해 만들어진 메서드.
  /// 댓글 식별을 위한 [id], API 통신을 위한 [userProvider]를 전달받음.
  /// 댓글 삭제 API 요청이 성공하면 true, 그 외에는 false를 반환함.
  Future<bool> delComment(int id, UserProvider userProvider) async {
    try {
      await userProvider.delApiRes("comments/$id/");
      return true;
    } catch (error) {
      debugPrint("DELETE /api/comments/$id failed: $error");
      return false;
    }
  }
}

/// 신고 기능이 글, 댓글 모두에게 필요하여 만든 위젯.
class ReportDialogWidget extends StatefulWidget {
  /// 글에 대한 신고일 경우 null이 아님.
  final int? articleID;

  /// 댓글에 대한 신고일 경우 null이 아님.
  final int? commentID;
  const ReportDialogWidget({super.key, this.articleID, this.commentID});

  @override
  State<ReportDialogWidget> createState() => _ReportDialogWidgetState();
}

class _ReportDialogWidgetState extends State<ReportDialogWidget> {
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

  List<String> reportContentEng = [
    "Hate Speech",
    "Unauthorized Sales",
    "Spam",
    "Fake Information",
    "Defamation",
    "Other"
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
            SvgPicture.asset("assets/icons/information.svg",
                width: 45,
                height: 45,
                colorFilter: const ColorFilter.mode(
                  ColorsInfo.newara,
                  BlendMode.srcIn,
                )),
            const SizedBox(height: 5),
            Text(
              widget.articleID == null
                  ? LocaleKeys.postViewUtils_letUsKnowCommentReportReason.tr()
                  : LocaleKeys.postViewUtils_letUsKnowPostReportReason.tr(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
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
                    child: Center(
                      child: Text(
                        LocaleKeys.postViewUtils_cancel.tr(),
                        style: const TextStyle(
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
                      Navigator.pop(context);
                      // TODO: postApiRes의 response를 가져와서 신고에 실패한 경우
                      // e.response가 null이 아닐 경우에는 실패 사유도 출력하도록 변경하기
                      // 우선은 신고가 실패하면 무조건 '이미 신고한 게시물입니다'로 나오도록 함. (2023.02.16)
                      showInfoBySnackBar(
                          context,
                          res
                              ? LocaleKeys.postViewUtils_reportPostSucceed.tr()
                              : LocaleKeys.postViewUtils_alreadyReported.tr());
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
                    child: Center(
                      child: Text(
                        LocaleKeys.postViewUtils_reportButton.tr(),
                        style: const TextStyle(
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
        data: defaultPayload,
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
            context.locale == const Locale('ko')
                ? reportContentKor[idx]
                : reportContentEng[idx],
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
