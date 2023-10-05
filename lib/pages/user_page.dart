/// 사용자 본인 정보 표시 페이지를 관리하는 파일
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/setting_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/models/scrap_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/pages/profile_edit_page.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

/// 사용자 본인 정보 페이지의 빌드 및 이벤츠 처리를 담당하는 위젯
class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ScrollController> scrollControllerList = [
    ScrollController(), // 작성한 글 ListView
    ScrollController(), // 담아둔 글 ListView
    ScrollController() // 최근 본 글 ListView
  ];

  // TODO: magic number enum 대체 고려하기

  /// 작성한 글, 담아둔 글, 최근 본 글 ListView에 대해
  /// 스크롤의 가장 하단에 도달하여 새로운 페이지를 불러오는지 여부를 표시함.
  List<bool> isLoadingNewPage = [false, false, false];

  /// 작성한 글 ListView에 들어가는 모델 리스트
  List<ArticleListActionModel> createdArticleList = [];

  /// 담아둔 글 ListView에 들어가는 모델 리스트
  List<ScrapModel> scrappedArticleList = [];

  /// 최근 본 글 ListView에 들어가는 모델 리스트
  List<ArticleListActionModel> recentArticleList = [];

  /// 작성한 글, 담아둔 글, 최근 본 글 각각의 총 개수를 나타냄.
  /// 0: 작성한 글, 1: 담아둔 글, 2: 최근 본 글
  List<int> tabCount = [0, 0, 0];

  /// 작성한 글, 담아둔 글, 최근 본 글 중
  /// 현재 사용자가 위치한 탭의 tabCount를 나타냄.
  int curCount = 0;

  /// 작성한 글, 담아둔 글, 최근 본 글 각각에 대해
  /// 글 리스트 로드가 완료되었는지 여부.
  List<bool> isLoadedList = [false, false, false];

  /// 작성한 글, 담아둔 글, 최근 본 글 각각에 대해
  /// 현재 로드한 마지막 페이지를 나타냄.
  List<int> curPage = [1, 1, 1];

  final List<String> _tabs = [
    'myPage.mypost'.tr(),
    'myPage.scrap'.tr(),
    'myPage.recent'.tr()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);

    scrollControllerList[0].addListener(_scrollListener0);
    scrollControllerList[1].addListener(_scrollListener1);
    scrollControllerList[2].addListener(_scrollListener2);

    // 페이지 로드 시에 새로운 알림 여부를 조회함.
    context.read<NotificationProvider>().checkIsNotReadExist();

    UserProvider userProvider = context.read<UserProvider>();

    // 초기 데이터를 로드함.
    fetchInitData(userProvider);
  }

  /// 사용자의 정보, 사용자가 작성한 글을 로드함.
  /// 현재 initState에서만 사용되고 있음.
  /// API 통신을 위해 userProvider를 전달받으며
  /// 별도의 리턴값 없이 작업 완료 후 state를 바로 업데이트함.
  Future<void> fetchInitData(UserProvider userProvider) async {
    bool userFetchRes = await userProvider.apiMeUserInfo(); // 유저 정보 조회
    if (!userFetchRes) {
      debugPrint("최신 유저정보 조회 실패!");
    }
    isLoadedList[0] = await fetchCreatedArticles(userProvider, 1); // 작성한 글 조회
    setCurCount(0); // state 업데이트
  }

  void setIsLoadingNewPage(int index, bool value) {
    if (mounted) setState(() => isLoadingNewPage[index] = value);
  }

  /// funcNum: 실행하고 싶은 함수를 지정
  /// userProvider, funcNum, page를 전달받아 funcNum에 해당하는 함수를 실행함.
  /// 실행 후 성공 여부를 bool 타입으로 반환.
  /// UserPage에서 경우에 따라 다른 fetching 메서드를 사용해야 하는 경우가 많아
  /// 이를 편리하게 하기 위해 생성함.
  Future<bool> selectFetchFunc(
      UserProvider userProvider, int funcNum, int page) async {
    if (funcNum == 0) {
      return await fetchCreatedArticles(userProvider, page);
    } else if (funcNum == 1) {
      return await fetchScrappedArticles(userProvider, page);
    } else {
      return await fetchRecentArticles(userProvider, page);
    }
  }

  /// 별도의 설정 없이 state를 업데이트 하고 싶을 때 사용.
  void update() {
    if (mounted) setState(() {});
  }

  /// 유저가 탭 전환을 하였을 때 전환된 탭의 새로고침을 위해 사용됨.
  /// API 통신을 위해 userProvider, 전환된 탭을 나타내는 newTabIndex를 전달받음.
  /// 별도의 리턴값없이 전환되는 탭의 새로고침 완료 후 state를 변경함.
  /// 실패하는 경우 로딩 상태로 남게됨.
  Future<void> fetchNewTab(UserProvider userProvider, int newTabIndex) async {
    setIsLoaded(false, 0);
    setIsLoaded(false, 1);
    setIsLoaded(false, 2);
    bool res = await selectFetchFunc(userProvider, newTabIndex, 1);
    if (!res) return;
    curPage[newTabIndex] = 1;
    setCurCount(newTabIndex);
    setIsLoaded(true, newTabIndex);
  }

  /// TabController를 구독하며 탭 간 전환을 제어하기 위해 만들어짐.
  void _handleTabChange() {
    int newTabIndex = _tabController.index;
    UserProvider userProvider = context.read<UserProvider>();
    // TabController에서 탭 전환이 이루어지는 경우는 두 가지로
    // 1. Tap으로 전환, 2. Swipe로 전환
    // TabController가 두 가지를 동시에 인식하지 못해
    // 아래와 같이 경우에 따라 다르게 처리함.
    if (!_tabController.indexIsChanging) {
      if (_tabController.animation!.isCompleted) {
        return;
      } else {
        // Swipe
        fetchNewTab(userProvider, newTabIndex);
      }
    } else {
      // Tap
      fetchNewTab(userProvider, newTabIndex);
    }
  }

  // TODO: 리스너별로 겹치는 로직 메서드화하기
  void _scrollListener0() async {
    // 새로운 페이지를 로드 중인 경우 스크롤의 끝에 도달하여도 무시함.
    if (isLoadingNewPage[0]) return;

    if (isLoadedList[0] &&
        scrollControllerList[0].position.pixels ==
            scrollControllerList[0].position.maxScrollExtent) {
      setIsLoadingNewPage(0, true);
      bool res = await fetchCreatedArticles(
          context.read<UserProvider>(), curPage[0] + 1);
      if (res) curPage[0] += 1;
      setIsLoadingNewPage(0, false);
    }
  }

  void _scrollListener1() async {
    // 새로운 페이지를 로드 중인 경우 스크롤의 끝에 도달하여도 무시함.
    if (isLoadingNewPage[1]) return;
    if (isLoadedList[1] &&
        scrollControllerList[1].position.pixels ==
            scrollControllerList[1].position.maxScrollExtent) {
      setIsLoadingNewPage(1, true);
      bool res = await fetchScrappedArticles(
          context.read<UserProvider>(), curPage[1] + 1);
      if (res) curPage[1] += 1;
      setIsLoadingNewPage(1, false);
    }
  }

  void _scrollListener2() async {
    // 새로운 페이지를 로드 중인 경우 스크롤의 끝에 도달하여도 무시함.
    if (isLoadingNewPage[2]) return;
    if (isLoadedList[2] &&
        scrollControllerList[2].position.pixels ==
            scrollControllerList[2].position.maxScrollExtent) {
      setIsLoadingNewPage(2, true);
      bool res = await fetchRecentArticles(
          context.read<UserProvider>(), curPage[2] + 1);
      if (res) curPage[2] += 1;
      setIsLoadingNewPage(2, false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (int i = 0; i < 3; i++) {
      scrollControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (userProvider.hasData == true ? userProvider.naUser!.nickname : ""),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.white,
            splashColor: Colors.white,
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () {
              Navigator.of(context).push(slideRoute(const SettingPage()));
            },
          ),
          const SizedBox(width: 11),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: 60,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48),
                          child: userProvider.naUser?.picture == null
                              ? Container()
                              : Image.network(
                                  fit: BoxFit.cover,
                                  userProvider.naUser!.picture.toString()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${userProvider.naUser!.sso_user_info['first_name']} ${userProvider.naUser!.sso_user_info['last_name']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              userProvider.naUser == null
                                  ? "이메일 정보가 없습니다."
                                  : "${userProvider.naUser?.email}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 26,
                      height: 21,
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditPage(),
                            ),
                          );
                        },
                        child: Text(
                          'myPage.change'.tr(),
                          style: const TextStyle(
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
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: TabBar(
                  unselectedLabelColor: const Color.fromRGBO(177, 177, 177, 1),
                  labelColor: ColorsInfo.newara,
                  indicatorColor: ColorsInfo.newara,
                  tabs: _tabs.map((String tab) {
                    return Tab(text: tab);
                  }).toList(),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) async {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 14),
                width: MediaQuery.of(context).size.width - 40,
                height: 24,
                child: Text(
                  '총 $curCount개의 글',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(177, 177, 177, 1),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      !isLoadedList[0]
                          ? const LoadingIndicator()
                          : _buildPostList(0, userProvider),
                      !isLoadedList[1]
                          ? const LoadingIndicator()
                          : _buildPostList(1, userProvider),
                      !isLoadedList[2]
                          ? const LoadingIndicator()
                          : _buildPostList(2, userProvider),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: 아래 3가지 fetch함수 generic type 이용해서 하나로 통합하기
  // PR #8 코드 참고.

  /// 해당 페이지의 글을 불러와 모델로 변환 후 createdArtielcList에 추가.
  /// API 통신을 위해 userProvider, fetch 대상 페이지를 나타내는 page.
  /// 리스트에 추가하는 작업까지 성공하면 true, 아니라면 false 반환.
  Future<bool> fetchCreatedArticles(UserProvider userProvider, int page) async {
    int user = userProvider.naUser!.user;
    String apiUrl = "/api/articles/?page=$page&created_by=$user";
    if (page == 1) {
      createdArticleList.clear();
    }
    try {
      var response = await userProvider.myDio().get("$newAraDefaultUrl$apiUrl");
      if (response.statusCode != 200) return false;
      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost == null) {
          continue; // 가끔 형식에 맞지 않은 데이터를 가진 글이 있어 넣어놓음(2023.05.26)
        }
        try {
          createdArticleList.add(ArticleListActionModel.fromJson(rawPost));
        } catch (error) {
          // 여기서 에러가 발생하게 된다면
          // 1. models 에 있는 모델의 타입이 올바르지 않은 경우 -> 수정하기
          // 2. models 의 타입은 올바르게 설계됨. 그러나 이전 개발 과정에서 필드 설정을 잘못한(또는 달랐던) 경우 -> 그냥 넘어가기
          debugPrint(
              "createdArticleList.add failed at index $i (id: ${rawPost['id']}) : $error");
        }
      }
      tabCount[0] = response.data['num_items'];
      debugPrint("fetchCreatedArticles() succeeded for page: $page");
      return true;
    } catch (error) {
      debugPrint("fetchCreatedArticles() failed with error: $error");
      return false;
    }
  }

  /// 담아둔 글의 해당 페이지를 불러와 모델로 변환 후 scrappedArticleList에 저장.
  /// API 통신을 위해 userProvider, 페이지 지정을 위해 page 전달받음.
  /// 리스트 저장까지 성공 시에 true, 아니면 false 반환.
  Future<bool> fetchScrappedArticles(
      UserProvider userProvider, int page) async {
    int user = userProvider.naUser!.user;
    String apiUrl = "/api/scraps/?page=$page&created_by=$user";
    if (page == 1) {
      scrappedArticleList.clear();
    }
    try {
      var response = await userProvider.myDio().get('$newAraDefaultUrl$apiUrl');
      if (response.statusCode != 200) return false;
      debugPrint(
          "fetchScrappedArticles() GET request (page: $page): ${response.statusCode}");
      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost == null) continue;
        try {
          scrappedArticleList.add(ScrapModel.fromJson(rawPost));
        } catch (error) {
          debugPrint(
              "scrappedArticleList.add failed at index $i (id: ${rawPost['id']}) : $error");
        }
      }
      tabCount[1] = response.data['num_items'];
      debugPrint("fetchCreatedArticles() succeeded for page: $page");
      return true;
    } catch (error) {
      debugPrint("fetchScrappedArticles() failed with error: $error");
      return false;
    }
  }

  /// 최근 본 글의 해당하는 페이지를 불러오고 recentArticleList에 저장.
  /// API 통신을 위해 userProvider, 페이지 지정을 위해 page 전달받음.
  /// 리스트 저장까지 성공하면 true, 아니면 false 리턴.
  Future<bool> fetchRecentArticles(UserProvider userProvider, int page) async {
    String apiUrl = "/api/articles/recent/?page=$page";
    if (page == 1) {
      recentArticleList.clear();
    }
    try {
      var response = await userProvider.myDio().get('$newAraDefaultUrl$apiUrl');
      debugPrint(
          "fetchRecentArticles() GET request (page: $page): ${response.statusCode}");
      if (response.statusCode != 200) return false;
      debugPrint("fetchRecentArticles() succeed!");
      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost == null) continue;
        try {
          recentArticleList.add(ArticleListActionModel.fromJson(rawPost));
        } catch (error) {
          debugPrint(
              "recentArticleList.add failed at index $i (id: ${rawPost['id']}) : $error");
        }
      }
      tabCount[2] = response.data['num_items'];
      debugPrint("fetchCreatedArticles() succeeded for page: $page");
      return true;
    } catch (error) {
      debugPrint("fetchRecentArticles() failed with error: $error");
      return false;
    }
  }

  /// 탭별 컨텐츠 로드 완료 여부를 설정하고 state를 업데이트하는 메서드.
  /// ListView refresh, 탭 전환 시에 사용됨.
  void setIsLoaded(bool value, int tabIndex) =>
      setState(() => isLoadedList[tabIndex] = value);

  // TODO: 더이상 사용하지 않는 메서드. 제거하기.
  void setMyCount(int value, int tabIndex) {
    setState(() => tabCount[tabIndex] = value);
    setState(() => curCount = tabCount[tabIndex]);
  }

  /// "총 $curCount개의 글" 문구에 표시되는 curCount 변수를 설정하고
  /// State를 업데이트하는 메서드. 탭이 전환될 때마다 사용됨.
  void setCurCount(int tabIndex) {
    if (mounted) setState(() => curCount = tabCount[tabIndex]);
  }

  /// tabIndex에 해당하는 ListView를 생성하여 리턴함.
  /// 각각의 ListView 구현에 동일한 부분이 많아 메서드화하게 됨.
  Widget _buildPostList(int tabIndex, UserProvider userProvider) {
    // isLoadedList[tabIndex]는 true임이 보장됨.
    int itemCount = (tabIndex == 0
        ? createdArticleList.length
        : (tabIndex == 1
            ? scrappedArticleList.length
            : recentArticleList.length));
    return RefreshIndicator(
      color: ColorsInfo.newara,
      onRefresh: () async {
        setIsLoaded(false, tabIndex);
        UserProvider userProvider = context.read<UserProvider>();
        isLoadedList[tabIndex] =
            await selectFetchFunc(userProvider, tabIndex, 1);
        if (!isLoadedList[tabIndex]) return;
        curPage[tabIndex] = 1;
        setCurCount(tabIndex);
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount + 1,
        controller: scrollControllerList[tabIndex],
        itemBuilder: (context, index) {
          if (index == itemCount) {
            return Visibility(
              visible: isLoadingNewPage[tabIndex],
              child: const SizedBox(
                height: 40,
                child: Center(
                  child: LoadingIndicator(),
                ),
              ),
            );
          }
          late ArticleListActionModel curPost;
          late ScrapModel scrapInfo;
          if (tabIndex == 0) {
            curPost = createdArticleList[index];
          } else if (tabIndex == 1) {
            scrapInfo = scrappedArticleList[index];
            curPost = scrapInfo.parent_article;
          } else {
            curPost = recentArticleList[index];
          }
          return InkWell(
              onTap: () async {
                await Navigator.of(context)
                    .push(slideRoute(PostViewPage(id: curPost.id)));
                int newMaxPage = 0;
                for (int page = 1; page <= curPage[tabIndex]; page++) {
                  bool res =
                      await selectFetchFunc(userProvider, tabIndex, page);
                  if (!res) break;
                  newMaxPage = page;
                }
                curPage[tabIndex] = newMaxPage;
                setCurCount(tabIndex);
              },
              child: SizedBox(
                height: 61,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            curPost.title.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        curPost.attachment_type.toString() == "NONE"
                            ? Container()
                            : const SizedBox(width: 5),
                        curPost.attachment_type.toString() == "BOTH"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/image.svg',
                                    color: Colors.grey,
                                    width: 30,
                                    height: 25,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/clip.svg',
                                    color: Colors.grey,
                                    width: 15,
                                    height: 20,
                                  ),
                                ],
                              )
                            : curPost.attachment_type.toString() == "IMAGE"
                                ? SvgPicture.asset(
                                    'assets/icons/image.svg',
                                    color: Colors.grey,
                                    width: 30,
                                    height: 25,
                                  )
                                : curPost.attachment_type.toString() ==
                                        "NON_IMAGE"
                                    ? SvgPicture.asset(
                                        'assets/icons/clip.svg',
                                        color: Colors.grey,
                                        width: 15,
                                        height: 20,
                                      )
                                    : Container()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  curPost.created_by.profile.nickname
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(177, 177, 177, 1)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                getTime(tabIndex == 1
                                    ? scrapInfo.created_at.toString()
                                    : curPost.created_at.toString()),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(177, 177, 177, 1)),
                              ),
                              const SizedBox(width: 10),
                              Text('조회 ${curPost.hit_count}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(177, 177, 177, 1))),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/like.svg',
                              width: 20,
                              height: 20,
                              color: ColorsInfo.newara,
                            ),
                            const SizedBox(width: 3),
                            Text('${curPost.positive_vote_count}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsInfo.newara)),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/dislike.svg',
                              width: 20,
                              height: 20,
                              color: const Color.fromRGBO(83, 141, 209, 1),
                            ),
                            const SizedBox(width: 3),
                            Text('${curPost.negative_vote_count}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(83, 141, 209, 1))),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/comment.svg',
                              width: 20,
                              height: 20,
                              color: const Color.fromRGBO(99, 99, 99, 1),
                            ),
                            const SizedBox(width: 3),
                            Text('${curPost.comment_count}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(99, 99, 99, 1))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
