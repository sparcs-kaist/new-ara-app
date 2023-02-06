import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/models/auth_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  List<bool> switch_lights = [
    true,
    true,
    true,
    true,
    true,
    true
  ]; // 나중에 이 정보도 provider로 공유해야 할 수도 있음

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
                    '게시글',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
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
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '성인글 보기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 199),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[0],
                                  onChanged: (value) {
                                    setState(() => switch_lights[0] = value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '정치글 보기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 199),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[1],
                                  onChanged: (value) {
                                    setState(() => switch_lights[1] = value);
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
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    '차단',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
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
                    margin: EdgeInsets.only(
                        top: 14, bottom: 12, left: 15, right: 219),
                    child: GestureDetector(
                      onTap: () {}, // 추후에 기능 구현 예정
                      child: const Text(
                        '차단한 유저 목록',
                        style: TextStyle(
                          color: ColorsInfo.newara,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    '유저 차단은 게시글이나 댓글에서 더보기 기능을 통해 가능합니다.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(191, 191, 191, 1)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    '알림',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
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
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '내 글에 달린 댓글 및 대댓글',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 97),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[2],
                                  onChanged: (value) {
                                    setState(() => switch_lights[2] = value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '댓글에 달린 대댓글',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 152),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[3],
                                  onChanged: (value) {
                                    setState(() => switch_lights[3] = value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '인기 공지글',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 199),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[4],
                                  onChanged: (value) {
                                    setState(() => switch_lights[4] = value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                              child: const Text(
                            '인기글',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          const SizedBox(width: 232),
                          Container(
                            width: 43,
                            height: 27,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CupertinoSwitch(
                                  activeColor: ColorsInfo.newara,
                                  value: switch_lights[5],
                                  onChanged: (value) {
                                    setState(() => switch_lights[5] = value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    '인기 공지글 및 인기 글을 매일 오전 8시 30분에 전달해 드립니다.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(191, 191, 191, 1)),
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
