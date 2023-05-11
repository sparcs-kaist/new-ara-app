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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      width: 200,
                      child: SizedBox(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
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
                  ],
                ),
              )
            :
            const SparcsSSOPage(),
      ),
    );
  }
}
