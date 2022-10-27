import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appBar.mypage'.tr(),
            style: Theme.of(context).textTheme.headline1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  child: Row(
                    children: [
                      // 프로필 이미지
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      // 컨테이너간 여백은 Sizedbox 이용하기
                      const SizedBox(
                        width: 10,
                      ),
                      // 이름 및 이메일
                      Container(
                        width: 250,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '뉴아라 관리자', // Sample text
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'new-ara@sparcs.org', // Sample text
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 수정 버튼
                      Container(
                        width: 50,
                        height: 50,
                        child: TextButton(
                          onPressed: () {}, // 수정 기능 개발되면 사용하기
                          child: const Text('myPage.change',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: NEWARA_COLOR))
                              .tr(),
                        ),
                      ),
                    ],
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
