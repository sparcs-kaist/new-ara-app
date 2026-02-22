import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/article_model.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// 사용자가 게시물을 작성하거나 편집할 수 있는 페이지.
/// 웹뷰를 사용하여 웹 기반 글쓰기 페이지를 전체 화면으로 로드합니다.
class PostWritePage extends StatefulWidget {
  final ArticleModel? previousArticle;
  final BoardDetailActionModel? previousBoard;

  const PostWritePage({super.key, this.previousArticle, this.previousBoard});

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // 글쓰기 웹뷰 URL 구성
    String webViewUrl = '${newAraDefaultUrl}/web_view/PostWrite';
    if (widget.previousArticle != null) {
      webViewUrl =
          '${newAraDefaultUrl}/web_view/PostWrite?articleId=${widget.previousArticle!.id}';
    } else if (widget.previousBoard != null) {
      webViewUrl =
          '${newAraDefaultUrl}/web_view/PostWrite?boardSlug=${widget.previousBoard!.slug}';
    }

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'PostWritePageExit') {
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('PostWrite WebView loading (progress: $progress%)');
        },
        onPageFinished: (String url) {
          debugPrint('PostWrite WebView loaded: $url');
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('PostWrite WebView error: ${error.description}');
        },
      ))
      ..loadRequest(Uri.parse(webViewUrl));

    _webViewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    late WebViewWidget webViewWidget;

    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      webViewWidget = WebViewWidget.fromPlatformCreationParams(
        params: AndroidWebViewWidgetCreationParams(
          controller: _webViewController.platform,
          displayWithHybridComposition: true,
        ),
      );
    } else {
      webViewWidget = WebViewWidget(controller: _webViewController);
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: webViewWidget,
        ),
      ),
    );
  }
}
