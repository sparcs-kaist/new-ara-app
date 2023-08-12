import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/comment_nested_comment_list_action_model.dart';
import 'package:new_ara_app/models/attachment_model.dart';
import 'package:new_ara_app/models/scrap_create_action_model.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/post_view_page.dart';

class ArticleController {
  ArticleModel model;
  UserProvider userProvider;

  ArticleController({
    required this.model,
    required this.userProvider,
  });

  Future<bool> posVote() async {
    if (model.is_mine) return false;
    int id = model.id;
    if (model.my_vote == true) {
      var cancelRes = await userProvider.postApiRes(
        "articles/$id/vote_cancel/",
      );
      if (cancelRes.statusCode != 200) return false;
    } else {
      var postRes = await userProvider.postApiRes(
        "articles/$id/vote_positive/",
      );
      if (postRes.statusCode != 200) return false;
    }
    _setVote(true);
    return true;
  }

  Future<bool> negVote() async {
    if (model.is_mine == true) return false;
    int id = model.id;
    if (model.my_vote == false) {
      var cancelRes = await userProvider.postApiRes(
        "articles/$id/vote_cancel/",
      );
      if (cancelRes.statusCode != 200) return false;
    } else {
      var postRes = await userProvider.postApiRes(
        "articles/$id/vote_negative/",
      );
      if (postRes.statusCode != 200) return false;
    }
    _setVote(false);
    return true;
  }

  void _setVote(bool value) {
    model.positive_vote_count ??= 0;
    model.positive_vote_count = model.positive_vote_count! +
        (model.my_vote == true ? -1 : (value ? 1 : 0));
    model.negative_vote_count = model.negative_vote_count! +
        (model.my_vote == false ? -1 : (value ? 0 : 1));
    model.my_vote = (model.my_vote == value)
        ? null
        : value;
  }

  Future<bool> scrap() async {
    if (model.my_scrap == null) {
      var postRes = await userProvider.postApiRes(
        "scraps/",
        payload: {"parent_article": model.id,},
      );
      if (postRes.statusCode != 201) return false;
      model.my_scrap = ScrapCreateActionModel.fromJson(postRes.data);
    } else {
      var delRes = await userProvider.delApiRes(
          "scraps/${model.my_scrap!.id}/");
      if (delRes.statusCode != 204) return false;
      model.my_scrap = null;
    }
    return true;
  }

  Future<void> share() async {
    String url = "$newAraDefaultUrl/post/${model.id}";
    await Clipboard.setData(ClipboardData(text: url));
  }
}

class FileController {
  AttachmentModel model;
  UserProvider userProvider;

