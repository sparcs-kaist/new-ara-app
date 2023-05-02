import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';

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
        elevation: 0,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MainPageTextButton('main_page.realtime'),
                // 실시간 인기글을 ListView로 도입 예정
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const SizedBox(height: 10),
                const MainPageTextButton('main_page.notice'),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const SizedBox(height: 10),
                const MainPageTextButton('main_page.stu_community'),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    children: [
                      Container(
                        height: 28,
                        child: Row(
                          children: [
                            Text(
                              '원총',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 28,
                        child: Row(
                          children: [
                            Text(
                              '총학',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 28,
                        child: Row(
                          children: [
                            Text(
                              '새학',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color.fromRGBO(177, 177, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPageTextButton extends StatelessWidget {
  final String buttonTitle;
  const MainPageTextButton(this.buttonTitle);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              '${this.buttonTitle}'.tr() + ' >',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
