import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///회원 탈퇴 후 로그인을 시도할 때 표시되는 실패 페이지
///
///TODO: class 명과 파일명은 변경 필요
///
///TODO: 디자인 변경 필요
class InQuiryPage extends StatefulWidget {
  const InQuiryPage({super.key});

  @override
  State<InQuiryPage> createState() => _InQuiryPageState();
}

class _InQuiryPageState extends State<InQuiryPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const SizedBox(
          child: Text(
            "문의 페이지",
            style: TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leadingWidth: 100,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SvgPicture.asset(
                'assets/icons/left_chevron.svg',
                colorFilter: const ColorFilter.mode(
                    ColorsInfo.newara, BlendMode.srcATop),
                fit: BoxFit.fill,
                width: 35,
                height: 35,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: '이미 탈퇴 했던 계정입니다.\n재가입을 하고 싶다면 이메일로 문의하세요.',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue, fontSize: 20),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      int? userID = userProvider.naUser!.user;
                      String? email = userProvider.naUser?.email;
                      String? nickname = userProvider.naUser?.nickname;

                      final String body =
                          """여기 아래에 문의 사항을 적어주세요.\n\n※ Ara 관리자가 48시간 이내로 답변드립니다.※\n\n유저 번호: $userID\n닉네임: $nickname\n이메일: $email\n플랫폼: App\n""";
                      final emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'ara@sparcs.org',
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Ara에 문의합니다',
                          'body': body,
                        }),
                      );

                      if (!await launchUrl(
                        emailLaunchUri,
                      )) {
                        debugPrint('Could not launch mail');
                        debugPrint("기본 메일앱을 열 수 없습니다.");
                      }
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
