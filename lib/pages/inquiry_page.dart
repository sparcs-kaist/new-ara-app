import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///회원 탈퇴 후 로그인을 시도할 때 표시되는 실패 페이지
///
///TODO: class 명과 파일명은 변경 필요
///
///TODO: 디자인 변경 필요
class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          child: Text(
            LocaleKeys.inquiryPage_title.tr(),
            style: const TextStyle(
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
                  text: LocaleKeys.inquiryPage_reLoginErrorWithWithdrawalGuide
                      .tr(),
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                      fontSize: 20),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      int? userID = userProvider.naUser!.user;
                      String? email = userProvider.naUser?.email;
                      String? nickname = userProvider.naUser?.nickname;

                      final String body = LocaleKeys
                          .inquiryPage_reLoginErrorWithWithdrawalEmailContents
                          .tr(
                        namedArgs: {
                          'userID': userID.toString(),
                          'email': email.toString(),
                          'nickname': nickname.toString(),
                        },
                      );
                      final emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'ara@sparcs.org',
                        query: encodeQueryParameters(<String, String>{
                          'subject': LocaleKeys
                              .inquiryPage_reLoginErrorWithWithdrawalEmailTitle
                              .tr(),
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
