import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/main_page.dart';
import 'package:new_ara_app/pages/bulletin_list_page.dart';
import 'package:new_ara_app/pages/chat_list_page.dart';
import 'package:new_ara_app/pages/notification_page.dart';
import 'package:new_ara_app/pages/user_page.dart';

class NewAraHomePage extends StatefulWidget {
  const NewAraHomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NewAraHomePageState();
}

class _NewAraHomePageState extends State<NewAraHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MainPage(),
    const BulletinListPage(),
    const ChatListPage(),
    const NotificationPage(),
    const UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // void downloadUserInfo(initStateContext) async {
  //
  //   await Provider.of<UserProvider>(initStateContext, listen: false)
  //        .setCookiesFromUrl("https://newara.dev.sparcs.org/");
  //   await Provider.of<UserProvider>(initStateContext, listen: false)
  //       .apiMeUserInfo(message: "new-ara-home-page");
  // }

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
            'assets/icons/home-1.svg',
            color: _selectedIndex == 0 ? Colors.black : Colors.grey,
            width: 36,
            height: 36,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/list-ul.svg',
            color: _selectedIndex == 1 ? Colors.black : Colors.grey,
            width: 23,
            height: 20,
          ),
          label: 'Bulletin',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            color: _selectedIndex == 2 ? Colors.black : Colors.grey,
            width: 25,
            height: 23.33,
          ),
          label: 'Chatting',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/bell.svg',
            color: _selectedIndex == 3 ? Colors.black : Colors.grey,
            width: 21.88,
            height: 25,
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
