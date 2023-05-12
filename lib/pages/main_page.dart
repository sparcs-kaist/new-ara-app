// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/free_bulletin_board_page.dart';
import 'package:new_ara_app/pages/specific_bulletin_board_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> textContent = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    refreshDailyBest(userProvider);
  }

  void refreshDailyBest(UserProvider userProvider) async {
    //example
    //Provider 에 있는 정보 사용.
    var myMap = userProvider.getApiRes("home");

    setState(() {
      textContent.clear();
      textContent.add(myMap?["daily_bests"][0] ?? {});
      textContent.add(myMap?["daily_bests"][1] ?? {});
      textContent.add(myMap?["daily_bests"][2] ?? {});
    });

    // api 호출과 Provider 정보 동기화.
    await userProvider.synApiRes("home", "home");
    // await Future.delayed(Duration(seconds: 1));
    myMap = userProvider.getApiRes("home");
    if (mounted) {
      setState(() {
        textContent.clear();
        textContent.add(myMap?["daily_bests"][0] ?? {});
        textContent.add(myMap?["daily_bests"][1] ?? {});
        textContent.add(myMap?["daily_bests"][2] ?? {});
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/post.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const LoadingIndicator()
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MainPageTextButton(
                        'main_page.realtime',
                        () {
                          //잠시 free_bulletin_board 들 테스트 하기 위한
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FreeBulletinBoardPage()),
                          );
                        },
                      ),
                      // 실시간 인기 글을 ListView 로 도입 예정
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          children: [
                            PopularBoard(
                              json: textContent[0],
                              ingiNum: 1,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 28,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0xFFF0F0F0),
                                  ),
                                ),
                              ],
                            ),
                            PopularBoard(
                              json: textContent[1],
                              ingiNum: 2,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 28,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0xFFF0F0F0),
                                  ),
                                ),
                              ],
                            ),
                            PopularBoard(
                              json: textContent[2],
                              ingiNum: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MainPageTextButton('main_page.notice', () {
                        //잠시 free_bulletin_board들 테스트 하기 위한
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SpecificBulletinBoardPage()),
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width - 40,
                        // height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/kaist.svg',
                                  fit: BoxFit.cover,
                                ),
                                const Text(
                                  "포탈 공지",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F4899),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 11,
                                  width: 6,
                                  child: SvgPicture.asset(
                                    'assets/icons/chevron-right.svg',
                                    color: const Color(0xFF1F4899),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "2023년 의생명과학분야 대학원 장학생 선발 안내sdffsfdssfdfsds",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "[국제협력팀] 워크샵 안내 (10/7, 금)",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "코로나19 (COVID-19) 상황일지 (2022. 10. 6. 0시 기준)afddfad",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              height: 1,
                              color: const Color(0xFFF0F0F0),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "입주 업체",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF646464),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 11,
                                  width: 6,
                                  child: SvgPicture.asset(
                                    'assets/icons/chevron-right.svg',
                                    color: const Color(0xFF646464),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Expanded(
                                  child: Text(
                                    "북측식당 웰차이 운영안내dsfsfdsdfsdsdfsdf",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "뉴아라",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFED3A3A),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 11,
                                  width: 6,
                                  child: SvgPicture.asset(
                                    'assets/icons/chevron-right.svg',
                                    color: const Color(0xFFED3A3A),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Expanded(
                                  child: Text(
                                    "🎉 뉴아라 v2.0.0 Amethyst 배포 완료dddddd",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MainPageTextButton('main_page.stu_community', () {}),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          children: [
                            SizedBox(
                              height: 28,
                              child: Row(
                                children: const [
                                  Text(
                                    '원총',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "2023년 의생명과학분야 대학원 장학생 선발 안내",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 28,
                              child: Row(
                                children: const [
                                  Text(
                                    '총학',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "2022년도 제14차 중앙운영위원회 (9월 정기회)ㄴㅇㄹㄴㅇㄹㄴㄹ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 28,
                              child: Row(
                                children: const [
                                  Text(
                                    '새학',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "2022년도 제14차 중앙운영위원회 (9월 정기회)ㄴㅇㄹㄴㅇㄹㄴㄹ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class PopularBoard extends StatelessWidget {
  final Map<String, dynamic> json;
  final int boardNum;

  PopularBoard({super.key, Map<String, dynamic>? json, int ingiNum = 1})
      : json = json ?? {},
        boardNum = ingiNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 13,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  boardNum.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(child: PostPreview(json: json)),
        ],
      ),
    );
  }
}

class MainPageTextButton extends StatelessWidget {
  final String buttonTitle;
  var onPressed = () {};
  MainPageTextButton(this.buttonTitle, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        children: [
          TextButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Text(
                  buttonTitle.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 6.56,
                ),
                SizedBox(
                  width: 7.28,
                  height: 13.75,
                  child: SvgPicture.asset(
                    'assets/icons/chevron-right.svg',
                    color: Colors.black,
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