  FileController({
    required this.model,
    required this.userProvider,
  });

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
    bool res = await _downloadFile(model.file, "$targetDir${Platform.pathSeparator}$fileName");
    return res;
  }

  Future<String> _getDownloadPath() async {
    late Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = (await getExternalStorageDirectory())!;  // Android 에서는 존재가 보장됨
      }
    }
    return directory.path;
  }

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

  Future<bool> _downloadFile(String uri, String totalPath) async {
    try {
      await userProvider.myDio().download(uri, totalPath);
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

  Future<bool> posVote() async {
    if (model.is_mine) return false;
    int id = model.id;
    if (model.my_vote == true) {
      var cancelRes = await userProvider.postApiRes(
        "comments/$id/vote_cancel/",
      );
      if (cancelRes.statusCode != 200) return false;
    } else {
      var postRes = await userProvider.postApiRes(
        "comments/$id/vote_positive/",
      );
      if (postRes.statusCode != 200) return false;
    }
    setVote(true);
    return true;
  }

  Future<bool> negVote() async {
    if (model.is_mine == true) return false;
    int id = model.id;
    if (model.my_vote == false) {
      var cancelRes = await userProvider.postApiRes(
        "comments/$id/vote_cancel/",
      );
      if (cancelRes.statusCode != 200) return false;
    } else {
      var postRes = await userProvider.postApiRes(
        "comments/$id/vote_negative/",
      );
      if (postRes.statusCode != 200) return false;
    }
    setVote(false);
    return true;
  }

  void setVote(bool value) {
    model.positive_vote_count ??= 0;
    model.positive_vote_count = model.positive_vote_count! +
        (model.my_vote == true ? -1 : (value ? 1 : 0));
    model.negative_vote_count = model.negative_vote_count! +
        (model.my_vote == false ? -1 : (value ? 0 : 1));
    model.my_vote = (model.my_vote == value)
        ? null
        : value;
  }
}

class ReportDialogWidget extends StatefulWidget {
  final int? articleID, commentID;
  const ReportDialogWidget({super.key, this.articleID, this.commentID});

  @override
  State<ReportDialogWidget> createState() => _ReportDialogWidgetState();
}

class _ReportDialogWidgetState extends State<ReportDialogWidget> {
  List<String> reportContents = [
    "hate_speech",
    "unauthorized_sales_articles",
    "spam",
    "fake_information",
    "defamation",
    "other"
  ];
  List<String> reportContentKor = [
    "혐오 발언",
    "허가되지 않은 판매글",
    "스팸",
    "거짓 정보",
    "명예훼손",
    "기타"
  ];
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
              "assets/icons/close_check.svg",
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

// PostViewPage 내에 삽입되는 WebViewWidget
// article.content or curComment.content 렌더링을 위한 WebViewWidget
// WebViewWidget 과의 차이점은 JS를 이용한 자동 높이 조정
class InArticleWebView extends StatefulWidget {
  final String content;
  final double initialHeight;
  const InArticleWebView({
    super.key,
    required this.content,
    required this.initialHeight,
  });

  @override
  State<InArticleWebView> createState() => _InArticleWebViewState();
}

class _InArticleWebViewState extends State<InArticleWebView> {
  WebViewController _webViewController = WebViewController();
  late double webViewHeight;
  late bool isFitted;

  void setWebViewHeight(value) {
    setState(() => webViewHeight = value);
  }

  int getPostNum(String path) {
    final RegExp pattern = RegExp(r'/post/\d+');
    RegExpMatch? match = pattern.firstMatch(path);
    if (match == null) return -1;
    return int.parse(path.substring(6));
  }

  void launchArticle(int postNum) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostViewPage(id: postNum))
    );
  }

  Future<void> launchInBrowser(String url) async {
    final Uri targetUrl = Uri.parse(url);
    if (!await canLaunchUrl(targetUrl)) {
      debugPrint("$url을 열 수 없습니다.");
      return;
    }
    if (targetUrl.authority == newAraAuthority) {
      int postNum = getPostNum(targetUrl.path);
      if (postNum != -1) {
        launchArticle(postNum);
        return;
      }
    }
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<double> getPageHeight() async {
    final String pageHeightStr =
    (await _webViewController.runJavaScriptReturningResult('''
            function getPageHeight() {
              return Math.max(
                document.body.scrollHeight || 0,
                document.documentElement.scrollHeight || 0,
                document.body.offsetHeight || 0,
                document.documentElement.offsetHeight || 0,
                document.body.clientHeight || 0,
                document.documentElement.clientHeight || 0
              ).toString();
            }
            getPageHeight();
          ''')).toString();
    debugPrint(
        "******************\npageHeight: $pageHeightStr \n******************");
    double pageHeight =
    double.parse(pageHeightStr.substring(1, pageHeightStr.length - 1));

    return pageHeight;
  }

  Future<void> setPageHeight() async {
    getPageHeight().then((height) {
      if (!mounted) return;
      setState(() => webViewHeight = height);
    });
  }

  @override
  void initState() {
    super.initState();
    isFitted = false;
    webViewHeight = widget.initialHeight;
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url == 'about:blank') {
            return NavigationDecision.navigate;
          }
          Uri uri = Uri.parse(request.url);
          if (uri.scheme == "https" || uri.scheme == "http") {
            await launchInBrowser(request.url);
          } else {
            // mailto, sms, tel 등의 scheme 은 아직 지원하지 않음 (2023.07.31)
            // 추후 PostViewPage 전체적으로 완성되면 기능 추가할 예정
            debugPrint("Denied Scheme: ${uri.scheme}");
          }
          return NavigationDecision.prevent;
        },
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress: $progress)');
        },
        onPageFinished: (String url) async {
          if (isFitted) return;
          await setPageHeight();
          isFitted = true;
        },
        onWebResourceError: (WebResourceError error) async {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ))
      ..loadHtmlString(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: webViewHeight,
      child: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
