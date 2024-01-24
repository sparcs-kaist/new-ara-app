import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    debugPrint("initState invoked!!!");

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
        onNavigationRequest: (NavigationRequest request) async {
          Uri uri = Uri.parse(request.url);
          // SPARCS SSO 페이지에서 개발팀, 관리자에게 연락하기 기능이
          // mailto scheme을 사용하는데 웹뷰에서 잘 처리가 되지 않아 비활성화시켜둠.
          if (uri.scheme == 'mailto') {
            // TODO: 사용자 알림 메시지 구현하기
            debugPrint("아라앱에서 mailto scheme은 아직 관련 구현이 되어있지 않음(2023.01.24)");
            return NavigationDecision.prevent;
          }
          // mailto를 제외한 scheme에 대해서는 navigate 처리.
          return NavigationDecision.navigate;
        },
        // 페이지 로딩 상태를 출력
        onProgress: (int progress) {
          debugPrint('WebView가 로딩 중입니다 (진행률: $progress)');
        },
        // 페이지 로딩 시작 시
        onPageStarted: (String url) async {
          debugPrint("Start to load $url");
          // 로딩 표시기 활성화
          setState(() => isVisible = false);
        },
        // 페이지 로딩 완료 시
        onPageFinished: (String url) async {
          debugPrint("Finish loading url: $url");
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
            String curUrl = (await _controller.currentUrl()).toString();
            debugPrint('curUrl: $curUrl');
            /* /api/users/sso_login/가 성공적으로 실행되어 client_id, state를 발급받았지만
               소셜 로그인 비활성화가 되어있지 않은 경우, 관련 파리미터를 추가하려 리로드함. */
            if (Platform.isIOS && curUrl.startsWith(
                    'https://sparcssso.kaist.ac.kr/account/login/?next=/api/v2/token/require/') &&
                curUrl.contains('social_enabled') == false) {
              // 소설 로그인 비활성화를 위해 social_enabled, show_disabled_button 파라미터를 모두 0으로 설정.
              await _controller.runJavaScript(
                  "window.location.href = '$curUrl%26social_enabled%3D0%26show_disabled_button%3D0';");
            }
            /* 로그인 페이지에서 SPARCS SSO 내의 다른 페이지를 방문하였다가 다시 로그인 페이지로 돌아오는 경우,
               client_id, state가 아직 발급되지 않은 상태이기 때문에 소셜 로그인 비활성화를 할 수 없음.
               따라서 /api/users/sso_login/으로 리다이렉트함. */
            else if (Platform.isIOS && url == 'https://sparcssso.kaist.ac.kr/account/login/') {
              await _controller.runJavaScript(
                  "window.location.href = '$newAraDefaultUrl/api/users/sso_login/'");
            } else {
              // 로딩 완료 후 WebView 활성화
              setState(() {
                isVisible = true;
              });
            }
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
