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
    var userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userProvider.hasData==true?userProvider.naUser!.nickname:"",
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
                    '총 ${userProvider.naUser!.num_articles}개의 글',
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
                    children: const [
                      // 이 부분은 추후에 각각의 컨테이너에 ListView를 추가하여 구현할 예정
                      // 현 시점(2023.05.04)에는 게시물을 요청받았을 때 요청 형식을 알 수 없으므로 보류함
                      Center(child: Text('없음')),
                      Center(child: Text('없음')),
                      Center(child: Text('없음')),
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
    pageBuilder: (context, animation, secondaryAnimation) => const SettingPage(),
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
