import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

/// SparcsSSOPage
/// Sparcs SSO(단일 서명 인증) 처리를 담당하는 Flutter 페이지 위젯입니다.
class SparcsSSOPage extends StatefulWidget {
  const SparcsSSOPage({Key? key}) : super(key: key);

  @override
  State<SparcsSSOPage> createState() => _SparcsSSOPageState();
}

class _SparcsSSOPageState extends State<SparcsSSOPage> {
  WebViewController _controller = WebViewController();
  final webViewKey = GlobalKey();

  // WebView의 로딩 상태를 표시하는 플래그
  bool isVisible = false;

  // TODO: 이 쿠키가 왜 쓰이는 지, 왜 남겨두었는지 알아보기
  List<Cookie> cookies = [];
  // TODO: 이 userID가 왜 쓰이는 지, 왜 남겨두었는지 알아보기
  int userID = 0;

  Future<String> getClientIDState() async {
    // /api/sso_login으로 요청 보내기
    Dio _dio = Dio();
    _dio.options.followRedirects = true;
    _dio.options.responseType = ResponseType.plain;
    final String apiUrl = "https://newara.dev.sparcs.org/api/users/sso_login/";
    var response = await _dio.get(apiUrl);
    return response.realUri.toString();
  }

  @override
  void initState() {
    super.initState();

    getClientIDState().then((path) {
      debugPrint('real path: $path');
      
      // 쿠키 초기화
      // 다른 쿠키도 모두 초기화되는지 알아야 함
      WebViewCookieManager().clearCookies();

      _controller = WebViewController()
        // JavaScript 활성화
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        // WebView 배경색 설정
        ..setBackgroundColor(const Color(0x00000000))
        // 네비게이션 대리자 설정
        ..setNavigationDelegate(NavigationDelegate(
          // 페이지 로딩 상태를 출력
          onProgress: (int progress) {
            debugPrint('WebView가 로딩 중입니다 (진행률: $progress)');
          },
          // 페이지 로딩 시작 시
          onPageStarted: (String url) {
            debugPrint("Start to load $url");
            // 로딩 표시기 활성화
            setState(() => isVisible = false);
          },
          // 페이지 로딩 완료 시
          onPageFinished: (String url) async {
            // 특정 URL로 끝나면 로그인 성공으로 판단
            if (url.endsWith('$newAraDefaultUrl/') && mounted) {
              var userProvider = context.read<UserProvider>();
              debugPrint("main.dart:로그인 성공");

              FlutterSecureStorage secureStorage = const FlutterSecureStorage();

              debugPrint("현재 URL은 $url 입니다");

              await userProvider.setCookiesFromUrl(url);
              await userProvider.apiMeUserInfo(message: "sparscssso");
              userProvider.setHasData(true);

              String cookieString = userProvider.getCookiesToString();
              await secureStorage.write(key: 'cookie', value: cookieString);
            } else if (mounted) {
              debugPrint("Finish loading url: $url");
              // 로딩 완료 후 WebView 활성화
              setState(() {
                isVisible = true;
              });
            } else {
              debugPrint("not mounted");
            }
          },
          // WebView 리소스 오류 발생 시
          onWebResourceError: (WebResourceError error) {
            debugPrint(
                '코드: ${error.errorCode}\n설명: ${error.description}\n오류 유형: ${error.errorType}\n메인 프레임에 대한 것인가? ${error.isForMainFrame}');
          },
        ))
        // 시작 URL 로딩
        ..loadRequest(Uri.parse('https://sparcssso.kaist.ac.kr$path%26social_enabled%3D0%26show_disabled_button%3D0'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const LoadingIndicator(),
            Visibility(
              // WebView의 표시 여부 제어
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
