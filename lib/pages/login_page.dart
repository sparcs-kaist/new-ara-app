import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/pages/login_webview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 324),
            SizedBox(
              height: 108.54,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(
                'assets/images/logo.svg',
              ),
            ),
            const SizedBox(height: 297.46),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginWebView()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
