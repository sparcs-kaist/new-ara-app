import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/sparcs_sso_page.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/utils/slide_routing.dart';

/// `LoginPage` 위젯은 사용자에게 로그인 페이지를 표시.
class LoginPage extends StatefulWidget {
  /// 기본 생성자입니다.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// `_LoginPageState` 클래스는 `LoginPage` 위젯의 상태를 관리.
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    try {
      FlutterNativeSplash.remove();
    } catch (e) {
      debugPrint('SPLASH ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SvgPicture.asset(
                  fit: BoxFit.contain,
                  width: 200,
                  'assets/images/logo.svg',
                ),
              ),
              Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: ColorsInfo.newara,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  child: Text(
                    LocaleKeys.loginPage_login.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      slideRoute(
                        const SparcsSSOPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
