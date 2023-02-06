import 'package:flutter/material.dart';
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
                      Row(),
                      Row(),
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
