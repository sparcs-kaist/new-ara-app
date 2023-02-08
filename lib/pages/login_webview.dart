import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/providers/auth_model.dart';

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
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(targetUrl)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: ((controller, url) {
            if (Uri.parse(url.toString()).path == '/login-handler') {
              context.read<AuthModel>().login(UrlInfo.MAIN_URL).then((_) {
                Navigator.pop(context);
              });
            }
          }),
        ),
      ),
    );
  }
}
