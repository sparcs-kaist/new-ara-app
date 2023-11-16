import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/pages/post_list_show_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/widgets/post_preview.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

/// 네이게이션 페이지에서 제일 먼저 보이는 메인 페이지.
class _MainPageState extends State<MainPage> {
  //각 컨텐츠 로딩을 확인하기 위한 변수
  List<bool> isLoading = [true, true, true, true, true, true, true, true];
  //각 컨텐츠 별 데이터 리스트
  List<BoardDetailActionModel> boardList = [];
  List<ArticleListActionModel> dailyBestContentList = [];
  List<ArticleListActionModel> portalContentList = [];
  List<ArticleListActionModel> facilityContentList = [];
  List<ArticleListActionModel> newAraContentList = [];
  List<ArticleListActionModel> gradContentList = [];
  List<ArticleListActionModel> underGradContentList = [];
  List<ArticleListActionModel> freshmanContentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    // TODO: 현재 api 요청 속도가 너무 느림. 병렬 처리 방식과, api 요청 속도 개선 필요. Future.wait([])로 바꾸면 개선되지 않을까 고민. 반복되는 코드 구조 개선 필요.
    refreshDailyBest(userProvider);
    refreshBoardList(userProvider);
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  /// 일일 베스트 컨텐츠 데이터를 새로고침
  void refreshDailyBest(UserProvider userProvider) async {
    // api 호출과 Provider 정보 동기화.
    List<dynamic> recentJson =
        (await userProvider.getApiRes("articles/top/"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in recentJson) {
          try {
            dailyBestContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshDailyBest ArticleListActionModel.fromJson error: $error");
          }
        }
        //debugPrint(" ----- ${dailyBestContent["results"][0]}");
        isLoading[0] = false;
      });
    }
  }

  /// 게시판 목록 안의 게시물들을 새로 고침
  void refreshBoardList(UserProvider userProvider) async {
    List<dynamic> boardJson = await userProvider.getApiRes("boards/");
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in boardJson) {
          try {
            boardList.add(BoardDetailActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshBoardList BoardDetailActionModel.fromJson failed: $error");
          }
        }
        isLoading[7] = false;
      });
    }
    // 게시판 목록 로드 후 각 게시판의 공지사항들을 새로고침
    refreshPortalNotice(userProvider);
    refreshFacilityNotice(userProvider);
    refreshNewAraNotice(userProvider);
    refreshGradAssocNotice(userProvider);
    refreshUndergradAssocNotice(userProvider);
    refreshFreshmanCouncil(userProvider);
  }

  /// 주어진 slug 값을 통해 게시판과 토픽의 ID를 찾음. topic 이 없는 경우 slug2로 ""을 넘겨주면 된다.
  List<int> findBoardID(String slug1, String slug2) {
    List<int> returnValue = [-1, -1];
    for (int i = 0; i < boardList.length; i++) {
      if (boardList[i].slug == slug1) {
        returnValue[0] = boardList[i].id;
        if (slug2 != "") {
          for (int j = 0; j < boardList[i].topics.length; j++) {
            if (boardList[i].topics[j].slug == slug2) {
              returnValue[1] = boardList[i].topics[j].id;
            }
          }
        }
      }
    }
    return returnValue;
  }

  ///포탈 게시물 글 불러오기.
  void refreshPortalNotice(UserProvider userProvider) async {
    //포탈 공지
    //  articles/?parent_board=1
    // "slug": "portal-notice",
    int boardID = findBoardID("portal-notice", "")[0];
    List<dynamic> boardArticlesJson = (await userProvider
        .getApiRes("articles/?parent_board=$boardID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in boardArticlesJson) {
          try {
            portalContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshPortalNotice ArticleListActionModel.fromJson error: $error");
          }
        }
        isLoading[1] = false;
      });
    }
  }

  ///입주 업체 게시물 글 불러오기.
  void refreshFacilityNotice(UserProvider userProvider) async {
    //articles/?parent_board=11
    //입주 업체
    // "slug": "facility-feedback",
    int boardID = findBoardID("facility-notice", "")[0];
    List<dynamic> facilityJson = (await userProvider
        .getApiRes("articles/?parent_board=$boardID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in facilityJson) {
          try {
            facilityContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshFacilityNotice ArticleListActionModel.fromJson failed: $error");
          }
        }
        isLoading[2] = false;
      });
    }
  }

  void refreshNewAraNotice(UserProvider userProvider) async {
    //뉴아라
    //        "slug": "newara-feedback",
    int boardID = findBoardID("ara-feedback", "")[0];
    List<dynamic> newAraNoticeJson = (await userProvider
        .getApiRes("articles/?parent_board=$boardID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in newAraNoticeJson) {
          try {
            newAraContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshNewAraNotice ArticleListActionModel.fromJson failed: $error");
          }
        }
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
    List<dynamic> gradJson = (await userProvider.getApiRes(
        "articles/?parent_board=$boardID&parent_topic=$topicID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in gradJson) {
          try {
            gradContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshGradAssocNotice ArticleListActionModel.fromJson failed: $error");
          }
        }
        isLoading[4] = false;
      });
    }
  }

  void refreshUndergradAssocNotice(UserProvider userProvider) async {
    // 총학
    // "slug": "students-group",
    // "slug": "undergrad-assoc",
    int boardID = findBoardID("students-group", "undergrad-assoc")[0];
    int topicID = findBoardID("students-group", "undergrad-assoc")[1];
    List<dynamic> underGradJson = (await userProvider.getApiRes(
        "articles/?parent_board=$boardID&parent_topic=$topicID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in underGradJson) {
          try {
            underGradContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshUndergradAssocNotice ArticleListActionModel.fromJson failed: $error");
          }
        }
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
    List<dynamic> freshmanJson = (await userProvider.getApiRes(
        "articles/?parent_board=$boardID&parent_topic=$topicID"))['results'];
    if (mounted) {
      setState(() {
        for (Map<String, dynamic> json in freshmanJson) {
          try {
            freshmanContentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshFreshmanCouncil ArticleListActionModel.fromJson failed: $error");
          }
        }
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
            onPressed: () async {
              await Navigator.of(context).push(slideRoute(PostWritePage()));
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () async {
              debugPrint("BulletinSearch");
              await Navigator.of(context).push(slideRoute(BulletinSearchPage(
                  boardType: BoardType.all, boardInfo: null)));
            },
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
                          Navigator.of(context)
                              .push(slideRoute(const PostListShowPage(
                            boardType: BoardType.top,
                            boardInfo: null,
                          )));
                        },
                      ),
                      const SizedBox(height: 5),
                      // 실시간 인기 글을 ListView 로 도입 예정
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          children: [
                            PopularBoard(
                              model: dailyBestContentList[0],
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
                              model: dailyBestContentList[1],
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
                              model: dailyBestContentList[2],
                              ingiNum: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: const Text(
                          '공지',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
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
                                Navigator.of(context)
                                    .push(slideRoute(PostListShowPage(
                                  boardType: BoardType.free,
                                  // TODO: 포탈 공지가 boardList[0]가 아닐 수도 있다. slug로 확인해야 한다.
                                  boardInfo: boardList[0],
                                )));
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
                                  SvgPicture.asset(
                                    'assets/icons/right_chevron.svg',
                                    color: const Color(0xFF1F4899),
                                    fit: BoxFit.fill,
                                    width: 17,
                                    height: 17,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: portalContentList[0].id)));
                              },
                              child: Text(
                                portalContentList[0].title.toString(),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(slideRoute(
                                      PostViewPage(
                                          id: portalContentList[1].id)));
                                },
                                child: Text(
                                  portalContentList[1].title.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(slideRoute(
                                      PostViewPage(
                                          id: portalContentList[2].id)));
                                },
                                child: Text(
                                  portalContentList[2].title.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(slideRoute(PostListShowPage(
                                  boardType: BoardType.free,
                                  // TODO: 입주 업체가 boardList[7]가 아닐 수도 있다. slug로 확인해야 한다.
                                  boardInfo: boardList[7],
                                )));
                              },
                              child: Row(
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
                                  SvgPicture.asset(
                                    'assets/icons/right_chevron.svg',
                                    color: const Color(0xFF646464),
                                    fit: BoxFit.fill,
                                    width: 17,
                                    height: 17,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(slideRoute(
                                              PostViewPage(
                                                  id: facilityContentList[0]
                                                      .id)));
                                        },
                                        child: Text(
                                          facilityContentList[0]
                                              .title
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(slideRoute(PostListShowPage(
                                  boardType: BoardType.free,
                                  // TODO: 뉴아라가 boardList[11]가 아닐 수도 있다. slug로 확인해야 한다.
                                  boardInfo: boardList[11],
                                )));
                              },
                              child: Row(
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
                                  SvgPicture.asset(
                                    'assets/icons/right_chevron.svg',
                                    color: const Color(0xFFED3A3A),
                                    fit: BoxFit.fill,
                                    width: 17,
                                    height: 17,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(slideRoute(
                                              PostViewPage(
                                                  id: newAraContentList[0]
                                                      .id)));
                                        },
                                        child: Text(
                                          newAraContentList[0].title.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MainPageTextButton('main_page.stu_community', () {
                        Navigator.of(context).push(slideRoute(PostListShowPage(
                          boardType: BoardType.free,
                          // TODO: 원총이 boardList[1]가 아닐 수도 있다. slug로 확인해야 한다.
                          boardInfo: boardList[1],
                        )));
                      }),
                      const SizedBox(height: 5),
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
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(slideRoute(
                                              PostViewPage(
                                                  id: gradContentList[0].id)));
                                        },
                                        child: Text(
                                          gradContentList[0].title.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
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
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(slideRoute(
                                              PostViewPage(
                                                  id: underGradContentList[0]
                                                      .id)));
                                        },
                                        child: Text(
                                          underGradContentList[0]
                                              .title
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
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
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(slideRoute(
                                              PostViewPage(
                                                  id: freshmanContentList[0]
                                                      .id)));
                                        },
                                        child: Text(
                                          freshmanContentList[0]
                                              .title
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
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

/// 실시간 인기 글을 표시하는 위젯
/// [model] 은 ArticleListActionModel 을 통해 데이터를 받아온다.
/// [ingiNum] 은 인기 글 순위를 표시한다.
class PopularBoard extends StatelessWidget {
  final ArticleListActionModel model;
  final int boardNum;

  PopularBoard(
      {super.key, required ArticleListActionModel model, int ingiNum = 1})
      : model = model,
        boardNum = ingiNum;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(slideRoute(PostViewPage(id: model.id)));
        },
        child: Container(
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
              Expanded(child: PostPreview(model: model)),
            ],
          ),
        ));
  }
}

/// 게시물 타이틀을 표시하는 위젯. 누르면 해당 게시판 전체 목록으로 이동한다.
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
          InkWell(
            onTap: onPressed,
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
                SvgPicture.asset(
                  'assets/icons/right_chevron.svg',
                  color: Colors.black,
                  width: 22,
                  height: 22,
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
