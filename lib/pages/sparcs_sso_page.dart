import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';

import 'package:provider/provider.dart';

class SparcsSSOPage extends StatefulWidget {
  const SparcsSSOPage({Key? key}) : super(key: key);
  @override
  State<SparcsSSOPage> createState() => _SparcsSSOPageState();
}

class _SparcsSSOPageState extends State<SparcsSSOPage> {
  late final WebViewController _controller;
  final webViewKey = GlobalKey();
  bool isVisible = false;
  List<Cookie> cookies=[];
  int userID=0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress: $progress)');
        },
        onPageStarted: (String url) {
          setState(() => isVisible = false);
        },
        onPageFinished: (String url) async{
          setState(() {
            isVisible = true;
          });
          debugPrint("current url is $url");

          //(수정 요망)현재는 야매로 하는 방법
          if (url.endsWith('https://newara.dev.sparcs.org/')) {
            debugPrint("main.dart:login success");

            //현재 정상적으로 로그인 된 상태이므로 newAraHomePage 띄우기
            Provider.of<UserProvider>(context, listen: false).setHasData(true);
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint(
              'code: ${error.errorCode}\ndescription: ${error.description}\nerrorType: ${error.errorType}\nisForMainFrame: ${error.isForMainFrame}');
        },
      ))
      // ..addJavaScriptChannel('Toaster',
      //     onMessageReceived: (JavaScriptMessage message) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(message.message)),
      //   );
      // })
      ..loadRequest(Uri.parse(
          'https://newara.dev.sparcs.org/api/users/sso_login/'));

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
            LoadingIndicator(),
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