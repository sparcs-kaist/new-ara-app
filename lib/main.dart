import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/pages/main_navigation_tab_page.dart';
import 'package:new_ara_app/pages/login_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

final supportedLocales = [
  const Locale('en'),
  const Locale('ko'),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ko'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProxyProvider<UserProvider, NotificationProvider>(
            create: (_) => NotificationProvider(),
            update: (_, userProvider, notificationProvider) {
              return notificationProvider!..updateCookie(
                userProvider.getCookiesToString()
              );
            }
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );

  // This line is for testing purposes only
  // enableFlutterDriverExtension(handler: (payload) async {
  //   if (payload == 'restart') {
  //     exit(0);
  //   }
  //   return '';
  // });
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotificationProvider>().periodicNotificationFetch();
    autoLoginByGetCookie(Provider.of<UserProvider>(context, listen: false));
  }

  void autoLoginByGetCookie(UserProvider userProvider) async {
    // await Future.delayed(Duration(seconds: 1));
// 로컬에서 쿠키 (세션 아이디 + 토큰 )가져오는 코드 추가해야함.
// 1. 스토리지에서 쿠키를 가져오는 게 성공해야함.
// 2. 스토리지에서 가져온 쿠키로 api/me를 가져왔을 때 성공해야함.
// 3. 그럼 로그인 성공 -> 스토리지에서 가져온 쿠키를 provider 쿠키에 저장
// # 로그인 할 때 로컬 스토리지에서 쿠키 갱신, 로그아웃 할 때 로컬 스토리지에서 쿠키 삭제.

    // Provider.of<UserProvider>(initStateContext, listen: false).setHasData(true);
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var cookiesBySecureStorage = await secureStorage.read(key: 'cookie');

    debugPrint("main.dart : $cookiesBySecureStorage");
    if (cookiesBySecureStorage != null) {
      setState(() {
        isLoading = true;
      });
      bool tf = await userProvider.apiMeUserInfo(
          initCookieString: cookiesBySecureStorage);
      if (tf) {
        userProvider.setHasData(true);
        userProvider.setCookieToList(cookiesBySecureStorage);
      }
      setState(() {
        isLoading = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        theme: _setThemeData(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child!,
          );
        },

        /// hasData true -> newarahomepage, false -> loginpage.
        home: isLoading == true
            ? const LoadingIndicator() // 자동 로그인 시 로컬 쿠키에서 가져오는 동안 공백이 생긴다. 그 동안 띄어주는 indicator
            : context.watch<UserProvider>().hasData
                ? const MainNavigationTabPage()
                : const LoginPage());
  }

  ThemeData _setThemeData() {
    return ThemeData(
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: Colors.white),
      fontFamily: 'NotoSansKR',
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
    );
  }
}
