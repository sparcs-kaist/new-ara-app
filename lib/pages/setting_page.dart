import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgetclasses/text_info.dart';
import 'package:new_ara_app/widgetclasses/border_boxes.dart';
import 'package:new_ara_app/widgetclasses/text_and_switch.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  bool see_sexual = true;
  bool see_social = true;

  @override
  void initState() {
    var userProvider = context.read<UserProvider>();
    // TODO: implement initState
    super.initState();
    see_sexual = userProvider.naUser?.see_sexual ??
        true; // 웹과 동일하게 하기 위해 snake_case 변수명 사용
    see_social =
        userProvider.naUser?.see_social ?? true; // 위와 같은 이유로 snake_case
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    var dio = Dio();
    dio.options.headers['Cookie'] = userProvider.getCookiesToString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/left_chevron.svg',
              color: ColorsInfo.newara, width: 35, height: 35),
          onPressed: () {
            Navigator.pop(context);
          },
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
                // 게시글 아이콘 및 게시글
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
                // 성인글 보기 및 정치글 보기
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
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 34,
                        height: 34,
                      ),
                      Text(
                        'setting_page.noti'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                BorderBoxes(94, switchItems[1]),
                const SizedBox(height: 10),
                BorderBoxes(94, switchItems[2]),
                const SizedBox(height: 5),
                TextInfo('setting_page.hot_info'.tr()),
                const SizedBox(height: 10),
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
                BorderBoxes(50, [
                  const SizedBox(height: 13),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: GestureDetector(
                      onTap: () {}, // 추후에 기능 구현 예정
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
                  ),
                ]),
                const SizedBox(height: 5),
                TextInfo('setting_page.block_howto'.tr()),
                const SizedBox(height: 20),
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
                    child: GestureDetector(
                      onTap: () async {
                        Provider.of<UserProvider>(context, listen: false)
                            .setHasData(false);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        // 이 뒤에 코드는 작동 해요~

                        FlutterSecureStorage secureStorage =
                            const FlutterSecureStorage();
                        await secureStorage.delete(key: 'cookie');
                        await WebviewCookieManager().clearCookies();

                        debugPrint("log out");
                      }, // 임시 로그아웃 기능으로 디자인 변경에 따라 수정될 예정
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
}
