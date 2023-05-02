import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';

List<bool> switchLights = [
  true,
  true,
  true,
  true,
  true,
  true
]; // 나중에 provider 등으로 상태 공유할 수 있게 하기

List<List<Widget>> switchItems = [
  [
    const SizedBox(height: 10),
    TextAndSwitch('setting_page.adult'.tr(), 0),
    const SizedBox(height: 16),
    TextAndSwitch('setting_page.politics'.tr(), 1),
    const SizedBox(height: 10),
  ],
  [
    const SizedBox(height: 10),
    TextAndSwitch('setting_page.myreply'.tr(), 2),
    const SizedBox(height: 16),
    TextAndSwitch('setting_page.reply'.tr(), 3),
    const SizedBox(height: 10),
  ],
  [
    const SizedBox(height: 10),
    TextAndSwitch('setting_page.hot_noti'.tr(), 4),
    const SizedBox(height: 16),
    TextAndSwitch('setting_page.hot_posts'.tr(), 5),
    const SizedBox(height: 10),
  ]
];

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
