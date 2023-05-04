import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/widgetclasses/text_info.dart';
import 'package:new_ara_app/widgetclasses/border_boxes.dart';
import 'package:new_ara_app/widgetclasses/text_and_switch.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/chevron-left.svg',
              color: ColorsInfo.newara, width: 10.7, height: 18.99),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/post-1.svg',
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
                BorderBoxes(94, switchItems[0]),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification-1.svg',
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
                        'assets/icons/barrior-1.svg',
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
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 219),
                    child: GestureDetector(
                      onTap: () async{

                        Provider.of<UserProvider>(context, listen: false).setHasData(false);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // 이 뒤에 코드는 작동 해요~

                        FlutterSecureStorage secureStorage = FlutterSecureStorage();
                        await secureStorage.delete(key: 'cookie');
                        await WebviewCookieManager().clearCookies();

                        debugPrint("log out");
                      }, // 임시 로그아웃 기능으로 디자인 변경에 따라 수정될 예정
                      child: const Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}