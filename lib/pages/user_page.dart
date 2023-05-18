import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/setting_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/models/article_info_model.dart';
import 'package:new_ara_app/pages/post_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<List<ArticleInfo>> tabList = [[], [], []];
  List<int> tabCount = [0, 0, 0];
  int curCount = 0;
  List<bool> isLoadedList = [false, false, false];

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
    fetchArticleList(context, 0);
    fetchArticleList(context, 1);
    fetchArticleList(context, 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    int curIndex = 0;

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
                            child: Image.network(
                                fit: BoxFit.cover,
                                userProvider.naUser!.picture),
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
                                "${context.watch<UserProvider>().naUser!.sso_user_info['first_name']} ${context.watch<UserProvider>().naUser!.sso_user_info['last_name']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                context.watch<UserProvider>().naUser!.email,
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
                  onTap: (index) {
                    setState(() => curCount = tabCount[index]);
                    //debugPrint('curIndex: $curIndex');
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
                          : ListView.separated(
                              itemCount: tabList[0].length,
                              itemBuilder: (context, index) {
                                var curPost = tabList[0][index];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostPage()));
                                    },
                                    child: SizedBox(
                                      height: 61,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              curPost.title == null
                                                  ? "null"
                                                  : curPost.title!.substring(
                                                      0,
                                                      min(
                                                          20,
                                                          curPost
                                                              .title!.length)),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      curPost.created_by == null
                                                          ? 'null'
                                                          : curPost.created_by![
                                                                  'profile']
                                                              ['nickname'],
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              177,
                                                              177,
                                                              177,
                                                              1))),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                      '조회 ${curPost.hit_count}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              177,
                                                              177,
                                                              177,
                                                              1))),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/thumbs-up.svg',
                                                    width: 13,
                                                    height: 15,
                                                    color: ColorsInfo.newara,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${curPost.positive_vote_count}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ColorsInfo
                                                              .newara)),
                                                  const SizedBox(width: 10),
                                                  SvgPicture.asset(
                                                    'assets/icons/thumbs-down.svg',
                                                    width: 13,
                                                    height: 15,
                                                    color: const Color.fromRGBO(
                                                        83, 141, 209, 1),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${curPost.negative_vote_count}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              83,
                                                              141,
                                                              209,
                                                              1))),
                                                  const SizedBox(width: 10),
                                                  SvgPicture.asset(
                                                    'assets/icons/comment.svg',
                                                    width: 13,
                                                    height: 15,
                                                    color: const Color.fromRGBO(
                                                        99, 99, 99, 1),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${curPost.comment_count}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              99, 99, 99, 1))),
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
                      !isLoadedList[1]
                          ? const LoadingIndicator()
                          : ListView.separated(
                              itemCount: tabList[1].length,
                              itemBuilder: (context, index) {
                                var curPost = tabList[1][index].parent_article;
                                return SizedBox(
                                  height: 61,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          curPost['title'] == null
                                              ? 'null'
                                              : curPost['title']!.substring(
                                                  0,
                                                  min(
                                                      20,
                                                      curPost['title']!
                                                          .toString()
                                                          .length)),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  curPost['created_by'] == null
                                                      ? 'null'
                                                      : curPost['created_by']
                                                              ['profile']
                                                          ['nickname'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          177, 177, 177, 1))),
                                              const SizedBox(width: 10),
                                              Text('조회 ${curPost['hit_count']}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          177, 177, 177, 1))),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/thumbs-up.svg',
                                                width: 13,
                                                height: 15,
                                                color: ColorsInfo.newara,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  '${curPost['positive_vote_count']}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorsInfo.newara)),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/icons/thumbs-down.svg',
                                                width: 13,
                                                height: 15,
                                                color: const Color.fromRGBO(
                                                    83, 141, 209, 1),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  '${curPost['negative_vote_count']}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          83, 141, 209, 1))),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/icons/comment.svg',
                                                width: 13,
                                                height: 15,
                                                color: const Color.fromRGBO(
                                                    99, 99, 99, 1),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  '${curPost['comment_count']}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          99, 99, 99, 1))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                            ),
                      !isLoadedList[2]
                          ? const LoadingIndicator()
                          : ListView.separated(
                              itemCount: tabList[2].length,
                              itemBuilder: (context, index) {
                                var curPost = tabList[2][index];
                                return SizedBox(
                                  height: 61,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          curPost.title == null
                                              ? "null"
                                              : curPost.title!.substring(
                                                  0,
                                                  min(20,
                                                      curPost.title!.length)),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  curPost.created_by == null
                                                      ? 'null'
                                                      : curPost.created_by![
                                                              'profile']
                                                          ['nickname'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          177, 177, 177, 1))),
                                              const SizedBox(width: 10),
                                              Text('조회 ${curPost.hit_count}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          177, 177, 177, 1))),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/thumbs-up.svg',
                                                width: 13,
                                                height: 15,
                                                color: ColorsInfo.newara,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  '${curPost.positive_vote_count}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorsInfo.newara)),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/icons/thumbs-down.svg',
                                                width: 13,
                                                height: 15,
                                                color: const Color.fromRGBO(
                                                    83, 141, 209, 1),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  '${curPost.negative_vote_count}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          83, 141, 209, 1))),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/icons/comment.svg',
                                                width: 13,
                                                height: 15,
                                                color: const Color.fromRGBO(
                                                    99, 99, 99, 1),
                                              ),
                                              const SizedBox(width: 3),
                                              Text('${curPost.comment_count}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          99, 99, 99, 1))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
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

  void fetchArticleList(BuildContext initStateContext, int tabIndex) async {
    int user = initStateContext.read<UserProvider>().naUser!.user;
    List<String> apiUrlList = [
      '/api/articles/?page=1&created_by=$user',
      '/api/scraps/?page=1&created_by=$user',
      '/api/articles/recent/?page=1'
    ];

    tabList[tabIndex] = [];
    var dio = Dio();
    dio.options.headers['Cookie'] =
        initStateContext.read<UserProvider>().getCookiesToString();
    try {
      var response =
          await dio.get('https://newara.dev.sparcs.org${apiUrlList[tabIndex]}');
      setMyCount(response.data['num_items'], tabIndex);
      if (response.statusCode == 200) {
        debugPrint("fetchArticleList() $tabIndex succeed!");
        List<dynamic> rawPostList = response.data['results'];
        for (int i = 0; i < rawPostList.length; i++) {
          Map<String, dynamic> rawPost = rawPostList[i];
          tabList[tabIndex].add(ArticleInfo.fromJson(rawPost));
        }
        setIsLoaded(true, tabIndex);
        debugPrint('$tabIndex count: ${tabCount[tabIndex]}');
      }
    } catch (error) {
      debugPrint("fetchArticleList() $tabIndex failed with error: $error");
    }
  }

  void setIsLoaded(bool value, int tabIndex) =>
      setState(() => isLoadedList[tabIndex] = value);

  void setMyCount(int value, int tabIndex) {
    setState(() => tabCount[tabIndex] = value);
    setState(() => curCount = tabCount[0]);
  }
}

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
