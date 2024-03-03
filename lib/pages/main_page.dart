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
import 'package:new_ara_app/utils/handle_hidden.dart';
import 'package:new_ara_app/utils/cache_function.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

/// 네이게이션 페이지에서 제일 먼저 보이는 메인 페이지.
class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  //각 컨텐츠 로딩을 확인하기 위한 변수
  final List<bool> _isLoading = [
    true, //_dailyBestContents
    true, //_portalContents
    true, //_facilityContents
    true, //_newAraContents
    true, //_gradContents
    true, //_underGradContents
    true, //_freshmanContents
    true, //_boards
    true, //_talksContents(자유게시판)
    true, //_wantedContents(구인구직)
    true, //_marketContents(중고거래)
    true, //_realEstateContents(부동산)
  ];
  //각 컨텐츠 별 데이터 리스트

  /// api 요청으로 모든 게시물 목록을 가져왔을 때 저장하는 변수
  final List<BoardDetailActionModel> _boards = [];

  final List<ArticleListActionModel> _dailyBestContents = [];
  final List<ArticleListActionModel> _portalContents = [];
  final List<ArticleListActionModel> _facilityContents = [];
  final List<ArticleListActionModel> _newAraContents = [];
  final List<ArticleListActionModel> _gradContents = [];
  final List<ArticleListActionModel> _underGradContents = [];
  final List<ArticleListActionModel> _freshmanContents = [];
  final List<ArticleListActionModel> _talksContents = [];
  final List<ArticleListActionModel> _wantedContents = [];
  final List<ArticleListActionModel> _marketContents = [];
  final List<ArticleListActionModel> _realEstateContents = [];

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    DateTime startTime = DateTime.now(); // 시작 시간 기록

    //측정하고자 하는 코드 블록
    Future.wait([
      _initBoardList(userProvider),
      _initDailyBest(userProvider),
    ]).then((results) {
      DateTime endTime = DateTime.now(); // 종료 시간 기록

      Duration duration = endTime.difference(startTime); // 두 시간의 차이 계산
      debugPrint("소요 시간: ${duration.inMilliseconds} 밀리초");
    });

    //유닛 테스트를 위한 코드 ------------
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   Navigator.of(context).push(slideRoute(const InQuiryPage()));
    // });
    //------------------------

    WidgetsBinding.instance.addObserver(this); // 옵저버 등록
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 옵저버 해제
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // 앱이 포그라운드로 전환될 때 실행할 함수
    if (state == AppLifecycleState.resumed) {
      //api를 호출 후 최신 데이터로 갱신
      await _refreshAllPosts();
    }
  }

  /// 일일 베스트 컨텐츠 데이터를 새로고침
  Future<void> _initDailyBest(UserProvider userProvider) async {
    //1. Shared_Preferences 값이 있으면(if not null) 그 값으로 UI 업데이트.
    //2. api 호출 후 새로운 response shared_preferences에 저장 후 UI 업데이트
    // api 호출과 Provider 정보 동기화.

    updateStateWithCachedOrFetchedApiData(
        apiUrl: 'articles/top/',
        userProvider: userProvider,
        callback: (response) {
          if (mounted) {
            setState(() {
              _dailyBestContents.clear();
              for (Map<String, dynamic> json in response['results']) {
                _dailyBestContents.add(ArticleListActionModel.fromJson(json));
              }
              _isLoading[0] = false;
            });
          }
        });
  }

  /// 게시판 목록 안의 게시물들을 새로 고침
  Future<void> _initBoardList(UserProvider userProvider) async {
    updateStateWithCachedOrFetchedApiData(
      apiUrl: 'boards/',
      userProvider: userProvider,
      callback: (response) async {
        if (mounted) {
          setState(() {
            _boards.clear();
            for (Map<String, dynamic> json in response!) {
              try {
                _boards.add(BoardDetailActionModel.fromJson(json));
              } catch (error) {
                debugPrint(
                    "refreshBoardList BoardDetailActionModel.fromJson failed: $error");
              }
            }
            _isLoading[7] = false;
          });
          await Future.wait([
            _initPortalNotice(userProvider),
            _initFacilityNotice(userProvider),
            _initNewAraNotice(userProvider),
            _initGradAssocNotice(userProvider),
            _initUndergradAssocNotice(userProvider),
            _initFreshmanCouncil(userProvider),
            _initTalks(userProvider),
            _initMarket(userProvider),
            _initWanted(userProvider),
            _initRealEstate(userProvider)
          ]);
        }
      },
    );
  }

  ///포탈 게시물 글 불러오기.
  Future<void> _initPortalNotice(UserProvider userProvider) async {
    await _initBoardContent(
        userProvider, "portal-notice", "", _portalContents, 1);
  }

  ///입주 업체 게시물 글 불러오기.
  Future<void> _initFacilityNotice(UserProvider userProvider) async {
    await _initBoardContent(
        userProvider, "facility-notice", "", _facilityContents, 2);
  }

  Future<void> _initNewAraNotice(UserProvider userProvider) async {
    await _initBoardContent(userProvider, "ara-notice", "", _newAraContents, 3);
  }

  Future<void> _initGradAssocNotice(UserProvider userProvider) async {
    //원총
    // "slug": "students-group",
    // "slug": "grad-assoc",
    //dev 서버랑 실제 서버 parent_topic 이 다름을 유의하기.
    //https://newara.sparcs.org/api/articles/?parent_board=2&parent_topic=24
    await _initBoardContent(
        userProvider, "students-group", "grad-assoc", _gradContents, 4);
  }

  Future<void> _initUndergradAssocNotice(UserProvider userProvider) async {
    // 총학
    // "slug": "students-group",
    // "slug": "undergrad-assoc",
    await _initBoardContent(userProvider, "students-group", "undergrad-assoc",
        _underGradContents, 5);
  }

  Future<void> _initFreshmanCouncil(UserProvider userProvider) async {
    //새학
    // "slug": "students-group",
    // "slug": "freshman-council",
    await _initBoardContent(userProvider, "students-group", "freshman-council",
        _freshmanContents, 6);
  }

  Future<void> _initTalks(UserProvider userProvider) async {
    //자유게시판
    await _initBoardContent(userProvider, "talk", "", _talksContents, 8);
  }

  Future<void> _initWanted(UserProvider userProvider) async {
    //구인구직
    await _initBoardContent(userProvider, "wanted", "", _wantedContents, 9);
  }

  Future<void> _initMarket(UserProvider userProvider) async {
    //중고거래
    await _initBoardContent(userProvider, "market", "", _marketContents, 10);
  }

  Future<void> _initRealEstate(UserProvider userProvider) async {
    //부동산
    await _initBoardContent(
        userProvider, "real-estate", "", _realEstateContents, 11);
  }

  /// 게시판의 게시물들을 불러옴. 코드 중복을 줄이기 위해 사용.
  Future<void> _initBoardContent(
      UserProvider userProvider,
      String slug1,
      String slug2,
      List<ArticleListActionModel> contentList,
      int isLoadingIndex) async {
    List<int> ids = _searchBoardID(slug1, slug2);
    int boardID = ids[0], topicID = ids[1];
    String apiUrl = topicID == -1
        ? "articles/?parent_board=$boardID"
        : "articles/?parent_board=$boardID&parent_topic=$topicID";

    updateStateWithCachedOrFetchedApiData(
        apiUrl: apiUrl,
        userProvider: userProvider,
        callback: (response) async {
          if (mounted) {
            setState(() {
              contentList.clear();

              for (Map<String, dynamic> json in response['results']) {
                try {
                  contentList.add(ArticleListActionModel.fromJson(json));
                } catch (error) {
                  debugPrint(
                      "refreshBoardContent ArticleListActionModel.fromJson failed: $error");
                }
              }
              _isLoading[isLoadingIndex] = false;
            });
          }
        });
  }

  // 모든 컨텐츠를 데이터로 불러와 화면에 재빌드
  Future<void> _refreshAllPosts() async {
    debugPrint("main_page.dart: _refreshAllPosts() called.");
    UserProvider userProvider = context.read<UserProvider>();
    await Future.wait([
      _refreshTopContents(userProvider, _dailyBestContents),
      _refreshOtherContents(userProvider, "portal-notice", "", _portalContents),
      _refreshOtherContents(
          userProvider, "facility-notice", "", _facilityContents),
      _refreshOtherContents(userProvider, "ara-notice", "", _newAraContents),
      _refreshOtherContents(
          userProvider, "students-group", "grad-assoc", _gradContents),
      _refreshOtherContents(userProvider, "students-group", "undergrad-assoc",
          _underGradContents),
      _refreshOtherContents(userProvider, "students-group", "freshman-council",
          _freshmanContents),
      _refreshOtherContents(userProvider, "talk", "", _talksContents),
      _refreshOtherContents(userProvider, "wanted", "", _wantedContents),
      _refreshOtherContents(userProvider, "market", "", _marketContents),
      _refreshOtherContents(
          userProvider, "real-estate", "", _realEstateContents),
    ]);
  }

  /// 일일 베스트 컨텐츠 데이터를 api로 불러와 화면에 재빌드
  Future<void> _refreshTopContents(UserProvider userProvider,
      List<ArticleListActionModel> contentList) async {
    String apiUrl = 'articles/top/';
    final dynamic response = await userProvider.getApiRes(apiUrl);
    if (mounted && response != null) {
      setState(() {
        contentList.clear();

        for (Map<String, dynamic> json in response['results']) {
          try {
            contentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshBoardContent ArticleListActionModel.fromJson failed: $error");
          }
        }
      });
    }
  }

  /// 일일 베스트 컨텐츠 이외의 데이터를 api로 불러와 화면에 재빌드
  Future<void> _refreshOtherContents(
    UserProvider userProvider,
    String slug1,
    String slug2,
    List<ArticleListActionModel> contentList,
  ) async {
    List<int> ids = _searchBoardID(slug1, slug2);
    int boardID = ids[0], topicID = ids[1];
    String apiUrl = topicID == -1
        ? "articles/?parent_board=$boardID"
        : "articles/?parent_board=$boardID&parent_topic=$topicID";
    final dynamic response = await userProvider.getApiRes(apiUrl);
    if (mounted && response != null) {
      setState(() {
        contentList.clear();

        for (Map<String, dynamic> json in response['results']) {
          try {
            contentList.add(ArticleListActionModel.fromJson(json));
          } catch (error) {
            debugPrint(
                "refreshBoardContent ArticleListActionModel.fromJson failed: $error");
          }
        }
      });
    }
  }

  /// 주어진 slug 값을 통해 게시판과 토픽의 ID를 찾음. topic 이 없는 경우 slug2로 ""을 넘겨주면 된다.
  List<int> _searchBoardID(String slug1, String slug2) {
    List<int> returnValue = [-1, -1];
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].slug == slug1) {
        returnValue[0] = _boards[i].id;
        if (slug2 != "") {
          for (int j = 0; j < _boards[i].topics.length; j++) {
            if (_boards[i].topics[j].slug == slug2) {
              returnValue[1] = _boards[i].topics[j].id;
            }
          }
        }
      }
    }
    return returnValue;
  }

  BoardDetailActionModel _searchBoard(String slug1) {
    for (int i = 0; i < _boards.length; i++) {
      if (_boards[i].slug == slug1) {
        return _boards[i];
      }
    }
    return _boards[0];
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
              onPressed: () {
                if (context.locale == const Locale('ko')) {
                  context.setLocale(const Locale('en'));
                } else {
                  context.setLocale(const Locale('ko'));
                }
              },
              icon: const Icon(Icons.language,color: ColorsInfo.newara,)),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/post.svg',
              colorFilter:
                  const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
            onPressed: () async {
              await Navigator.of(context)
                  .push(slideRoute(const PostWritePage()));
              await _refreshAllPosts();
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter:
                  const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
            onPressed: () async {
              await Navigator.of(context).push(slideRoute(
                  const BulletinSearchPage(
                      boardType: BoardType.all, boardInfo: null)));
              await _refreshAllPosts();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading[0] ||
                _isLoading[1] ||
                _isLoading[2] ||
                _isLoading[3] ||
                _isLoading[4] ||
                _isLoading[5] ||
                _isLoading[6] ||
                _isLoading[7] ||
                _isLoading[8] ||
                _isLoading[9] ||
                _isLoading[10] ||
                _isLoading[11]
            ? const LoadingIndicator()
            : RefreshIndicator.adaptive(
                color: ColorsInfo.newara,
                onRefresh: () async {
                  //api를 호출 후 최신 데이터로 갱신
                  await _refreshAllPosts();
                },
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTopContents(),
                        const SizedBox(height: 20),
                        _buildTalkContents(),
                        const SizedBox(height: 20),
                        _buildNoticeContents(),
                        const SizedBox(height: 20),
                        _buildTradeContents(),
                        const SizedBox(height: 20),
                        _buildStuCommunityContents(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTopContents() {
    return Column(
      children: [
        MainPageTextButton(
          'main_page.실시간 인기글'.tr(),
          () async {
            await Navigator.of(context).push(slideRoute(const PostListShowPage(
              boardType: BoardType.top,
              boardInfo: null,
            )));
            await _refreshAllPosts();
          },
        ),
        const SizedBox(height: 0),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              PopularBoard(
                model: _dailyBestContents[0],
                refreshAllPosts: _refreshAllPosts,
                boardNum: 1,
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
                model: _dailyBestContents[1],
                refreshAllPosts: _refreshAllPosts,
                boardNum: 2,
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
                model: _dailyBestContents[2],
                refreshAllPosts: _refreshAllPosts,
                boardNum: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTalkContents() {
    return Column(
      children: [
        MainPageTextButton(
          'main_page.자유게시판'.tr(),
          () async {
            await Navigator.of(context).push(slideRoute(PostListShowPage(
              boardType: BoardType.free,
              boardInfo: _searchBoard("talk"),
            )));
            await _refreshAllPosts();
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              PopularBoard(
                model: _talksContents[0],
                showBoardNumber: false,
                refreshAllPosts: _refreshAllPosts,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                ],
              ),
              PopularBoard(
                model: _talksContents[1],
                refreshAllPosts: _refreshAllPosts,
                showBoardNumber: false,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                ],
              ),
              PopularBoard(
                model: _talksContents[2],
                refreshAllPosts: _refreshAllPosts,
                showBoardNumber: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeContents() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Text(
            "main_page.공지".tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width - 40,
          // height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(240, 240, 240, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("portal-notice"),
                  )));
                  await _refreshAllPosts();
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
                    Text(
                      "main_page.포탈 공지".tr(),
                      style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF1F4899), BlendMode.srcIn),
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
              _portalContents.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[0].id)));
                        await _refreshAllPosts();
                      },
                      child: LittleText(
                        content: _portalContents[0],
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              _portalContents.length > 1
                  ? InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[1].id)));
                        await _refreshAllPosts();
                      },
                      child: LittleText(
                        content: _portalContents[1],
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              _portalContents.length > 2
                  ? InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[2].id)));
                        await _refreshAllPosts();
                      },
                      child: LittleText(
                        content: _portalContents[2],
                      ),
                    )
                  : Container(),
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
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                      boardType: BoardType.free,
                      boardInfo: _searchBoard("facility-notice"))));
                  await _refreshAllPosts();
                },
                child: Row(
                  children: [
                    Text(
                      "main_page.입주 업체".tr(),
                      style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF646464), BlendMode.srcIn),
                      fit: BoxFit.fill,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _facilityContents.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _facilityContents[0].id)));
                                await _refreshAllPosts();
                              },
                              child: LittleText(
                                content: _facilityContents[0],
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("ara-notice"),
                  )));
                  await _refreshAllPosts();
                },
                child: Row(
                  children: [
                    Text(
                      "main_page.Ara 운영진".tr(),
                      style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFFED3A3A), BlendMode.srcIn),
                      fit: BoxFit.fill,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _newAraContents.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _newAraContents[0].id)));
                                await _refreshAllPosts();
                              },
                              child: LittleText(
                                content: _newAraContents[0],
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTradeContents() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Text(
            'main_page.거래'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width - 40,
          // height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(240, 240, 240, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("real-estate"),
                  )));
                  await _refreshAllPosts();
                },
                child: Row(
                  children: [
                    Text(
                      "main_page.부동산".tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(
                      'assets/icons/right_chevron.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF4A90E2),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.fill,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _realEstateContents.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(
                                        id: _realEstateContents[0].id)));
                                await _refreshAllPosts();
                              },
                              child: LittleText(
                                content: _realEstateContents[0],
                                showTopic: true,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                      boardType: BoardType.free,
                      boardInfo: _searchBoard("market"))));
                  await _refreshAllPosts();
                },
                child: Row(
                  children: [
                    Text(
                      "main_page.중고거래".tr(),
                      style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF646464), BlendMode.srcIn),
                      fit: BoxFit.fill,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _marketContents.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _marketContents[0].id)));
                                await _refreshAllPosts();
                              },
                              child: LittleText(
                                content: _marketContents[0],
                                showTopic: true,
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("wanted"),
                  )));
                  await _refreshAllPosts();
                },
                child: Row(
                  children: [
                    Text(
                      "main_page.구인구직".tr(),
                      style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFFED3A3A), BlendMode.srcIn),
                      fit: BoxFit.fill,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _wantedContents.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _wantedContents[0].id)));
                                await _refreshAllPosts();
                              },
                              child: LittleText(
                                content: _wantedContents[0],
                                showTopic: true,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStuCommunityContents() {
    return Column(
      children: [
        MainPageTextButton('main_page.학생 단체'.tr(), () async {
          await Navigator.of(context).push(slideRoute(PostListShowPage(
              boardType: BoardType.free,
              boardInfo: _searchBoard("students-group"))));
          await _refreshAllPosts();
        }),
        const SizedBox(height: 9),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          //   height: 110,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(240, 240, 240, 1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            //  padding: const EdgeInsets.only(
            //       top: 10, bottom: 10, left: 15, right: 15),
            children: [
              Row(
                children: [
                  Text(
                    'main_page.원총'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _gradContents.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(slideRoute(
                                  PostViewPage(id: _gradContents[0].id)));
                              await _refreshAllPosts();
                            },
                            child: LittleText(
                              content: _gradContents[0],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'main_page.총학'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _underGradContents.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(slideRoute(
                                  PostViewPage(id: _underGradContents[0].id)));
                              await _refreshAllPosts();
                            },
                            child: LittleText(
                              content: _underGradContents[0],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'main_page.새학'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _freshmanContents.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(slideRoute(
                                  PostViewPage(id: _freshmanContents[0].id)));
                              await _refreshAllPosts();
                            },
                            child: LittleText(
                              content: _freshmanContents[0],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 실시간 인기 글을 표시하는 위젯
/// [model] 은 ArticleListActionModel 을 통해 데이터를 받아온다.
/// [boardNum] 은 인기 글 순위를 표시한다.
/// [showBoardNumber] 은 인기 글 순위를 표시할지 말지 결정한다.
class PopularBoard extends StatelessWidget {
  final ArticleListActionModel model;
  final int? boardNum;
  final bool? showBoardNumber;
  final Function refreshAllPosts;

  const PopularBoard(
      {super.key,
      required this.model,
      required this.refreshAllPosts,
      this.boardNum = 1,
      this.showBoardNumber = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await Navigator.of(context)
              .push(slideRoute(PostViewPage(id: model.id)));
          await refreshAllPosts();
        },
        child: Container(
          // height: 100,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBoardNumber!)
                Row(
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
                  ],
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
                  buttonTitle,
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
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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

/// 게시물 타이틀 텍스트를 표시하는 위젯.
///
/// [content] 는 ArticleListActionModel 형식으로 데이터를 받아온다.
///
/// [showTopic] 은 게시물의 부모 토픽을 표시할지 말지 결정한다.
class LittleText extends StatelessWidget {
  final ArticleListActionModel content;
  final bool showTopic;
  const LittleText({
    super.key,
    required this.content,
    this.showTopic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        children: [
          if (content.parent_topic != null && showTopic)
            TextSpan(
              text: context.locale != const Locale('ko') ?   "[${content.parent_topic!.ko_name}] ": "[${content.parent_topic!.en_name}] ",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFED3A3A),
              ),
            ),
          TextSpan(
            text:
                getTitle(content.title, content.is_hidden, content.why_hidden),
            style: TextStyle(
              color: content.is_hidden ? const Color(0xFFBBBBBB) : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
