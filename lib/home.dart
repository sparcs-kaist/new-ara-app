import 'package:flutter/material.dart';

import 'package:new_ara_app/pages/main_page.dart';
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
    Scaffold(), // 아직 기능을 몰라서 디자이너분께 물어보고 바꾸기
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
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/icon_MainPage.png'),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/icon_2ndPage.png'),
          ),
          label: 'Unknown', // 디자이너분께 물어봐서 고치기
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/icon_ChatPage.png'),
          ),
          label: 'Chatting',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/icon_NotiPage.png'),
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/icon_UserPage.png'),
          ),
          label: 'User page',
        ),
      ],
    );
  }
}
