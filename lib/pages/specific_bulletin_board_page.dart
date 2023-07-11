import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/models/article_list_action_model.dart';

class SpecificBulletinBoardPage extends StatefulWidget {
  const SpecificBulletinBoardPage({Key? key}) : super(key: key);

  @override
  State<SpecificBulletinBoardPage> createState() =>
      _SpecificBulletinBoardPageState();
}

class _SpecificBulletinBoardPageState extends State<SpecificBulletinBoardPage> {
  List<ArticleListActionModel> postPreviewList = [];
  int currentPage = 1;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var userProvider = context.read<UserProvider>();
    _scrollController.addListener(_scrollListener);
    refreshDailyBest(userProvider);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void refreshDailyBest(UserProvider userProvider) async {
    // await Future.delayed(Duration(seconds: 1));
    // api 호출과 Provider 정보 동기화
    Map<String, dynamic>? myMap =
        await userProvider.getApiRes2("articles/?parent_board=7&page=1");
    if (mounted) {
      setState(() {
        postPreviewList.clear();
        for (int i = 0; i < (myMap?["results"].length ?? 0); i++) {
          postPreviewList
              .add(ArticleListActionModel.fromJson(myMap?["results"][i] ?? {}));
        }
        isLoading = false;
      });
    }
  }

  void _scrollListener() async {
    var userProvider = context.read<UserProvider>();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage = currentPage + 1;
      // await Future.delayed(Duration(seconds: 1));
      // api 호출과 Provider 정보 동기화
      Map<String, dynamic>? myMap = await userProvider
          .getApiRes2("articles/?parent_board=7&page=$currentPage");
      if (mounted) {
        setState(() {
          // "is_hidden": true,
          // "why_hidden": [
          // "REPORTED_CONTENT"
          // ]
          for (int i = 0; i < (myMap?["results"].length ?? 0); i++) {
            if (myMap?["results"][i]["created_by"]["profile"] != null &&
                myMap?["results"][i]["is_hidden"] == false) {
              postPreviewList.add(
                  ArticleListActionModel.fromJson(myMap?["results"][i] ?? {}));
            }
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          children: [
            SizedBox(
              width: 35,
              child: IconButton(
                color: ColorsInfo.newara,
                icon: SizedBox(
                  width: 11.58,
                  height: 21.87,
                  child: SvgPicture.asset(
                    'assets/icons/left_chevron.svg',
                    color: ColorsInfo.newara,
                    fit: BoxFit.fill,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Text(
              "게시판",
              style: TextStyle(
                color: Color(0xFFED3A3A),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // FloatingActionButton을 누를 때 실행될 동작을 정의합니다.
              debugPrint('FloatingActionButton pressed');
            },
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 42,
              height: 42,
              child: SvgPicture.asset(
                'assets/icons/modify.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
      body: isLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 11,
                          ),
                          const Expanded(
                            child: Text(
                              "학교에게 전합니다.",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: ColorsInfo.newara,
                              ),
                            ),
                          ),
                          SvgPicture.asset('assets/icons/information.svg')
                        ],
                      ),
                      const SizedBox(
                        height: 106,
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: postPreviewList.length, // 아이템 개수
                          itemBuilder: (BuildContext context, int index) {
                            // 각 아이템을 위한 위젯 생성
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: PostPreview(
                                      model: postPreviewList[index]),
                                ),
                                Container(
                                  height: 1,
                                  color: const Color(0xFFF0F0F0),
                                ),
                              ],
                            );
                          },
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
