import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final _controller = ScrollController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          child: Text(
            "이용약관",
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
        child: _isLoading
            ? const LoadingIndicator()
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CupertinoScrollbar(
                        thumbVisibility: true,
                        controller: _controller,
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Container(
                            color: const Color(0xFFF6F6F6),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildNormalText(
                                      "new Ara (이하 아라) 이용약관은 현재 적용 중입니다.\n"),
                                  _buildBoldText("제 1조. 아라의 목적"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 아라는 KAIST 구성원의 원활한 정보공유를 위해 KAIST 학부 동아리 SPARCS (이하 \"SPARCS\")에서 제공하는 공용 게시판 서비스 (Bulletin Board System) 입니다."),
                                        _buildNormalText(
                                            "2. 1조 1항에서의 KAIST 구성원이란 교수, 교직원, 그리고 재학생과 졸업생, 입주 업체 등을 나타냅니다.\n"),
                                      ],
                                    ),
                                  ),
                                  _buildBoldText("제 2조. 가입 및 탈퇴"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 아라는 KAIST 구성원만 이용 가능합니다."),
                                        _buildNormalText(
                                            "2. 아라는 SPARCS SSO를 통해 가입할 수 있습니다."),
                                        _buildNormalText(
                                            "  - SPARCS SSO에서 카이스트 통합인증으로 가입시 별도 승인 없이 바로 서비스 이용이 가능합니다. (교수, 교직원, 재학생, 졸업생 등)"),
                                        _buildNormalText(
                                            "  - SPARCS SSO에서 카이스트 통합인증 외 다른 방법으로 가입시 아라 운영진이 승인해야만 서비스 이용이 가능합니다. (입주 업체 등)"),
                                        _buildNormalText(
                                            "3. 아라는 회원탈퇴 기능이 없습니다. 다만, 아라 운영진에게 회원 탈퇴를 요청할 수 있습니다."),
                                        _buildNormalText(
                                            "4. 다음의 경우에는 회원자격이 박탈될 수 있습니다."),
                                        _buildNormalText(
                                            "  - 카이스트 구성원이 아닌 것으로 밝혀졌을 경우"),
                                        _buildNormalText(
                                            "  - new Ara 이용약관에 명시된 회원의 의무를 지키지 않은 경우"),
                                        _buildNormalText(
                                            "  - 아라 이용 중 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 관계 법령과 본 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우\n"),
                                      ],
                                    ),
                                  ),
                                  _buildBoldText("제 3조. 회원의 의무"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 회원은 아라 이용과 관련하여 다음의 행위를 하여서는 안 됩니다."),
                                        _buildNormalText(
                                            "  - SPARCS, 아라 운영진, 또는 특정 개인 및 단체를 사칭하는 행위"),
                                        _buildNormalText(
                                            "  - 아라를 이용하여 얻은 정보를 원작자나 아라 운영진의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송, 기타의 방법으로 사용하거나 이를 타인에게 제공하는 행위"),
                                        _buildNormalText(
                                            "  - 다른 회원의 계정을 부정 사용하는 행위"),
                                        _buildNormalText(
                                            "  - 타인의 명예를 훼손하거나 모욕하는 행위"),
                                        _buildNormalText(
                                            "  - 타인의 지적재산권 등의 권리를 침해하는 행위"),
                                        _buildNormalText(
                                            "  - 해킹행위 또는 컴퓨터바이러스의 유포 행위"),
                                        _buildNormalText(
                                            "  - 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위"),
                                        _buildNormalText(
                                            "  - 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위"),
                                        _buildNormalText(
                                            "  - 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위"),
                                        _buildNormalText(
                                            "  - SPARCS의 동의 없이 아라를 영리목적으로 사용하는 행위"),
                                        _buildNormalText(
                                            "  - 기타 아라의 커뮤니티 강령에 반하거나 아라 서비스 운영상 부적절하다고 판단하는 행위\n"),
                                      ],
                                    ),
                                  ),
                              
                                  _buildBoldText("제 4조. 게시물에 대한 권리"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 회원이 아라 내에 올린 게시물의 저작권은 게시한 회원에게 귀속됩니다."),
                                        _buildNormalText(
                                            "2. 서비스의 게시물 또는 내용물이 위의 약관에 위배될 경우 사전 통지나 동의 없이 삭제될 수 있습니다."),
                                        _buildNormalText(
                                            "3. 제 3조 회원의 의무에 따라, 아라를 이용하여 얻은 정보를 원작자나 아라 운영진의 사전 승낙 없이 복사, 복제, 변경, 번역, 출판, 방송, 기타의 방법으로 사용하거나, 영리목적으로 활용하거나, 이를 타인에게 제공하는 행위는 금지됩니다.\n"),
                                      ],
                                    ),
                                  ),
                              
                                  _buildBoldText("제 5조. 책임의 제한"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. SPARCS는 다음의 사유로 서비스 제공을 중지하는 것에 대해 책임을 지지 않습니다."),
                                        _buildNormalText(
                                            "  - 설비의 보수 등을 위해 부득이한 경우"),
                                        _buildNormalText(
                                            "  - KAIST가 전기통신서비스를 중지하는 경우"),
                                        _buildNormalText(
                                            "  - 천재지변, 정전 및 전시 상황인 경우"),
                                        _buildNormalText(
                                            "  - 기타 본 서비스를 제공할 수 없는 사유가 발생한 경우"),
                                        _buildNormalText(
                                            "2. SPARCS는 다음의 사항에 대해 책임을 지지 않습니다."),
                                        _buildNormalText(
                                            "  - 개재된 회원들의 글에 대한 신뢰도, 정확도"),
                                        _buildNormalText(
                                            "  - 아라를 매개로 회원 상호 간 및 회원과 제 3자 간에 발생한 분쟁"),
                                        _buildNormalText(
                                            "  - 기타 아라 사용 중 발생한 피해 및 분쟁\n"),
                                      ],
                                    ),
                                  ),
                              
                                  _buildBoldText("제 6조. 문의 및 제보"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 아라에 대한 건의사항 또는 버그에 대한 사항은 구글폼을 통해 문의 및 제보할 수 있습니다."),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                'https://sparcs.page.link/newara-feedback',
                                            style: const TextStyle(
                                                color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                await launchUrl(Uri.parse(
                                                    'https://sparcs.page.link/newara-feedback'));
                                              },
                                          ),
                                        ),
                                        _buildNormalText(
                                            "2. 6조 1항의 구글폼이 작동하지 않거나, 기타 사항의 경우 new-ara@sparcs.org 를 통해 문의 및 제보할 수 있습니다.\n"),
                                      ],
                                    ),
                                  ),
                                  _buildBoldText("제 7조. 게시, 개정 및 해석"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNormalText(
                                            "1. 아라 운영진은 본 약관에 대해 아라 회원가입시 회원의 동의를 받습니다."),
                                        _buildNormalText(
                                            "2. 아라 운영진은 약관의규제에관한법률, 정보통신망이용촉진및정보보호등에관한법률 등 관련법을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다."),
                                        _buildNormalText(
                                            "3. 본 약관을 개정하는 경우 적용일자, 개정 내용 및 사유를 명시하여 개정 약관의 적용일자 7일 전부터 적용일자 전일까지 아라의 '뉴아라 공지' 게시판을 통해 공지합니다."),
                                        _buildNormalText(
                                            "4. 회원은 개정약관이 공지된 지 7일 내에 개정약관에 대한 거부의 의사표시를 할 수 있습니다. 이 경우 회원은 아라 운영진에게 메일을 발송하여 즉시 사용 중인 모든 지원 서비스를 해지하고 본 서비스에서 회원 탈퇴할 수 있습니다."),
                                        _buildNormalText(
                                            "5. 아라 운영진은 개정약관이 공지된 지 7일 내에 거부의 의사표시를 하지 않은 회원에 대해 개정약관에 대해 동의한 것으로 간주합니다."),
                                        _buildNormalText(
                                            "6. 본 약관의 해석은 아라 운영진이 담당하며, 분쟁이 있을 경우 민법 등 관계 법률과 관례에 따릅니다.\n"),
                                      ],
                                    ),
                                  ),
                              
                                  _buildNormalText("본 약관은 2020-09-26부터 적용됩니다."),
                              
                                  // 제 3조 이후의 내용도 같은 방식으로 추가...
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: userProvider
                                      .naUser!.agree_terms_of_service_at ==
                                  null
                              ? InkWell(
                                  // 로직 설명
                                  // 1. 동의하면 agree_terms_of_service patch 요청
                                  // 2. userProvider.apiMe 함수 호출하여
                                  // 3. userProvider.naUser 값을 갱신
                                  // 4. main.dart에서 context.watch<UserProvider>().naUser!.agree_terms_of_service_at 또한 변경되어 MainNavigationTabPage로 진입
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Response? res = await userProvider.patchApiRes(
                                        'user_profiles/${userProvider.naUser!.user}/agree_terms_of_service/',
                                        payload: {});
                                    if (res != null &&
                                        (res.statusCode == 200 ||
                                            res.statusCode == 400)) {
                                      await userProvider.apiMeUserInfo();
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 100,
                                      maxHeight: 50,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: ColorsInfo.newara,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "동의 하기",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  "이미 동의하셨습니다.",
                                  style: TextStyle(
                                    color: ColorsInfo.newara,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNormalText(text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF4a4a4a),
        fontWeight: FontWeight.w500,
        fontFamily: 'Pretendard',
        height: 1.6,
        fontSize: 16,
      ),
    );
  }

  Widget _buildBoldText(text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xff363636),
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        height: 1.6,
        fontSize: 16,
      ),
    );
  }
}
