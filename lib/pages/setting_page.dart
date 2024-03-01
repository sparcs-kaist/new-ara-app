// 유저 설정 관리, 차단한 유저 목록, 로그아웃을 관리하는 파일.
// Author: 김상오(alvin)

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/pages/terms_and_conditions_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgets/text_info.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/widgets/dialogs.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';

/// 설정 페이지 빌드 및 이벤트 처리를 담당하는 StatefulWidget.
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  // 백엔드 모델과 동일한 변수명을 사용하기 위해 snake case 사용함.

  /// 성인글 보기 설정. true이면 성인글을 보여줌.
  late bool seeSexual;

  /// 정치글 보기 설정. true이면 정치글을 보여줌.
  late bool seeSocial;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    var userProvider = context.read<UserProvider>();
    seeSexual = userProvider.naUser?.see_sexual ?? true;
    seeSocial = userProvider.naUser?.see_social ?? true;
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
          icon: SvgPicture.asset(
            'assets/icons/left_chevron.svg',
            colorFilter: const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
            width: 35,
            height: 35,
          ),
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
        child: _isLoading
            ? const LoadingIndicator()
            : SingleChildScrollView(
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                                        value: seeSexual,
                                        onChanged: (value) async {
                                          setState(() => seeSexual = value);
                                          try {
                                            await dio.patch(
                                                '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                                data: {'see_sexual': value});
                                            await userProvider.apiMeUserInfo();
                                            debugPrint(
                                                "Change of 'see_sexual' succeed!");
                                            requestSnackBar("설정이 저장되었습니다.");
                                          } catch (error) {
                                            debugPrint(
                                                "Change of 'see_sexual' failed: $error");
                                            requestSnackBar(
                                                "에러가 발생하여 설정 반영에 실패했습니다. 다시 시도해주십시오.");
                                            setState(() => seeSexual = !value);
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
                                        value: seeSocial,
                                        onChanged: (value) async {
                                          setState(() {
                                            seeSocial = value;
                                          });
                                          try {
                                            await dio.patch(
                                                '$newAraDefaultUrl/api/user_profiles/${userProvider.naUser!.user}/',
                                                data: {'see_social': value});
                                            await userProvider.apiMeUserInfo();
                                            debugPrint(
                                                "Change of 'see_social' succeed!");
                                            requestSnackBar("설정이 저장되었습니다.");
                                          } catch (error) {
                                            debugPrint(
                                                "Change of 'see_social' failed: $error");
                                            requestSnackBar(
                                                "에러가 발생하여 설정 반영에 실패했습니다. 다시 시도해주십시오.");
                                            setState(() => seeSocial = !value);
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    const BlockedUserDialog());
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            InkWell(
                              onTap: () => launchInBrowser(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 정치글 보기 글씨
                                  Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: const Text(
                                        '운영진에게 문의하기',
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => SignoutConfirmDialog(
                                  onTap: () async {
                                    await _logout();
                                  },
                                  userProvider: userProvider,
                                  targetContext: context,
                                ),
                              );
                            },
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
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => UnregisterConfirmDialog(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    // ignore: unused_local_variable
                                    Map<String, dynamic>? responseResult =
                                        await userProvider
                                            .getApiRes('unregister');
                                    //TODO: 회원탈퇴 로직 보강 필요
                                    // if(responseResult == null){
                                    //   ///회원탈퇴 실패
                                    // }
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    String jsonString = userProvider
                                        .naUser!.user
                                        .toString(); // 데이터를 JSON 문자열로 인코딩
                                    await prefs.setString(
                                        '심사통과를위한탈퇴탈퇴한유저', jsonString);

                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                    await _logout();
                                  },
                                  userProvider: userProvider,
                                  targetContext: context,
                                ),
                              );
                            },
                            child: const Center(
                              child: Text(
                                '회원탈퇴',
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
                      const SizedBox(height: 5),
                      const TextInfo(
                          '회원 탈퇴는 Ara 관리자가 확인 후 처리해드리며, 최대 24시간이 소요될 수 있습니다'),
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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  /// 회원탈퇴 기능을 위해 mailto scheme이 필요해서 사용함.
  /// 브라우저로 url 열기에 성공하면 true, 아니면 false를 반환함.
  Future<bool> launchInBrowser(int mode) async {
    UserProvider userProvider = context.read<UserProvider>();
    int? userID = userProvider.naUser!.user;
    String? email = userProvider.naUser?.email;
    String? nickname = userProvider.naUser?.nickname;
    final String body =
        """유저 번호: $userID\n닉네임: $nickname\n이메일: $email\n 탈퇴 요청드립니다(Ara 관리자가 확인 후 처리해드리며 조금의 시간이 소요될 수 있습니다)""";
    late final Uri emailLaunchUri;
    // 문의하기에 사용되는 경우
    if (mode == 0) {
      emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'ara@sparcs.org',
      );
    }
    // 탈퇴에 사용되는 경우
    else if (mode == 1) {
      emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'ara@sparcs.org',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Ara 회원 탈퇴 요청',
          'body': body,
        }),
      );
    }
    if (!await launchUrl(
      emailLaunchUri,
    )) {
      debugPrint('Could not launch mail');
      debugPrint("기본 메일앱을 열 수 없습니다.");
      requestSnackBar("기본 메일 어플리케이션을 열 수 없습니다. ara@sparcs.org로 문의 부탁드립니다.");
      return false;
    }

    return true;
  }

  void requestSnackBar(String msg) {
    showInfoBySnackBar(context, msg);
  }
}
