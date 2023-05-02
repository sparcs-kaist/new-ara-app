import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/setting_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/user_tab.dart';

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
          context.watch<UserProvider>().naUser!.nickname,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                shape: BoxShape.circle),
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
                Navigator.of(context).push(_createRoute());
              },
            ),
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
                                context.watch<UserProvider>().naUser!.picture),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 250,
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
                  unselectedLabelColor: Color.fromRGBO(177, 177, 177, 1),
                  labelColor: ColorsInfo.newara,
                  indicatorColor: ColorsInfo.newara,
                  tabs: const [
                    UserTab('myPage.mypost'),
                    UserTab('myPage.scrap'),
                    UserTab('myPage.recent'),
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 24,
                  child: Text(
                    '총 ${context.watch<UserProvider>().naUser!.num_articles}개의 글',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(177, 177, 177, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(child: Center(child: Text('없음'))),
                      Container(child: Center(child: Text('없음'))),
                      Container(child: Center(child: Text('없음'))),
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
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SettingPage(),
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
