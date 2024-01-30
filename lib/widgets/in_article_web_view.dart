import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/html_info.dart';
import 'package:new_ara_app/utils/slide_routing.dart';

/// PostViewPage에서는 article 및 comment의 content를 HTML 렌더링으로 보여줘야 함.
/// 따라서 웹뷰가 사용되는 경우가 자주 있어 따로 클래스로 분리함.
class InArticleWebView extends StatefulWidget {
  /// 웹뷰에서 렌더링하는 HTML.
  /// 웹뷰에서 로딩하기 전에 sanitize함.
  final String content;

  /// 초기 웹뷰 위젯의 높이.
  final double initialHeight;

  /// 웹뷰로 표시하려는 content가 댓글인지 여부.
  /// 아래와 같이 사용.
  final bool isComment;

  const InArticleWebView({
    super.key,
    required this.content,
    required this.initialHeight,
    required this.isComment,
  });

  @override
  State<InArticleWebView> createState() => _InArticleWebViewState();
}

class _InArticleWebViewState extends State<InArticleWebView> {
  late WebViewController _webViewController;

  /// WebView 위젯의 height.(initialHeight에서 조정됨)
  late double webViewHeight;

  /// webViewHeight 조정 완료 여부.
  late bool isFitted;

  /// content에 뉴아라 게시물에 대한 링크가 있을 경우 게시물 번호를 추출해줌.
  /// launchInBrower 메서드에서 사용함.
  /// ```
  /// if (targetUrl.authority == newAraAuthority) {
  /// int postNum = getPostNum(targetUrl.path);
  /// if (postNum != -1) {
  ///   launchArticle(postNum);
  ///   return;
  ///  }
  /// }
  /// ```
  int getPostNum(String path) {
    final RegExp pattern = RegExp(r'/post/\d+');
    RegExpMatch? match = pattern.firstMatch(path);
    if (match == null) return -1;
    return int.parse(path.substring(6));
  }

  /// 뉴아라 내부 게시물 번호인 [postNum]을 전달받아 PostViewPage를 호출함.
  /// 댓글로 뉴아라 게시물 링크가 공유되었을 때 사용.
  void launchArticle(int postNum) {
    Navigator.of(context).push(slideRoute(
      PostViewPage(id: postNum),
    ));
  }

  /// 웹뷰에서 링크가 클릭되었을 때 링크 분석, 리다이렉트를 담당해줌.
  /// 링크를 [url]로 전달받은 후
  /// 뉴아라 내부 게시물일 경우 PostViewPage, 아닐 경우 기본 브라우저로 리다이렉트.
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
      // TODO: debugPrint 및 Toast message로 수정하기
      throw Exception('Could not launch $url');
    }
  }

  /// 웹뷰에서 content를 표시하기 위해 어느 정도 높이가 필요한지 구함.
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
    double pageHeight =
        double.parse(pageHeightStr.replaceAll('"', '').replaceAll("'", ""));
    debugPrint("pageHeight: $pageHeightStr -> $pageHeight");

    return pageHeight;
  }

  /// getPageHeight를 호출하고 리턴값을 받아 직접 state를 변경함.
  Future<void> updatePageHeight() async {
    getPageHeight().then((height) {
      if (!mounted) return;
      setState(() => webViewHeight = height);
    });
  }

  @override
  void initState() {
    UserProvider userProvider = context.read<UserProvider>();
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
        onPageStarted: (String url) async {},
        onPageFinished: (String url) async {
          if (!isFitted) {
            await updatePageHeight();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              isFitted = true;
              debugPrint("height fitted!!");
              // 댓글은 웹뷰 로드가 빠름(대부분 content가 많지 않기 때문)
              // 따라서 댓글이 아닌 경우에만 isContentLoaded로 로드여부 관리.
              if (!(widget.isComment)) {
                userProvider.setIsContentLoaded(true);
              }
            });
          }
        },
        onWebResourceError: (WebResourceError error) async {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ))
      ..loadHtmlString(getContentHtml(widget.content));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: webViewHeight,
      child: WebViewWidget(
        controller: _webViewController,
        // 웹뷰를 클릭하였을 때 키보드를 비활성화.
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() {
            TapGestureRecognizer tabGestureRecognizer = TapGestureRecognizer();
            tabGestureRecognizer.onTapDown = (_) {
              FocusScope.of(context).unfocus();
            };
            return tabGestureRecognizer;
          }),
          // pinch-to-zoom 기능을 위해서
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
        },
      ),
    );
  }
}
