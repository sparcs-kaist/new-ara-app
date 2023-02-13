import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  String targetUrl =
      "https://newara.dev.sparcs.org/api/users/sso_login/?next=https://newara.dev.sparcs.org/login-handler";
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
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
            const LoadingIndicator(),
            Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: _isVisible,
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse(targetUrl)),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: ((controller, url) async {
                  Uri _curUri = Uri.parse(url.toString());
                  setState(() => _isVisible = false);
                  if (_curUri.authority == UrlInfo.MAIN_AUTHORITY) {
                    context
                        .read<AuthModel>()
                        .login(UrlInfo.MAIN_URL)
                        .then((_) => Navigator.pop(context));
                  }
                }),
                onLoadStop: (((controller, url) {
                  Uri _curUri = Uri.parse(url.toString());
                  if (_curUri.authority == UrlInfo.AUTH_AUTHORITY) {
                    setState(() => _isVisible = true);
                  }
                })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
