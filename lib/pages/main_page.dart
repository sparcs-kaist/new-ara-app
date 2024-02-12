import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';

///SharedPreferences를 이용해 데이터 저장( 키: api url, 값: api response)
Future<void> _saveApiDataToCache(String key, dynamic data) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(data);
  await prefs.setString(key, jsonString);
}

///SharedPreferences를 이용해 데이터 불러오기( 키: api url, 값: api response)
Future<dynamic> _loadApiDataFromCache(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(key);
  if (jsonString != null) {
    return jsonDecode(jsonString);
  }
  return null;
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

/// 네이게이션 페이지에서 제일 먼저 보이는 메인 페이지.
class _MainPageState extends State<MainPage> {
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
      _refreshBoardList(userProvider),
      _refreshDailyBest(userProvider),
    ]).then((results) {
      DateTime endTime = DateTime.now(); // 종료 시간 기록

      Duration duration = endTime.difference(startTime); // 두 시간의 차이 계산
      debugPrint("소요 시간: ${duration.inMilliseconds} 밀리초");
    });

    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  /// 일일 베스트 컨텐츠 데이터를 새로고침
  Future<void> _refreshDailyBest(UserProvider userProvider) async {
    //1. Shared_Preferences 값이 있으면(if not null) 그 값으로 UI 업데이트.
    //2. api 호출 후 새로운 response shared_preferences에 저장 후 UI 업데이트

    // api 호출과 Provider 정보 동기화.
    try {
      Map<String, dynamic>? recentJson =
          await _loadApiDataFromCache('articles/top/');

      if (recentJson != null) {
        if (mounted) {
          setState(() {
            _dailyBestContents.clear();
            for (Map<String, dynamic> json in recentJson['results']) {
              _dailyBestContents.add(ArticleListActionModel.fromJson(json));
            }
            _isLoading[0] = false;
          });
        }
      }
      dynamic response = await userProvider.getApiRes("articles/top/");
      await _saveApiDataToCache('articles/top/', response);
      if (mounted) {
        setState(() {
          _dailyBestContents.clear();
          for (Map<String, dynamic> json in response!['results']) {
            _dailyBestContents.add(ArticleListActionModel.fromJson(json));
          }
          _isLoading[0] = false;
        });
      }
    } catch (error) {
      debugPrint("refreshDailyBest error: $error");
      // 적절한 에러 처리 로직 추가
    }
  }

  /// 게시판 목록 안의 게시물들을 새로 고침
  Future<void> _refreshBoardList(UserProvider userProvider) async {
    List<dynamic>? boardJson = await _loadApiDataFromCache('boards/');
    if (boardJson == null) {
      boardJson = await userProvider.getApiRes("boards/", sendText: "here");
      await _saveApiDataToCache('boards/', boardJson);

      // 게시판 목록 로드 후 각 게시판의 공지사항들을 새로고침
    } else {
      userProvider
          .getApiRes("boards/", sendText: "There")
          .then((value) async => {await _saveApiDataToCache('boards/', value)});
      // 게시판 목록 로드 후 각 게시판의 공지사항들을 새로고침
    }
    if (mounted) {
      setState(() {
        _boards.clear();
        for (Map<String, dynamic> json in boardJson!) {
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
        _refreshPortalNotice(userProvider),
        _refreshFacilityNotice(userProvider),
        _refreshNewAraNotice(userProvider),
        _refreshGradAssocNotice(userProvider),
        _refreshUndergradAssocNotice(userProvider),
        _refreshFreshmanCouncil(userProvider),
        _refreshTalks(userProvider),
        
        _refreshMarket(userProvider),
        _refreshWanted(userProvider),
        _refreshRealEstate(userProvider)
      ]);
    }
  }

  ///포탈 게시물 글 불러오기.
  Future<void> _refreshPortalNotice(UserProvider userProvider) async {
    await _refreshBoardContent(
        userProvider, "portal-notice", "", _portalContents, 1);
  }

  ///입주 업체 게시물 글 불러오기.
  Future<void> _refreshFacilityNotice(UserProvider userProvider) async {
    await _refreshBoardContent(
        userProvider, "facility-notice", "", _facilityContents, 2);
  }

  Future<void> _refreshNewAraNotice(UserProvider userProvider) async {
    await _refreshBoardContent(
        userProvider, "ara-notice", "", _newAraContents, 3);
  }

  Future<void> _refreshGradAssocNotice(UserProvider userProvider) async {
    //원총
    // "slug": "students-group",
    // "slug": "grad-assoc",
    //dev 서버랑 실제 서버 parent_topic 이 다름을 유의하기.
    //https://newara.sparcs.org/api/articles/?parent_board=2&parent_topic=24
    await _refreshBoardContent(
        userProvider, "students-group", "grad-assoc", _gradContents, 4);
  }

  Future<void> _refreshUndergradAssocNotice(UserProvider userProvider) async {
    // 총학
    // "slug": "students-group",
    // "slug": "undergrad-assoc",
    await _refreshBoardContent(userProvider, "students-group",
        "undergrad-assoc", _underGradContents, 5);
  }

  Future<void> _refreshFreshmanCouncil(UserProvider userProvider) async {
    //새학
    // "slug": "students-group",
    // "slug": "freshman-council",
    await _refreshBoardContent(userProvider, "students-group",
        "freshman-council", _freshmanContents, 6);
  }

  Future<void> _refreshTalks(UserProvider userProvider) async {
    //자유게시판
    await _refreshBoardContent(userProvider, "talk", "", _talksContents, 8);
  }

  Future<void> _refreshWanted(UserProvider userProvider) async {
    //구인구직
    await _refreshBoardContent(userProvider, "wanted", "", _wantedContents, 9);
  }

  Future<void> _refreshMarket(UserProvider userProvider) async {
    //중고거래
    await _refreshBoardContent(userProvider, "market", "", _marketContents, 10);
  }

  Future<void> _refreshRealEstate(UserProvider userProvider) async {
    //부동산
    await _refreshBoardContent(
        userProvider, "real-estate", "", _realEstateContents, 11);
  }

  /// 게시판의 게시물들을 불러옴. 코드 중복을 줄이기 위해 사용.
  Future<void> _refreshBoardContent(
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

    final Map<String, dynamic>? recentJson =
        await _loadApiDataFromCache(apiUrl);
    if (recentJson != null) {
      if (mounted) {
        setState(() {
          contentList.clear();

          for (Map<String, dynamic> json in recentJson['results']) {
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
    }

    final dynamic response = await userProvider.getApiRes(apiUrl);
    await _saveApiDataToCache(apiUrl, response);
    if (mounted) {
      setState(() {
        contentList.clear();
        for (Map<String, dynamic> json in response!['results']) {
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
            : SingleChildScrollView(
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
    );
  }

  Widget _buildTopContents() {
    return Column(
      children: [
        MainPageTextButton(
          'main_page.realtime',
          () {
            Navigator.of(context).push(slideRoute(const PostListShowPage(
              boardType: BoardType.top,
              boardInfo: null,
            )));
          },
        ),
        const SizedBox(height: 0),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              PopularBoard(
                model: _dailyBestContents[0],
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
          '자유게시판',
          () {
            Navigator.of(context).push(slideRoute(PostListShowPage(
              boardType: BoardType.free,
              boardInfo: _searchBoard("talk"),
            )));
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: [
              PopularBoard(
                model: _talksContents[0],
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
                model: _talksContents[1],
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
          child: const Text(
            '공지',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(12),
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
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("portal-notice"),
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
                      onTap: () {
                        Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[0].id)));
                      },
                      child: Text(
                        getTitle(
                            _portalContents[0].title,
                            _portalContents[0].is_hidden,
                            _portalContents[0].why_hidden),
                        style: TextStyle(
                            color: _portalContents[0].is_hidden
                                ? const Color(0xFFBBBBBB)
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              _portalContents.length > 1
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[1].id)));
                      },
                      child: Text(
                        getTitle(
                            _portalContents[1].title,
                            _portalContents[1].is_hidden,
                            _portalContents[1].why_hidden),
                        style: TextStyle(
                            color: _portalContents[1].is_hidden
                                ? const Color(0xFFBBBBBB)
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              _portalContents.length > 2
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(slideRoute(
                            PostViewPage(id: _portalContents[2].id)));
                      },
                      child: Text(
                        getTitle(
                            _portalContents[2].title,
                            _portalContents[2].is_hidden,
                            _portalContents[2].why_hidden),
                        style: TextStyle(
                            color: _portalContents[2].is_hidden
                                ? const Color(0xFFBBBBBB)
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
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
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                      boardType: BoardType.free,
                      boardInfo: _searchBoard("facility-notice"))));
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _facilityContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _facilityContents[0].title,
                                    _facilityContents[0].is_hidden,
                                    _facilityContents[0].why_hidden),
                                style: TextStyle(
                                    color: _facilityContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          : Container(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("ara-notice"),
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _newAraContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _newAraContents[0].title,
                                    _newAraContents[0].is_hidden,
                                    _newAraContents[0].why_hidden),
                                style: TextStyle(
                                    color: _newAraContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          child: const Text(
            '거래',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(12),
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
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("real-estate"),
                  )));
                },
                child: Row(
                  children: [
                    const Text(
                      "부동산",
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
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF1F4899), BlendMode.srcIn),
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(
                                        id: _realEstateContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _realEstateContents[0].title,
                                    _realEstateContents[0].is_hidden,
                                    _realEstateContents[0].why_hidden),
                                style: TextStyle(
                                    color: _realEstateContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                      boardType: BoardType.free,
                      boardInfo: _searchBoard("market"))));
                },
                child: Row(
                  children: [
                    const Text(
                      "중고거래",
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _marketContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _marketContents[0].title,
                                    _marketContents[0].is_hidden,
                                    _marketContents[0].why_hidden),
                                style: TextStyle(
                                    color: _marketContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          : Container(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                    boardType: BoardType.free,
                    boardInfo: _searchBoard("wanted"),
                  )));
                },
                child: Row(
                  children: [
                    const Text(
                      "구인구직",
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _wantedContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _wantedContents[0].title,
                                    _wantedContents[0].is_hidden,
                                    _wantedContents[0].why_hidden),
                                style: TextStyle(
                                    color: _wantedContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
        MainPageTextButton('main_page.stu_community', () {
          Navigator.of(context).push(slideRoute(PostListShowPage(
              boardType: BoardType.free,
              boardInfo: _searchBoard("students-group"))));
        }),
        const SizedBox(height: 9),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          //   height: 110,
          padding: const EdgeInsets.all(12),
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
                      child: _gradContents.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _gradContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _gradContents[0].title,
                                    _gradContents[0].is_hidden,
                                    _gradContents[0].why_hidden),
                                style: TextStyle(
                                    color: _gradContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          : Container(),
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
                      child: _underGradContents.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(
                                        id: _underGradContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _underGradContents[0].title,
                                    _underGradContents[0].is_hidden,
                                    _underGradContents[0].why_hidden),
                                style: TextStyle(
                                    color: _underGradContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          : Container(),
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
                      child: _freshmanContents.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(id: _freshmanContents[0].id)));
                              },
                              child: Text(
                                getTitle(
                                    _freshmanContents[0].title,
                                    _freshmanContents[0].is_hidden,
                                    _freshmanContents[0].why_hidden),
                                style: TextStyle(
                                    color: _freshmanContents[0].is_hidden
                                        ? const Color(0xFFBBBBBB)
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
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
}

/// 실시간 인기 글을 표시하는 위젯
/// [model] 은 ArticleListActionModel 을 통해 데이터를 받아온다.
/// [boardNum] 은 인기 글 순위를 표시한다.
/// [showBoardNumber] 은 인기 글 순위를 표시할지 말지 결정한다.
class PopularBoard extends StatelessWidget {
  final ArticleListActionModel model;
  final int? boardNum;
  final bool? showBoardNumber;

  const PopularBoard(
      {super.key,
      required this.model,
      this.boardNum = 1,
      this.showBoardNumber = true});

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
