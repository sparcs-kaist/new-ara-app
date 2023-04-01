import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/providers/auth_model.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';

import 'package:provider/provider.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({Key? key}) : super(key: key);
  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late final WebViewController _controller;
  final webViewKey = GlobalKey();
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress: $progress)');
        },
        onPageStarted: (String url) {
          setState(() => isVisible = false);
          if (Uri.parse(url).authority == UrlInfo.MAIN_AUTHORITY) {
            context
                .read<AuthModel>()
                .login(UrlInfo.MAIN_URL)
                .then((_) => Navigator.pop(context));
          }
        },
        onPageFinished: (String url) {
          if (Uri.parse(url).authority != UrlInfo.MAIN_AUTHORITY) {
            setState(() => isVisible = true);
          }
          debugPrint('TBD');
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ))
      ..addJavaScriptChannel('Toaster',
          onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      })
      ..loadRequest(Uri.parse(UrlInfo.WEBVIEW_INIT));
    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.white, color: ColorsInfo.newara),
            ),
            Visibility(
              visible: isVisible,
              child: WebViewWidget(
                key: webViewKey,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
