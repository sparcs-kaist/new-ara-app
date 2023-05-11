import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/sparcs_sso_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool showSSOPage =false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: showSSOPage == false ?
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        fit: BoxFit.contain, // 이미지 비율 유지
                        width: 200, // 원하는 너비 지정
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
                    SizedBox(
                      //로그인 버튼과 화면 하단과의 공백 공간
                      height: 50,
                    ),
                  ],
                ),
              )
            :
            const SparcsSSOPage(),
      ),
    );
  }
}
