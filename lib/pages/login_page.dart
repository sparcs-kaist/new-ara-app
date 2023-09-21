import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/sparcs_sso_page.dart';

/// `LoginPage` 위젯은 사용자에게 로그인 페이지를 표시합니다.
class LoginPage extends StatefulWidget {
  /// 기본 생성자입니다.
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// `_LoginPageState` 클래스는 `LoginPage` 위젯의 상태를 관리합니다.
class _LoginPageState extends State<LoginPage> {
  /// SSO 페이지를 표시할지 여부를 결정하는 변수입니다.
  bool showSSOPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: showSSOPage == false
            ? Center(
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
                          'login_page.login'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showSSOPage = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            : const SparcsSSOPage(),
      ),
    );
  }
}
