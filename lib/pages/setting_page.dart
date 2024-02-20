/// 유저 설정 관리, 차단한 유저 목록, 로그아웃을 관리하는 파일.
/// Author: 김상오(alvin)

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/pages/terms_and_conditions_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgets/text_info.dart';
import 'package:new_ara_app/widgets/border_boxes.dart';
import 'package:new_ara_app/widgets/text_and_switch.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/models/block_model.dart';
import 'package:new_ara_app/widgets/dialogs.dart';

/// 설정 페이지 빌드 및 이벤트 처리를 담당하는 StatefulWidget.
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  // 백엔드 모델과 동일한 변수명을 사용하기 위해 snake case 사용함.

  /// 성인글 보기 설정. true이면 성인글을 보여줌.
  late bool see_sexual;

  /// 정치글 보기 설정. true이면 정치글을 보여줌.
  late bool see_social;

  @override
  void initState() {
    super.initState();
    var userProvider = context.read<UserProvider>();
    see_sexual = userProvider.naUser?.see_sexual ?? true;
    see_social = userProvider.naUser?.see_social ?? true;
    // 페이지 전환 과정에서 새로운 알림을 확인하기 위한 호출.
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    Dio dio = userProvider.createDioWithHeadersForNonget();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              color: ColorsInfo.newara, width: 35, height: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          child: Text(
            'setting_page.title'.tr(),
            style: const TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 23),
                // 게시글 아이콘 및 '게시글' 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/post_list.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.bulletin'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                // 성인글 보기, 정치글 보기 스위치 버튼
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 94,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // 성인글 보기
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 성인글 보기 글씨
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "setting_page.adult".tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // 성인글 보기 CupertinoSwitch
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: see_sexual,
                                  onChanged: (value) async {
                                    setState(() => see_sexual = value);
                                    try {
                                      await dio.patch(
                                          '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                          data: {'see_sexual': value});
                                      await userProvider.apiMeUserInfo();
                                      debugPrint(
                                          "Change of 'see_sexual' succeed!");
                                    } catch (error) {
                                      debugPrint(
                                          "Change of 'see_sexual' failed: $error");
                                      setState(() => see_sexual = !value);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 정치글 보기
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 정치글 보기 글씨
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "setting_page.politics".tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // 정치글 보기 CupertinoSwitch
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: see_social,
                                  onChanged: (value) async {
                                    setState(() {
                                      see_social = value;
                                    });
                                    try {
                                      await dio.patch(
                                          '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                          data: {'see_social': value});
                                      await userProvider.apiMeUserInfo();
                                      debugPrint(
                                          "Change of 'see_social' succeed!");
                                    } catch (error) {
                                      debugPrint(
                                          "Change of 'see_social' failed: $error");
                                      setState(() => see_social = !value);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // // 알림 아이콘 및 '알림' 텍스트
                // SizedBox(
                //   width: MediaQuery.of(context).size.width - 50,
                //   child: Row(
                //     children: [
                //       SvgPicture.asset(
                //         'assets/icons/notification.svg',
                //         width: 34,
                //         height: 34,
                //       ),
                //       Text(
                //         'setting_page.noti'.tr(),
                //         style: const TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 7),
                // // 댓글, 대댓글 설정 UI의 border 설정
                // BorderBoxes(94, switchItems[1]),
                // const SizedBox(height: 10),
                // // 인기글 관련 설정 UI의 border 설정
                // BorderBoxes(94, switchItems[2]),
                // const SizedBox(height: 5),
                // // 인기 공지글 제공 시간 문구
                // TextInfo('setting_page.hot_info'.tr()),
                // const SizedBox(height: 10),
                // 차단 아이콘, '차단' 텍스트
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/barrior.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.block'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                // 차단한 유저 목록 버튼
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => const BlockedUserDialog());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 13),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Center(
                            child: Text(
                              'setting_page.blocked_users'.tr(),
                              style: const TextStyle(
                                color: ColorsInfo.newara,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // 유저 차단 기능 설명 문구
                const TextInfo(
                    '유저 차단은 게시글의 더보기 기능에서 하실 수 있습니다.\n하루에 최대 10번만 변경 가능합니다.'),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/information.svg',
                        width: 36,
                        height: 36,
                      ),
                      const Text(
                        '정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: const EdgeInsets.only(right: 5),
                  height: 94,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // 이용약관
                      InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                            slideRoute(
                              const TermsAndConditionsPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text(
                                  '이용약관',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            SvgPicture.asset(
                              'assets/icons/right_chevron.svg',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 문의
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 정치글 보기 글씨
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: const Text(
                                '문의',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const Text("ara@sparcs.org",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFBBBBBB),
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 로그아웃 버튼 UI (border도 포함)
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: InkWell(
                      onTap: () => _logout(),
                      child: const Center(
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            color: ColorsInfo.newara,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 로그아웃 관련된 모든 로직을 처리하는 함수.
  /// UserProvider, FlutterSecureStorage에서 유저 정보를 삭제함.
  Future<void> _logout() async {
    Provider.of<UserProvider>(context, listen: false).setHasData(false);
    Navigator.of(context).popUntil((route) => route.isFirst);

    // FlutterSecureStorage에서 세션 정보를 삭제함.
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.delete(key: 'cookie');
    await WebviewCookieManager().clearCookies();

    debugPrint("log out success");
  }
}
