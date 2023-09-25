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
    const ChatListPage(),
    const NotificationPage(),
    const UserPage(),
  ];

  // 탭을 클릭할 때 실행될 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 현재 선택된 탭에 맞는 페이지 출력
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 하단의 네비게이션 바를 구성하는 함수.
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white, // 바탕색을 하얀색으로 설정 함.
      currentIndex: _selectedIndex, // 현재 선택된 탭의 인덱스를 나타냄.
      showSelectedLabels: false, // 선택된 탭의 라벨(텍스트)를 보이지 않게 함.
      showUnselectedLabels: false, // 선택되지 않은 탭의 라벨(텍스트)를 보이지 않게 함.
      type: BottomNavigationBarType.fixed, // 탭바의 타입을 고정된 것으로 설정 함.
      onTap: _onItemTapped, // 탭을 클릭하면 _onItemTapped 함수를 실행 함.
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            color: _selectedIndex == 0 ? Colors.black : Colors.grey,
            width: 36,
            height: 36,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/post_list.svg',
            color: _selectedIndex == 1 ? Colors.black : Colors.grey,
            width: 36,
            height: 36,
          ),
          label: 'Bulletin',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            color: _selectedIndex == 2 ? Colors.black : Colors.grey,
            width: 36,
            height: 36,
          ),
          label: 'Chatting',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              SvgPicture.asset(
                'assets/icons/notification.svg',
                color: _selectedIndex == 3 ? Colors.black : Colors.grey,
                width: 36,
                height: 36,
              ),
              Visibility(
                visible: context.watch<NotificationProvider>().isNotReadExist,
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
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/member.svg',
            color: _selectedIndex == 4 ? Colors.black : Colors.grey,
            width: 36,
            height: 36,
          ),
          label: 'MyPage',
        ),
      ],
    );
  }
}
