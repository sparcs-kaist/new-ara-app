import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/widgets/post_preview.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

/// PostListShowPage는 게시판 목록를 나타내는 위젯.
/// boardType에 따라 게시판의 종류를 판별하고, 특성화 된 위젯들을 활성화 비활성화 되도록 설계.
/// 모든 게시물 목록 형태가 유사하기에 최대한 코드를 재할용.
class PostListShowPage extends StatefulWidget {
  final BoardDetailActionModel? boardInfo;
  final BoardType boardType;
  const PostListShowPage(
      {super.key, required this.boardType, required this.boardInfo});

  @override
  State<PostListShowPage> createState() => _PostListShowPageState();
}

class _PostListShowPageState extends State<PostListShowPage> {
  List<ArticleListActionModel> postPreviewList = [];
  int currentPage = 1;
  bool isLoading = true;
  String apiUrl = "";
  String _boardName = "";
  bool _isLoadingNextPage = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var userProvider = context.read<UserProvider>();

    // 게시판 타입에 따라 API URL과 게시판 이름을 설정
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
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // 게시글 목록을 새로고침하는 함수
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
                  .add(ArticleListActionModel.fromJson(myMap["results"][i]));
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

  // 스크롤 리스너 함수. 스크롤이 끝에 도달하면 추가 데이터를 로드
  void _scrollListener() async {
    var userProvider = context.read<UserProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        _isLoadingNextPage == false) {
      setState(() {
        _isLoadingNextPage = true;
      });

      currentPage = currentPage + 1;
      // api 호출과 Provider 정보 동기화.
      // await Future.delayed(Duration(seconds: 1));
      // TODO: try catch로 감싸기
      Map<String, dynamic>? myMap =
          await userProvider.getApiRes("$apiUrl$currentPage");
      if (mounted) {
        setState(() {
          //TODO: 더 불러올 자료가 없으면 막기. 현재 에러남.
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
          _isLoadingNextPage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: void refreshPostList(UserProvider userProvider) async 메소드와 통합하기.
    /// 게시물 클릭하고 다시 돌아올 때 게시물 목록 업데이트 해주는 함수.
    Future<void> updateAllBulletinList() async {
      List<ArticleListActionModel> newList = [];
      UserProvider userProvider = context.read<UserProvider>();
      for (int j = 1; j <= currentPage; j++) {
        Map<String, dynamic>? json = await userProvider.getApiRes("$apiUrl$j");

        for (int i = 0; i < (json!["results"].length ?? 0); i++) {
          //???/
          if (widget.boardType != BoardType.scraps &&
              json["results"][i]["created_by"]["profile"] != null) {
            newList
                .add(ArticleListActionModel.fromJson(json["results"][i] ?? {}));
          } else if (widget.boardType == BoardType.scraps) {
            // 스크랩 게시물이면
            newList.add(ArticleListActionModel.fromJson(
                json["results"][i]["parent_article"] ?? {}));
          }
        }
      }
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          postPreviewList = [...newList];
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
                colorFilter: const ColorFilter.mode(
                    ColorsInfo.newara, BlendMode.srcATop),
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
              colorFilter:
                  const ColorFilter.mode(ColorsInfo.newara, BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
            onPressed: () async {
              await Navigator.of(context).push(slideRoute(BulletinSearchPage(
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
            onPressed: () async {
              await Navigator.of(context)
                  .push(slideRoute(const PostWritePage()));
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
                colorFilter: const ColorFilter.mode(
                    ColorsInfo.newara, BlendMode.srcIn), // 글쓰기 아이콘 색상 변경
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
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: postPreviewList.length +
                        (_isLoadingNextPage ? 1 : 0), // 아이템 개수
                    itemBuilder: (BuildContext context, int index) {
                      // 각 아이템을 위한 위젯 생성
                      if (_isLoadingNextPage &&
                          index == postPreviewList.length) {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: LoadingIndicator(),
                          ),
                        );
                      } else {
                        // 숨겨진 게시물이면 일단 표현 안하는 걸로 함.
                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(slideRoute(
                                PostViewPage(id: postPreviewList[index].id)));
                            updateAllBulletinList();
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(11.0),
                                child:
                                    PostPreview(model: postPreviewList[index]),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 1,
                        color: const Color(0xFFF0F0F0),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
