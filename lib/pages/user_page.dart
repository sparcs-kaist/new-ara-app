import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/setting_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/models/scrap_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';

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

  List<ArticleListActionModel> createdArticleList = [];
  List<ScrapModel> scrappedArticleList = [];
  List<ArticleListActionModel> recentArticleList = [];

  // List 의 경우
  // 0: 작성한 글, 1: 담아둔 글, 2: 최근 본 글
  List<int> tabCount = [0, 0, 0];
  int curCount = 0; // "총 N개의 글"에 사용되는 변수
  List<bool> isLoadedList = [false, false, false];
  List<int> nextPage = [2, 2, 2];

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

    scrollControllerList[0].addListener(_scrollListener0);
    scrollControllerList[1].addListener(_scrollListener1);
    scrollControllerList[2].addListener(_scrollListener2);

    fetchCreatedArticles(context, 1);
    fetchScrappedArticles(context, 1);
    fetchRecentArticles(context, 1);
  }

  void _scrollListener0() {
    if (isLoadedList[0] &&
        scrollControllerList[0].position.pixels ==
            scrollControllerList[0].position.maxScrollExtent) {
      fetchCreatedArticles(context, nextPage[0]);
    }
  }

  void _scrollListener1() {
    if (isLoadedList[1] &&
        scrollControllerList[1].position.pixels ==
            scrollControllerList[1].position.maxScrollExtent) {
      fetchScrappedArticles(context, nextPage[1]);
    }
  }

  void _scrollListener2() {
    if (isLoadedList[2] &&
        scrollControllerList[2].position.pixels ==
            scrollControllerList[2].position.maxScrollExtent) {
      fetchRecentArticles(context, nextPage[2]);
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
          userProvider.hasData == true ? userProvider.naUser!.nickname : "",
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
              'assets/icons/icon-setting.svg',
              color: ColorsInfo.newara,
              width: 25,
              height: 25,
            ),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
          const SizedBox(width: 11),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          onTap: () {}, // 추후에 프로필 수정 기능 구현 예정
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
                TabBar(
                  unselectedLabelColor: const Color.fromRGBO(177, 177, 177, 1),
                  labelColor: ColorsInfo.newara,
                  indicatorColor: ColorsInfo.newara,
                  tabs: _tabs.map((String tab) {
                    return Tab(text: tab);
                  }).toList(),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) async {
                    setState(() => curCount = tabCount[index]);
                  },
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
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      !isLoadedList[0]
                          ? const LoadingIndicator()
                          : _buildPostList(0),
                      !isLoadedList[1]
                          ? const LoadingIndicator()
                          : _buildPostList(1),
                      !isLoadedList[2]
                          ? const LoadingIndicator()
                          : _buildPostList(2),
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

  Future<void> fetchCreatedArticles(
      BuildContext initStateContext, int page) async {
    int user = initStateContext.read<UserProvider>().naUser!.user;
    String apiUrl = "/api/articles/?page=$page&created_by=$user";
    if (page == 1) createdArticleList = [];
    Dio dio = Dio();
    try {
      dio.options.headers['Cookie'] =
          initStateContext.read<UserProvider>().getCookiesToString();
    } catch (error) {
      debugPrint(
          "fetchCreatedArticles() failed to get Cookies from Provider: $error");
    }
    try {
      var response = await dio.get('$newAraDefaultUrl$apiUrl');
      debugPrint(
          "fetchCreatedArticles() GET request (page: $page): ${response.statusCode}");
      if (response.statusCode == 200) {
        setMyCount(response.data['num_items'], 0); // "총 N개의 글" 설정
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
        nextPage[0] += 1;
        setIsLoaded(true, 0);
      }
    } catch (error) {
      debugPrint("fetchCreatedArticles() failed with error: $error");
    }
  }

  Future<void> fetchScrappedArticles(
      BuildContext initStateContext, int page) async {
    int user = initStateContext.read<UserProvider>().naUser!.user;
    String apiUrl = "/api/scraps/?page=$page&created_by=$user";
    if (page == 1) scrappedArticleList = [];
    Dio dio = Dio();
    try {
      dio.options.headers['Cookie'] =
          initStateContext.read<UserProvider>().getCookiesToString();
    } catch (error) {
      debugPrint(
          "fetchScrappedArticles() failed to get Cookies from Provider: $error");
    }
    try {
      var response = await dio.get('$newAraDefaultUrl$apiUrl');
      debugPrint(
          "fetchScrappedArticles() GET request (page: $page): ${response.statusCode}");
      setMyCount(response.data['num_items'], 1);
      if (response.statusCode == 200) {
        debugPrint("fetchScrappedArticles() succeed!");
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
        nextPage[1] += 1;
        setIsLoaded(true, 1);
      }
    } catch (error) {
      debugPrint("fetchScrappedArticles() failed with error: $error");
    }
  }

  Future<void> fetchRecentArticles(
      BuildContext initStateContext, int page) async {
    String apiUrl = "/api/articles/recent/?page=$page";
    if (page == 1) recentArticleList = [];
    Dio dio = Dio();
    try {
      dio.options.headers['Cookie'] =
          initStateContext.read<UserProvider>().getCookiesToString();
    } catch (error) {
      debugPrint(
          "fetchRecentArticles() failed to get Cookies from Provider: $error");
    }
    try {
      var response = await dio.get('$newAraDefaultUrl$apiUrl');
      debugPrint(
          "fetchRecentArticles() GET request (page: $page): ${response.statusCode}");
      setMyCount(response.data['num_items'], 2);
      if (response.statusCode == 200) {
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
        nextPage[2] += 1;
        setIsLoaded(true, 2);
      }
    } catch (error) {
      debugPrint("fetchRecentArticles() failed with error: $error");
    }
  }

  void setIsLoaded(bool value, int tabIndex) =>
      setState(() => isLoadedList[tabIndex] = value);

  void setMyCount(int value, int tabIndex) {
    setState(() => tabCount[tabIndex] = value);
    setState(() => curCount = tabCount[0]);
  }

  String getCreatedTime(String createdAt) {
    DateTime now = DateTime.now();

    DateTime date = DateTime.parse(createdAt).toLocal();
    var difference = now.difference(date);
    String time = "미정";
    if (difference.inMinutes < 1) {
      time = "${difference.inSeconds}초 전";
    } else if (difference.inHours < 1) {
      time = '${difference.inMinutes}분 전';
    } else if (date.day == now.day) {
      time =
          '${DateFormat('HH').format(date)}:${DateFormat('mm').format(date)}';
    } else if (date.year == now.year) {
      time =
          '${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
    } else {
      time =
          '${DateFormat('yyyy').format(date)}/${DateFormat('MM').format(date)}/${DateFormat('dd').format(date)}';
    }

    return time;
  }

  Widget _buildPostList(int tabIndex) {
    return ListView.separated(
      itemCount: !isLoadedList[tabIndex]
          ? 0
          : (tabIndex == 0
              ? createdArticleList.length
              : (tabIndex == 1
                  ? scrappedArticleList.length
                  : recentArticleList.length)),
      controller: scrollControllerList[tabIndex],
      itemBuilder: (context, index) {
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
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostPage())); // 나중에 수정되어야 함.
            },
            child: SizedBox(
              height: 61,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    curPost.title.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
                                curPost.created_by.profile.nickname.toString(),
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
                              getCreatedTime(tabIndex == 1
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
                            width: 13,
                            height: 15,
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
                            width: 13,
                            height: 15,
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
                            width: 13,
                            height: 15,
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
    );
  }
}

// 설정 페이지가 슬라이드로 나오기 위해서 필요한 Route
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SettingPage(),
    transitionsBuilder: ((context, animation, secondaryAnimation, child) {
      var begin = const Offset(1, 0);
      var end = const Offset(0, 0);
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    }),
  );
}
