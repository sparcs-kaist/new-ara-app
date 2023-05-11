import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/main_page.dart';
import 'package:new_ara_app/pages/bulletin_page.dart';
import 'package:new_ara_app/pages/chat_list_page.dart';
import 'package:new_ara_app/pages/notification_page.dart';
import 'package:new_ara_app/pages/user_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NewAraHomePage extends StatefulWidget {
  const NewAraHomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NewAraHomePageState();
}

class _NewAraHomePageState extends State<NewAraHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const MainPage(),
    const BulletinPage(),
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

    //api/me 해서 유저 정보를 모델에 저장하기.
    downloadUserInfo();
  }
  void downloadUserInfo() async{
    var userProvider = context.watch<UserProvider>();
    await userProvider.getCookies("https://newara.dev.sparcs.org/");
    await userProvider.apiMeUserInfo();
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
            'assets/icons/house-door-fill.svg',
            color: _selectedIndex == 0 ? Colors.black : Colors.grey,
            width: 20.31,
            height: 21.88,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/list-ul.svg',
            color: _selectedIndex == 1 ? Colors.black : Colors.grey,
            width: 25,
            height: 17.86,
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
            'assets/icons/person-circle.svg',
            color: _selectedIndex == 4 ? Colors.black : Colors.grey,
            width: 25,
            height: 25,
          ),
          label: 'MyPage',
        ),
      ],
    );
  }
}
