import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/translations/codegen_loader.g.dart';
import 'package:new_ara_app/utils/global_key.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:new_ara_app/pages/main_navigation_tab_page.dart';
import 'package:new_ara_app/pages/login_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/providers/blocked_provider.dart';

/// 앱에서 지원하는 언어 설정
final supportedLocales = [
  const Locale('en'),
  const Locale('ko'),
];

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();

  // .env.delevopment 또는 .env.production 파일을 읽어서 환경변수 설정
  // ex) flutter run --dart-define=ENV=development
  // ex) flutter run --dart-define=ENV=production
  const String environment =
      String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: ".env.$environment");

  newAraDefaultUrl = dotenv.env['NEW_ARA_DEFAULT_URL']!;
  newAraAuthority = dotenv.env['NEW_ARA_AUTHORITY']!;
  sparcsSSODefaultUrl = dotenv.env['SPARCS_SSO_DEFAULT_URL']!;

  // 앱 시작점. 다국어 지원 및 여러 데이터 제공자를 포함한 구조로 설정
  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ko'),
      assetLoader: const CodegenLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProxyProvider<UserProvider, NotificationProvider>(
              create: (_) => NotificationProvider(),
              // 사용자 정보가 업데이트될 때마다 알림 제공자를 업데이트
              update: (_, userProvider, notificationProvider) {
                return notificationProvider!
                  ..updateCookie(userProvider.getCookiesToString());
              }),
          ChangeNotifierProvider(create: (_) => BlockedProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

/// 스크롤 행동을 사용자 정의하기 위한 클래스
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

/// 앱의 메인 위젯
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // 자동 로그인을 위한 초기 설정
    autoLoginByGetCookie(Provider.of<UserProvider>(context, listen: false));

    // TODO: 아래 코드는 iOS 심사 통과를 위한 임시 방편. 익명 차단이 BE에서 구현되면 제거해야함 (2023.02.29)
    // 앱이 시작될 때 shared preferences에서 차단한 글 목록 조회하기
    BlockedProvider blockedProvider = context.read<BlockedProvider>();
    blockedProvider.fetchBlockedAnonymousPostID().then((_) {
      debugPrint("차단한 글 postid 목록: ${blockedProvider.blockedAnonymousPostIDs}");
    });
  }

  /// 자동 로그인을 위한 메서드
  /// secureStorage에서 쿠키를 가져와서 사용자 로그인 상태 확인
  void autoLoginByGetCookie(UserProvider userProvider) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var cookiesBySecureStorage = await secureStorage.read(key: 'cookie');

    debugPrint("main.dart : $cookiesBySecureStorage.toString()");
    if (cookiesBySecureStorage != null) {
      setState(() {
        isLoading = true;
      });
      debugPrint("main.dart s");
      bool tf = await userProvider.apiMeUserInfo(
          initCookieString: cookiesBySecureStorage);
      debugPrint("main.dart : tf: $tf");
      if (tf) {
        userProvider.setHasData(true);
        userProvider.setCookieToList(cookiesBySecureStorage);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        scaffoldMessengerKey: snackBarKey,
        theme: _setThemeData(),
        // TODO: CustionScrollBehavior의 역할은?
        builder: (context, child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
              // 시스템 폰트 사이즈에 영향을 받지 않도록 textScaleFactor 지정함
              data: data.copyWith(textScaleFactor: 1.0),
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: child!,
              ));
        },
        // 로그인 상태에 따라서 다른 홈페이지 표시
        home: isLoading == true
            ? const LoadingIndicator() // 로그인 중에는 로딩 인디케이터 표시
            : context.watch<UserProvider>().hasData
                ? (context
                            .watch<UserProvider>()
                            .naUser!
                            .agree_terms_of_service_at !=
                        null
                    ? const MainNavigationTabPage()
                    : const LoginPage())
                : const LoginPage());
  }

  // 앱의 전반적인 테마 설정
  ThemeData _setThemeData() {
    return ThemeData(
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.transparent,
      ),
    );
  }
}
