import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/pages/main_page.dart';
import 'package:new_ara_app/pages/bulletin_page.dart';
import 'package:new_ara_app/pages/chat_page.dart';
import 'package:new_ara_app/pages/notification_page.dart';
import 'package:new_ara_app/pages/user_page.dart';

class NewAraHome extends StatefulWidget {
  const NewAraHome({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NewAraHomeState();
}

class _NewAraHomeState extends State<NewAraHome> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    BulletinPage(),
    ChatPage(),
    NotificationPage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/icon_MainPage.svg',
            color: _selectedIndex == 0 ? Colors.black : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/icon_bulletinPage.svg',
            color: _selectedIndex == 1 ? Colors.black : Colors.grey,
          ),
          label: 'Bulletin',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/icon_ChatPage.svg',
            color: _selectedIndex == 2 ? Colors.black : Colors.grey,
          ),
          label: 'Chatting',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/icon_NotiPage.svg',
            color: _selectedIndex == 3 ? Colors.black : Colors.grey,
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/icon_UserPage.svg',
            color: _selectedIndex == 4 ? Colors.black : Colors.grey,
          ),
          label: 'MyPage',
        ),
      ],
    );
  }
}
