import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/models/auth_model.dart';

List<bool> switchLights = [
  true,
  true,
  true,
  true,
  true,
  true
]; // 나중에 provider 등으로 상태 공유할 수 있게 하기

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
          icon: SvgPicture.asset('assets/icons/chevron-left.svg',
              color: ColorsInfo.newara, width: 10.7, height: 18.99),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 23),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    'setting_page.bulletin'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                BorderBoxes(94, [
                  const SizedBox(height: 10),
                  TextAndSwitch('setting_page.adult'.tr(), 0),
                  const SizedBox(height: 16),
                  TextAndSwitch('setting_page.politics'.tr(), 1),
                  const SizedBox(height: 10),
                ]),
                const SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    'setting_page.block'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
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
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    'setting_page.noti'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                BorderBoxes(94, [
                  const SizedBox(height: 10),
                  TextAndSwitch('setting_page.myreply'.tr(), 2),
                  const SizedBox(height: 16),
                  TextAndSwitch('setting_page.reply'.tr(), 3),
                  const SizedBox(height: 10),
                ]),
                const SizedBox(height: 10),
                BorderBoxes(94, [
                  const SizedBox(height: 10),
                  TextAndSwitch('setting_page.hot_noti'.tr(), 4),
                  const SizedBox(height: 16),
                  TextAndSwitch('setting_page.hot_posts'.tr(), 5),
                  const SizedBox(height: 10),
                ]),
                const SizedBox(height: 5),
                TextInfo('setting_page.hot_info'.tr()),
                const SizedBox(height: 5),
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
                        top: 14, bottom: 12, left: 15, right: 219),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthModel>().logout();
                        Navigator.pop(context);
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

class TextInfo extends StatelessWidget {
  final String info_str;
  const TextInfo(this.info_str);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: Text(
        info_str,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(191, 191, 191, 1)),
      ),
    );
  }
}

class BorderBoxes extends StatefulWidget {
  final double height;
  final List<Widget> widgetsList;
  const BorderBoxes(this.height, this.widgetsList);
  @override
  State<BorderBoxes> createState() => _BorderBoxesState();
}

class _BorderBoxesState extends State<BorderBoxes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.widgetsList,
      ),
    );
  }
}

class TextAndSwitch extends StatefulWidget {
  final String title;
  final int num;
  const TextAndSwitch(this.title, this.num);
  @override
  State<TextAndSwitch> createState() => _TextAndSwitchState();
}

class _TextAndSwitchState extends State<TextAndSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )),
        //const SizedBox(width: 199),
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 43,
          height: 27,
          child: FittedBox(
            fit: BoxFit.fill,
            child: CupertinoSwitch(
                activeColor: ColorsInfo.newara,
                value: switchLights[widget.num],
                onChanged: (value) {
                  // 현재 이 메서드는 추후 필터링 관련 개발이 시작될 때 완성될 예정임
                  setState(() => switchLights[widget.num] = value);
                }),
          ),
        ),
      ],
    );
  }
}
