import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/free_bulletin_board_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
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
  List<bool> isLoading = [true, true, true, true, true, true, true, true];
  List<dynamic> boardList = [];
  Map<String, dynamic> dailyBestContent = {};
  Map<String, dynamic> portalContent = {};
  Map<String, dynamic> facilityContent = {};
  Map<String, dynamic> newAraContent = {};
  Map<String, dynamic> gradContent = {};
  Map<String, dynamic> underGradContent = {};
  Map<String, dynamic> freshmanContent = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    refreshDailyBest(userProvider);
    refreshBoardList(userProvider);
  }

  void refreshDailyBest(UserProvider userProvider) async {
    // api 호출과 Provider 정보 동기화.
    await userProvider.synApiRes("articles/recent/");
    if (mounted) {
      setState(() {
        dailyBestContent = userProvider.getApiRes("articles/recent/");
        debugPrint(" ----- ${dailyBestContent["results"][0]}");
        isLoading[0] = false;
      });
    }
  }

  void refreshBoardList(UserProvider userProvider) async {
    //Provider 에  api res 주입
    await userProvider.synApiRes("boards/");
    if (mounted) {
      setState(() {
        boardList = userProvider.getApiRes("boards/");
        isLoading[7] = false;
      });
    }

    refreshPortalNotice(userProvider);
    refreshFacilityNotice(userProvider);
    refreshNewAraNotice(userProvider);
    refreshGradAssocNotice(userProvider);
    refreshUndergradAssocNotice(userProvider);
    refreshFreshmanCouncil(userProvider);
  }

  List<int> findBoardID(String slug1, String slug2) {
    //topic 이 없는 경우 slug2로 ""을 넘겨준다.

    List<int> returnValue = [-1, -1];
    for (int i = 0; i < boardList.length; i++) {
      if (boardList[i]["slug"] == slug1) {
        returnValue[0] = boardList[i]["id"];
        if (slug2 != "") {
          for (int j = 0; j < boardList[i]["topics"].length; j++) {
            if (boardList[i]["topics"][j]["slug"] == slug2) {
              returnValue[1] = boardList[i]["topics"][j]["id"];
            }
          }
        }
      }
    }
    return returnValue;
  }

  void refreshPortalNotice(UserProvider userProvider) async {
    //포탈 공지
    //  articles/?parent_board=1
    // "slug": "portal-notice",
    int boardID = findBoardID("portal-notice", "")[0];
    await userProvider.synApiRes("articles/?parent_board=$boardID");
    if (mounted) {
      setState(() {
        portalContent =
            userProvider.getApiRes("articles/?parent_board=$boardID");
        isLoading[1] = false;
      });
    }
  }

  void refreshFacilityNotice(UserProvider userProvider) async {
    //articles/?parent_board=11
    //입주 업체
    // "slug": "facility-feedback",
    int boardID = findBoardID("facility-feedback", "")[0];
    await userProvider.synApiRes("articles/?parent_board=$boardID");
    if (mounted) {
      setState(() {
        facilityContent =
            userProvider.getApiRes("articles/?parent_board=$boardID");
        isLoading[2] = false;
      });
    }
  }

  void refreshNewAraNotice(UserProvider userProvider) async {
    //뉴아라
    //        "slug": "newara-feedback",
    int boardID = findBoardID("newara-feedback", "")[0];
    await userProvider.synApiRes("articles/?parent_board=$boardID");
    if (mounted) {
      setState(() {
        newAraContent =
            userProvider.getApiRes("articles/?parent_board=$boardID");
        isLoading[3] = false;
      });
    }
  }

  void refreshGradAssocNotice(UserProvider userProvider) async {
    //원총
    // "slug": "students-group",
    // "slug": "grad-assoc",
    //dev 서버랑 실제 서버 parent_topic 이 다름을 유의하기.
    //https://newara.sparcs.org/api/articles/?parent_board=2&parent_topic=24
    int boardID = findBoardID("students-group", "grad-assoc")[0];
    int topicID = findBoardID("students-group", "grad-assoc")[1];
    await userProvider
        .synApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
    if (mounted) {
      setState(() {
        gradContent = userProvider
            .getApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
        isLoading[4] = false;
      });
    }
  }

  void refreshUndergradAssocNotice(UserProvider userProvider) async {
    //총학
    // "slug": "students-group",
    // "slug": "undergrad-assoc",
    int boardID = findBoardID("students-group", "undergrad-assoc")[0];
    int topicID = findBoardID("students-group", "undergrad-assoc")[1];
    await userProvider
        .synApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
    if (mounted) {
      setState(() {
        underGradContent = userProvider
            .getApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
        isLoading[5] = false;
      });
    }
  }

  void refreshFreshmanCouncil(UserProvider userProvider) async {
    //새학
    // "slug": "students-group",
    // "slug": "freshman-council",
    int boardID = findBoardID("students-group", "freshman-council")[0];
    int topicID = findBoardID("students-group", "freshman-council")[1];
    await userProvider
        .synApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
    if (mounted) {
      setState(() {
        freshmanContent = userProvider
            .getApiRes("articles/?parent_board=$boardID&parent_topic=$topicID");
        isLoading[6] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostWritePage(),
                ),
              );
            },
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
        child: isLoading[0] ||
                isLoading[1] ||
                isLoading[2] ||
                isLoading[3] ||
                isLoading[4] ||
                isLoading[5] ||
                isLoading[6] ||
                isLoading[7]
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
                                builder: (context) =>
                                    const FreeBulletinBoardPage(
                                      boardType: BoardType.recent,
                                      boardInfo: null,
                                    )),
                          );
                        },
                      ),
                      // 실시간 인기 글을 ListView 로 도입 예정
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          children: [
                            PopularBoard(
                              json: dailyBestContent["results"][0],
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
                              json: dailyBestContent["results"][1],
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
                              json: dailyBestContent["results"][2],
                              ingiNum: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MainPageTextButton(
                        'main_page.notice',
                        () {
                          //잠시 free_bulletin_board들 테스트 하기 위한
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SpecificBulletinBoardPage()),
                          );
                        },
                      ),
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FreeBulletinBoardPage(
                                            boardType: BoardType.free,
                                            boardInfo: boardList[0],
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 19,
                                    height: 19,
                                    child: Image.asset(
                                      'assets/icons/kaist.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
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
                                      'assets/icons/right_chevron.svg',
                                      color: const Color(0xFF1F4899),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              portalContent["results"][0]["title"],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              portalContent["results"][1]["title"],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              portalContent["results"][2]["title"],
                              style: const TextStyle(
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
                                    'assets/icons/right_chevron.svg',
                                    color: const Color(0xFF646464),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    facilityContent["results"][0]["title"],
                                    style: const TextStyle(
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
                                    'assets/icons/right_chevron.svg',
                                    color: const Color(0xFFED3A3A),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    newAraContent["results"][0]["title"],
                                    style: const TextStyle(
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
                        //   height: 110,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          //  padding: const EdgeInsets.only(
                          //       top: 10, bottom: 10, left: 15, right: 15),
                          children: [
                            SizedBox(
                              height: 28,
                              child: Row(
                                children: [
                                  const Text(
                                    '원총',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      gradContent["results"][0]["title"],
                                      style: const TextStyle(
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
                                children: [
                                  const Text(
                                    '총학',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      underGradContent["results"][0]["title"],
                                      style: const TextStyle(
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
                                children: [
                                  const Text(
                                    '새학',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color.fromRGBO(177, 177, 177, 1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      freshmanContent["results"][0]["title"],
                                      style: const TextStyle(
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

  PopularBoard(
      {super.key, required Map<String, dynamic>? json, int ingiNum = 1})
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
  final void Function() onPressed;
  const MainPageTextButton(this.buttonTitle, this.onPressed, {super.key});

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
                    'assets/icons/right_chevron.svg',
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
