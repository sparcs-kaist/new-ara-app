import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/constants/constants.dart';
import 'package:new_ara_app/pages/setting_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ninesens',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 240, 240, 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              highlightColor: Colors.white,
              splashColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/icons/gear.svg',
                color: ColorsInfo.newara,
                width: 20,
                height: 20,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
          ),
          _buildSizedBox(20),
        ],
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
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      // 컨테이너간 여백은 Sizedbox 이용하기
                      _buildSizedBox(10),
                      // 이름 및 이메일
                      Container(
                        width: 250,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '즐거운 넙죽이 123abc', // Sample text
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'ninesens@kaist.ac.kr', // Sample text
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildSizedBox(30),
                      Container(
                        width: 26,
                        height: 21,
                        child: GestureDetector(
                          onTap: () {}, // 추후에 프로필 수정 기능 구현 예정
                          child: const Text(
                            '수정',
                            style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: ColorsInfo.newara,
                  indicatorColor: ColorsInfo.newara,
                  tabs: [
                    Tab(
                      child: Text(
                        '작성한 글',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '담아둔 글',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '최근 본 글',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 24,
                  child: Text(
                    '총 N개의 글',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 500,
                  child: TabBarView(
                    children: [
                      Container(child: Center(child: Text('없음'))),
                      Container(child: Center(child: Text('없음'))),
                      Container(child: Center(child: Text('없음'))),
                    ],
                    controller: _tabController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildSizedBox(double width) {
    return SizedBox(
      width: width,
    );
  }
}
