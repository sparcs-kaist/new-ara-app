/// 사용자 본인 정보 표시 페이지를 관리하는 파일
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/setting_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/models/scrap_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/time_utils.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/pages/profile_edit_page.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/utils/profile_image.dart';
import 'package:new_ara_app/utils/handle_hidden.dart';
import 'package:new_ara_app/widgets/post_preview.dart';

/// 작성한 글, 담아둔 글, 최근 본 글을 나타내기 위해 사용
enum TabType { created, scrap, recent }

/// 사용자 본인 정보 페이지의 빌드 및 이벤트 처리를 담당하는 위젯
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

  /// 작성한 글, 담아둔 글, 최근 본 글 ListView에 각각이
  /// 다음 페이지를 불러오고 있는지 여부를 나타냄.
  /// 스크롤이 최하단까지 갈 경우 리스너에 의해 다음 페이지가 호출되고
  /// 이 과정 동안 true가 됨.
  List<bool> isLoadingNextPage = [false, false, false];

  /// 작성한 글 ListView에 들어가는 모델 리스트
  List<ArticleListActionModel> createdArticleList = [];

  /// 담아둔 글 ListView에 들어가는 모델 리스트
  List<ScrapModel> scrappedArticleList = [];

  /// 최근 본 글 ListView에 들어가는 모델 리스트
  List<ArticleListActionModel> recentArticleList = [];

  /// 작성한 글, 담아둔 글, 최근 본 글 각각의 총 개수를 나타냄.
  List<int> articleCount = [0, 0, 0];

  /// 작성한 글, 담아둔 글, 최근 본 글 중
  /// 현재 사용자가 위치한 탭의 articleCount를 나타냄.
  int curCount = 0;

  /// 작성한 글, 담아둔 글, 최근 본 글 각각에 대해
  /// article list 로드가 완료되었는지 여부.
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

    UserProvider userProvider = context.read<UserProvider>();

    // 페이지 로드 시에 새로운 알림 여부를 조회함.
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);

    // 초기 데이터를 로드함.
    fetchInitData(userProvider);
  }

  /// 사용자의 정보, 사용자가 작성한 글을 로드함.
  /// initState에서만 사용되고 있음.
  /// API 통신을 위해 userProvider를 전달받으며
  /// 별도의 리턴값 없이 작업 완료 후 state를 바로 업데이트함.
  Future<void> fetchInitData(UserProvider userProvider) async {
    userProvider.apiMeUserInfo().then(
      (userFetchRes) {
        if (!userFetchRes) {
          debugPrint("Fail: 최신 유저정보 조회");
        } else {
          debugPrint("Success: 최신 유저정보 조회");
          setState(() {});
        }
      },
    ); // 유저 정보 조회

    TabType tabType = TabType.created;
    // 작성한 글 조회하기
    isLoadedList[tabType.index] =
        await fetchArticles(userProvider, 1, TabType.created);
    setCurCount(tabType); // state 업데이트
  }

  /// 작성한 글, 담아둔 글, 최근 본 글 각각의 ListView에 대한
  /// 리스너의 공통된 로직을 함수화한 것
  /// pageT를 통해 작성한 글, 담아둔 글, 최근 본 글 인지 식별하고
  /// 스크롤이 최하단까지 간 경우 다음 페이지를 호출함.
  /// 별도의 리턴값없이 state를 업데이트함.
  Future<void> listener(TabType tabType) async {
    // 이미 다음 페이지를 로딩하는 경우를 제외
    if (!isLoadingNextPage[tabType.index]) {
      // 사용자가 최대로 스크롤 한 경우
      // TODO: 마지막 페이지에 도달했을 때 스크롤 안되게 하기
      if (isLoadedList[tabType.index] &&
          scrollControllerList[tabType.index].position.pixels >=
              scrollControllerList[tabType.index].position.maxScrollExtent) {
        setIsLoadingNewPage(tabType, true);
        bool fetchRes = await fetchArticles(
            context.read<UserProvider>(), curPage[tabType.index] + 1, tabType);
        if (fetchRes) curPage[tabType.index] += 1;
        setIsLoadingNewPage(tabType, false);
      }
    }
  }

  /// 작성한 글 ListView의 listener
  Future<void> _scrollListener0() async {
    await listener(TabType.created);
  }

  /// 담아둔 글 ListView의 listener
  Future<void> _scrollListener1() async {
    await listener(TabType.scrap);
  }

  /// 최근 본 글 ListView의 listener
  Future<void> _scrollListener2() async {
    await listener(TabType.recent);
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
              _buildUserInfo(userProvider),
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
              // 총 N개의 글
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
              // 탭 별 articleList를 표시
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      !isLoadedList[TabType.created.index]
                          ? const LoadingIndicator()
                          : _buildPostList(TabType.created, userProvider),
                      !isLoadedList[TabType.scrap.index]
                          ? const LoadingIndicator()
                          : _buildPostList(TabType.scrap, userProvider),
                      !isLoadedList[TabType.recent.index]
                          ? const LoadingIndicator()
                          : _buildPostList(TabType.recent, userProvider),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// UserPage에서 TabBar의 상단 부분인 유저 정보 위젯을 빌드.
  Widget _buildUserInfo(UserProvider userProvider) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      child: Row(
        children: [
          // 사용자 프로필 표시
          // 사용자 프로필 링크가 null일 경우 warning 아이콘 표시
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(25),
                // 이미지 링크를 확인한 후 null인 이미지는 warning.svg를 빌드
                child: buildProfileImage(userProvider.naUser!.picture, 45, 45),
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
                    userProvider.naUser == null ||
                            userProvider.naUser?.email == null
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
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await Navigator.of(context).push(
                  slideRoute(
                    const ProfileEditPage(),
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
    );
  }

  /// tabIndex에 해당하는 ListView를 생성하여 리턴함.
  /// 각각의 ListView 구현에 동일한 부분이 많아 메서드화하게 됨.
  Widget _buildPostList(TabType tabType, UserProvider userProvider) {
    // build 대상 tab의 article 개수 조회
    int itemCount = getItemCount(tabType);
    return RefreshIndicator.adaptive(
      color: ColorsInfo.newara,
      onRefresh: () async {
        setIsLoaded(false, tabType);
        UserProvider userProvider = context.read<UserProvider>();
        isLoadedList[tabType.index] =
            await fetchArticles(userProvider, 1, tabType);
        // 페이지 로드가 성공한 경우
        // 성공하지 못하면 계속 로딩 페이지
        if (isLoadedList[tabType.index]) {
          curPage[tabType.index] = 1;
          setCurCount(tabType);
        }
      },
      child: ListView.separated(
        // item의 개수가 화면을 넘어가지 않더라도 scrollable 취급
        // 새로고침 기능을 위해 필요한 physics
        physics: const AlwaysScrollableScrollPhysics(),
        // 다음 페이지 호출시에 사용되는 LoadingIndicator로 인해 1 추가
        itemCount: itemCount + 1,
        controller: scrollControllerList[tabType.index],
        itemBuilder: (context, index) {
          // 다음페이지를 호출하는 경우
          if (index == itemCount) {
            return Visibility(
              visible: isLoadingNextPage[tabType.index],
              child: const SizedBox(
                height: 40,
                child: Center(
                  child: LoadingIndicator(),
                ),
              ),
            );
          }
          late ArticleListActionModel curPost;
          ScrapModel? scrapInfo;
          switch (tabType) {
            case TabType.created:
              curPost = createdArticleList[index];
              break;
            case TabType.scrap:
              scrapInfo = scrappedArticleList[index];
              curPost = scrapInfo.parent_article;
              break;
            case TabType.recent:
              curPost = recentArticleList[index];
          }
          return InkWell(
              onTap: () async {
                // 사용자가 글을 보고난 이후 article list를 다시 조회.
                await Navigator.of(context)
                    .push(slideRoute(PostViewPage(id: curPost.id)));
                int newMaxPage = 0;
                for (int page = 1; page <= curPage[tabType.index]; page++) {
                  bool res = await fetchArticles(userProvider, page, tabType);
                  if (!res) break;
                  newMaxPage = page;
                } 
                curPage[tabType.index] = newMaxPage;
                setCurCount(tabType);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: PostPreview(model: curPost)));
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          );
        },
      ),
    );
  }

  /// 유저가 탭 전환을 하였을 때 전환된 탭의 새로고침을 위해 사용됨.
  /// API 통신을 위해 userProvider, 전환된 탭을 나타내는 newTabIndex를 전달받음.
  /// 별도의 리턴값없이 전환되는 탭의 새로고침 완료 후 state를 변경함.
  /// 실패하는 경우 로딩 상태로 남게됨.
  Future<void> fetchNewTab(UserProvider userProvider, TabType tabType) async {
    setIsLoaded(false, TabType.created);
    setIsLoaded(false, TabType.scrap);
    setIsLoaded(false, TabType.recent);
    bool res = await fetchArticles(userProvider, 1, tabType);
    if (!res) return;
    curPage[tabType.index] = 1;
    setCurCount(tabType);
    setIsLoaded(true, tabType);
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
        fetchNewTab(userProvider, TabType.values[newTabIndex]);
      }
    } else {
      // Tap
      fetchNewTab(userProvider, TabType.values[newTabIndex]);
    }
  }

  /// tabType의 값에 따라 그에 맞는 api url을 리턴하는 함수.
  /// fetchArticles 함수에서 사용.
  String getApiUrl(TabType tabType, int page, int user) {
    switch (tabType) {
      case TabType.created:
        return "/api/articles/?page=$page&created_by=$user";
      case TabType.scrap:
        return "/api/scraps/?page=$page&created_by=$user";
      case TabType.recent:
        return "/api/articles/recent/?page=$page";
    }
  }

  /// json을 Model로 전환하고 pageT의 값에 따라
  /// 그에 맞는 list에 모델을 추가함.
  /// json -> model, list에 추가 작업이 모두 성공하면 true,
  /// 아니면 false 반환
  bool addList(TabType tabType, Map<String, dynamic> json) {
    try {
      switch (tabType) {
        case (TabType.created):
          ArticleListActionModel model = ArticleListActionModel.fromJson(json);
          createdArticleList.add(model);
          break;
        case (TabType.scrap):
          ScrapModel model = ScrapModel.fromJson(json);
          scrappedArticleList.add(model);
          break;
        case (TabType.recent):
          ArticleListActionModel model = ArticleListActionModel.fromJson(json);
          recentArticleList.add(model);
      }
    } catch (error) {
      debugPrint("fromJson error: $error");
      return false;
    }
    return true;
  }

  /// tabType에 해당하는 페이지의 articleList를 초기화함.
  void clearList(TabType tabType) {
    switch (tabType) {
      case TabType.created:
        createdArticleList.clear();
        break;
      case TabType.scrap:
        scrappedArticleList.clear();
        break;
      case TabType.recent:
        recentArticleList.clear();
        break;
    }
  }

  /// 주어진 page, pageT에 맞는 article을 불러오는 함수.
  /// article fetching 후 각각을 model로 변환하여
  /// pageT에 해당하는 리스트에 추가함.
  /// 위 모든 과정이 성공하면 true, 아니면 false를 반환함.
  Future<bool> fetchArticles(
      UserProvider userProvider, int page, TabType tabType) async {
    int user = userProvider.naUser!.user;
    // pageT에 맞는 apiUrl 설정
    String apiUrl = getApiUrl(tabType, page, user);

    // 첫 페이지를 불러오는 경우 기존 리스트를 초기화
    if (page == 1) clearList(tabType);

    try {
      var response = await userProvider
          .createDioWithHeadersForGet()
          .get('$newAraDefaultUrl$apiUrl');

      List<dynamic> rawPostList = response.data['results'];
      for (int i = 0; i < rawPostList.length; i++) {
        Map<String, dynamic>? rawPost = rawPostList[i];
        if (rawPost != null) {
          bool addRes = addList(tabType, rawPost);
          // articleList에 추가하지 못한 글의 경우
          // 별도의 exception 없이 debugPrint한 후에 넘어감.
          if (!addRes) {
            debugPrint("addList failed at index $i: (id: ${rawPost['id']})");
          }
        }
      }
      // pageT에 해당하는 페이지의 글 개수를 업데이트함.
      articleCount[tabType.index] = response.data['num_items'];
      debugPrint("fetchArticles() succeeded for page: $page");
      return true;
    } on DioException catch (e) {
      // Handle the DioError separately to handle only Dio related errors
      if (e.response != null) {
        // DioError contains response data
        debugPrint('Dio error!');
        debugPrint('STATUS: ${e.response?.statusCode}');
        debugPrint('DATA: ${e.response?.data}');
        debugPrint('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending/receiving the request
        debugPrint('Error sending request!');
        debugPrint(e.message);
      }
    } catch (error) {
      debugPrint("fetchArticles() failed with error: $error");
    }
    return false;
  }

  /// 탭별 컨텐츠 로드 완료 여부를 설정하고 state를 업데이트하는 메서드.
  /// ListView refresh, 탭 전환 시에 사용됨.
  void setIsLoaded(bool value, TabType tabType) =>
      setState(() => isLoadedList[tabType.index] = value);

  /// isLoadingNextPage를 갱신하는 함수.
  void setIsLoadingNewPage(TabType tabType, bool value) {
    if (mounted) setState(() => isLoadingNextPage[tabType.index] = value);
  }

  /// "총 $curCount개의 글" 문구에 표시되는 curCount 변수를 설정하고
  /// State를 업데이트하는 메서드. 탭이 전환될 때마다 사용됨.
  void setCurCount(TabType tabType) {
    if (mounted) setState(() => curCount = articleCount[tabType.index]);
  }

  /// pageT에 해당하는 탭의 article 개수를 리턴함.
  /// _buildPostList에서 itemCount 변수 설정을 위해 사용.
  int getItemCount(TabType tabType) {
    switch (tabType) {
      case TabType.created:
        return createdArticleList.length;
      case TabType.scrap:
        return scrappedArticleList.length;
      case TabType.recent:
        return recentArticleList.length;
    }
  }
}
