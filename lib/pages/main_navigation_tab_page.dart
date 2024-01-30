import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/pages/main_page.dart';
import 'package:new_ara_app/pages/bulletin_list_page.dart';
import 'package:new_ara_app/pages/chat_list_page.dart';
import 'package:new_ara_app/pages/notification_page.dart';
import 'package:new_ara_app/pages/user_page.dart';
import 'package:new_ara_app/providers/notification_provider.dart';
import 'package:new_ara_app/constants/colors_info.dart';

/// MainNavigationTabPage
/// 메인 화면 하단에 위치하는 탭바를 포함한 메인 페이지.
class MainNavigationTabPage extends StatefulWidget {
  const MainNavigationTabPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainNavigationTabPageState();
}

class _MainNavigationTabPageState extends State<MainNavigationTabPage> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스

  // 탭별로 연결될 페이지 목록
  final List<Widget> _widgetOptions = <Widget>[
    const MainPage(),
    const BulletinListPage(),
    //const ChatListPage(),
    const NotificationPage(),
    const UserPage(),
  ];

  // 탭을 클릭할 때 실행될 함수

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 현재 선택된 탭에 맞는 페이지 출력
        child: Column(
          children: [
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  /// 하단의 네비게이션 바를 구성하는 함수.
  Widget _buildBottomNavigationBar() {
    double gapHalfWidth= (MediaQuery.of(context).size.width-36*4)/10;
    double iconWidth = gapHalfWidth*2+36;
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: gapHalfWidth,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (() => _onItemTapped(0)),
            child: SizedBox(
              width: iconWidth,
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(
                    'assets/icons/home.svg',
                    colorFilter: ColorFilter.mode(
                        _selectedIndex == 0 ? Colors.black : Colors.grey,
                        BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (() => _onItemTapped(1)),
            child: SizedBox(
              width: iconWidth,
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(
                    'assets/icons/post_list.svg',
                    colorFilter: ColorFilter.mode(
                        _selectedIndex == 1 ? Colors.black : Colors.grey,
                        BlendMode.srcIn),
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (() => _onItemTapped(2)),
            child: SizedBox(
              width: iconWidth,
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notification.svg',
                        colorFilter: ColorFilter.mode(
                            _selectedIndex == 2 ? Colors.black : Colors.grey,
                            BlendMode.srcIn),
                      ),
                      Visibility(
                        visible: context
                            .watch<NotificationProvider>()
                            .isNotReadExist,
                        child: Positioned(
                          top: 0,
                          right: 5,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorsInfo.newara,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _onItemTapped(3),
            child: SizedBox(
              width: iconWidth,
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(
                    'assets/icons/member.svg',
                    colorFilter: ColorFilter.mode(
                        _selectedIndex == 3 ? Colors.black : Colors.grey,
                        BlendMode.srcIn),
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: gapHalfWidth,
          ),
        ],
      ),
    );
  }
}
