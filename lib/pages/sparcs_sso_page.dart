import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:provider/provider.dart';

class SparcsSSOPage extends StatefulWidget {
  const SparcsSSOPage({Key? key}) : super(key: key);
  @override
  State<SparcsSSOPage> createState() => _SparcsSSOPageState();
}

class _SparcsSSOPageState extends State<SparcsSSOPage> {
  WebViewController _controller = WebViewController();
  final webViewKey = GlobalKey();
  bool isVisible = false;
  List<Cookie> cookies = [];
  int userID = 0;

  @override
  void initState() {
    super.initState();
    WebViewCookieManager().clearCookies();
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
        onPageFinished: (String url) async {
          //(수정 요망)현재는 야매로 하는 방법
          if (url.endsWith('https://newara.dev.sparcs.org/') && mounted) {
            var userProvider = context.read<UserProvider>();
            debugPrint("main.dart:login success");

            FlutterSecureStorage secureStorage = const FlutterSecureStorage();

            debugPrint("current url is $url");

            await userProvider.setCookiesFromUrl(url);
            await userProvider.apiMeUserInfo(message: "sparscssso");
            userProvider.setHasData(true);
            //현재 정상적으로 로그인 된 상태이므로 newAraHomePage 띄우기

            String cookieString = userProvider.getCookiesToString();
            await secureStorage.write(key: 'cookie', value: cookieString);
          } else if (mounted) {
            // 위에 onPageStarted 에는 왜 mounted 조건문을 안해도 되는지 모르겠음
            setState(() {
              isVisible = true;
            });
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
      ..loadRequest(
          Uri.parse('https://newara.dev.sparcs.org/api/users/sso_login/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const LoadingIndicator(),
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
