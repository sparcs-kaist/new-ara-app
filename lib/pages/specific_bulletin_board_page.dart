import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/models/article_list_action_model.dart';

//TODO: free_bulletin_board_page.dart와 통합 필요.
class SpecificBulletinBoardPage extends StatefulWidget {
  const SpecificBulletinBoardPage({Key? key}) : super(key: key);

  @override
  State<SpecificBulletinBoardPage> createState() =>
      _SpecificBulletinBoardPageState();
}

class _SpecificBulletinBoardPageState extends State<SpecificBulletinBoardPage> {
  List<ArticleListActionModel> postList = [];
  int currentPageNumber = 1;
  bool isPageLoading = true;
  final ScrollController postsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    var userProvider = context.read<UserProvider>();
    postsScrollController.addListener(loadMorePostsListener);
    refreshPosts(userProvider);
  }

  @override
  void dispose() {
    postsScrollController.removeListener(loadMorePostsListener);
    postsScrollController.dispose();
    super.dispose();
  }

  void refreshPosts(UserProvider userProvider) async {
    Map<String, dynamic>? apiResponseMap =
        await userProvider.getApiRes("articles/?parent_board=7&page=1");
    if (mounted) {
      setState(() {
        postList.clear();
        for (int i = 0; i < (apiResponseMap?["results"].length ?? 0); i++) {
          postList.add(ArticleListActionModel.fromJson(
              apiResponseMap?["results"][i] ?? {}));
        }
        isPageLoading = false;
      });
    }
  }

  void loadMorePostsListener() async {
    var userProvider = context.read<UserProvider>();
    if (postsScrollController.position.pixels ==
        postsScrollController.position.maxScrollExtent) {
      currentPageNumber = currentPageNumber + 1;
      Map<String, dynamic>? apiResponseMap = await userProvider
          .getApiRes("articles/?parent_board=7&page=$currentPageNumber");
      if (mounted) {
        setState(() {
          for (int i = 0; i < (apiResponseMap?["results"].length ?? 0); i++) {
            if (apiResponseMap?["results"][i]["created_by"]["profile"] !=
                    null &&
                apiResponseMap?["results"][i]["is_hidden"] == false) {
              postList.add(ArticleListActionModel.fromJson(
                  apiResponseMap?["results"][i] ?? {}));
            }
          }
          isPageLoading = false;
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
      body: isPageLoading
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
                          controller: postsScrollController,
                          itemCount: postList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: PostPreview(model: postList[index]),
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
