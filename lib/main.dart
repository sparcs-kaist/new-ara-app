import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/home.dart';
import 'package:new_ara_app/pages/login_page.dart';
import 'package:new_ara_app/providers/auth_model.dart';
import 'package:new_ara_app/providers/user_model.dart';

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
      fallbackLocale: const Locale('ko'),
      startLocale: const Locale('ko'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthModel()),
          ChangeNotifierProxyProvider<AuthModel, UserModel>(
            create: (context) => UserModel(),
            update: (context, authModel, userModel) {
              authModel.isLogined
                  ? userModel?.getUserInfo()
                  : userModel?.delUserInfo();
              return (userModel is UserModel) ? userModel : UserModel();
            },
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatelessWidget {
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
      home: context.watch<UserModel>().hasData
          ? const NewAraHome()
          : const LoginPage(),
    );
  }

  ThemeData _setThemeData() {
    return ThemeData(
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
      //scaffoldBackgroundColor: Colors.white,
      fontFamily: 'NotoSansKR',
    );
  }
}
