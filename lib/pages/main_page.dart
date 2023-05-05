import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String textContent="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider=Provider.of<UserProvider>(context,listen:false);
    initDailyBest(userProvider);
  }
  void initDailyBest(UserProvider userProvider) async{

    //example
    //프로바이더에 있는 정보 사용.
    var myMap = userProvider.getApiRes("home");
    setState(() {

    });

    // api 호출과 프로바이더 정보 동기화.
    await userProvider.synApiRes("home", "home");
    myMap = userProvider.getApiRes("home");
    setState(() {

    });
  }
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
              'assets/icons/post.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () {},
          ),
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
                Text("---- $textContent"),
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
                  child: Column(
                    children: [
                      ingiBoard(),
                      ingiBoard(),
                      ingiBoard(),
                    ],
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

class ingiBoard extends StatelessWidget {

  const ingiBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     // height: 100,
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                "1",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "이거 어떻하냐...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "즐거운 넙죽이",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 8,
                        ),

                        Text(
                          "5분전",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.thumb_up),
                        Text(
                          "1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.thumb_up),
                        Text(
                          "1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.thumb_up),
                        Text(
                          "1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16),

       //   I
        ],
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
