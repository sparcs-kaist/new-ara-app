import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined,
                color: NEWARA_COLOR, size: 28),
            onPressed: () {}, // 추후에 검색 기능 추가 필요
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSizedBox(1.9),
                // 광고
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 204,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: NEWARA_COLOR_SOFT,
                  ),
                  child: const Center(
                    child: Text(
                      '뉴아라 앱이 출시되었습니다 :)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ), // Sample text
                  ),
                ),
                _buildSizedBox(3),
                // 실시간 인기글 TextButton
                _buildTextButton("main_page.realtime", true),
                // 실시간 인기글 ListView
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                // 공지 TextButton
                _buildTextButton("main_page.notice", false),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 223,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                _buildSizedBox(5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTextButton(String name, bool isArrow) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 50,
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(isArrow ? ('$name'.tr() + ' >') : ('$name'.tr()),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }
}
