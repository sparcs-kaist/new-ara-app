import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';

class FreeBulletinBoardPage extends StatefulWidget {
  final BoardDetailActionModel? boardInfo;
  final BoardType boardType;
  const FreeBulletinBoardPage(
      {super.key, required this.boardType, required this.boardInfo});

  @override
  State<FreeBulletinBoardPage> createState() => _FreeBulletinBoardPageState();
}

class _FreeBulletinBoardPageState extends State<FreeBulletinBoardPage> {
  List<ArticleListActionModel> postPreviewList = [];
  int currentPage = 1;
  bool isLoading = true;
  String apiUrl = "";
  String _boardName = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var userProvider = context.read<UserProvider>();

    switch (widget.boardType) {
      case BoardType.free:
        apiUrl = "articles/?parent_board=${widget.boardInfo!.id.toInt()}&page=";
        _boardName = widget.boardInfo!.ko_name;
        break;
      case BoardType.recent:
        apiUrl = "articles/recent/?page=";
        _boardName = "최근 본 글";
        break;
      case BoardType.top:
        apiUrl = "articles/top/?page=";
        _boardName = "실시간 인기글";
        break;
      case BoardType.all:
        apiUrl = "articles/?page=";
        _boardName = "전체보기";
        break;
      case BoardType.scraps:
        apiUrl = "scraps/?page=";
        _boardName = "담아둔 글";
        break;
      default:
        apiUrl = "articles/?page=";
        _boardName = "테스트 게시판";
        break;
    }

    _scrollController.addListener(_scrollListener);
    refreshPostList(userProvider);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void refreshPostList(UserProvider userProvider) async {
    Map<String, dynamic>? myMap = await userProvider.getApiRes("${apiUrl}1");
    debugPrint(myMap?["results"].toString());
    if (mounted) {
      setState(() {
        postPreviewList.clear();
        for (int i = 0; i < (myMap?["results"].length ?? 0); i++) {
          try {
            if (widget.boardType != BoardType.scraps &&
                myMap!["results"][i]["created_by"]["profile"] != null) {
                  
              postPreviewList
                  .add(ArticleListActionModel.fromJson(myMap!["results"][i]));
            } else if (widget.boardType == BoardType.scraps) {
              postPreviewList.add(ArticleListActionModel.fromJson(
                  myMap!["results"][i]["parent_article"]));
            }
          } catch (error) {
            debugPrint(
                "refreshPostList error at $i : $error"); // invalid json 걸러내기
          }
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
      // api 호출과 Provider 정보 동기화.
      // await Future.delayed(Duration(seconds: 1));
      Map<String, dynamic>? myMap =
          await userProvider.getApiRes("$apiUrl$currentPage");
      if (mounted) {
        setState(() {
          for (int i = 0; i < (myMap!["results"].length ?? 0); i++) {
            //???/
            if (myMap["results"][i]["created_by"]["profile"] != null) {
              postPreviewList.add(
                  ArticleListActionModel.fromJson(myMap["results"][i] ?? {}));
            } else if (widget.boardType == BoardType.scraps) {
              // 스크랩 게시물이면
              postPreviewList.add(ArticleListActionModel.fromJson(
                  myMap["results"][i]["parent_article"] ?? {}));
            }
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateAllBulletinList() async {
      List<ArticleListActionModel> _newList = [];
      UserProvider userProvider = context.read<UserProvider>();
      for (int j = 1; j <= currentPage; j++) {
        Map<String, dynamic>? json = await userProvider.getApiRes("$apiUrl$j");

        for (int i = 0; i < (json!["results"].length ?? 0); i++) {
          //???/
          if (widget.boardType != BoardType.scraps &&
              json["results"][i]["created_by"]["profile"] != null) {
            _newList
                .add(ArticleListActionModel.fromJson(json["results"][i] ?? {}));
          } else if (widget.boardType == BoardType.scraps) {
            // 스크랩 게시물이면
            _newList.add(ArticleListActionModel.fromJson(
                json["results"][i]["parent_article"] ?? {}));
          }
        }
      }
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          postPreviewList = [..._newList];
        });
      }
      return Future.value();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/left_chevron.svg',
                color: ColorsInfo.newara,
                fit: BoxFit.fill,
                width: 35,
                height: 35,
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
        ),
        title: SizedBox(
          child: Text(
            _boardName,
            style: const TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 35,
              height: 35,
            ),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BulletinSearchPage(
                            boardType: widget.boardType,
                            boardInfo: widget.boardInfo,
                          )));
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              await Navigator.of(context).push(
                slideRoute(PostWritePage())
              );
              updateAllBulletinList();
              debugPrint('FloatingActionButton pressed');
            },
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 42,
              height: 42,
              child: SvgPicture.asset(
                'assets/icons/modify.svg',
                fit: BoxFit.fill,
                color: ColorsInfo.newara,
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
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: postPreviewList.length, // 아이템 개수
                    itemBuilder: (BuildContext context, int index) {
                      // 각 아이템을 위한 위젯 생성
                      // 숨겨진 게시물이면 일단 표현 안하는 걸로 함.
                      return postPreviewList[index].is_hidden
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(slideRoute(
                                    PostViewPage(
                                        id: postPreviewList[index].id)));
                                updateAllBulletinList();
                              },
                              child: Column(
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
                              ));
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
