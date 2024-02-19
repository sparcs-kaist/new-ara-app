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

/// PostListShowPage는 게시물 목록를 나타내는 위젯.
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
    updateAllBulletinList().then(
      (value) {
        _loadNextPage();
      },
    );
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// 게시물 update(게시판의 current페이지까지에 있는 게시물들을 불러옴)
  Future<void> updateAllBulletinList() async {
    List<ArticleListActionModel> newList = [];
    UserProvider userProvider = context.read<UserProvider>();

    // 모든 페이지를 순회하며 게시물 목록을 업데이트합니다.
    for (int page = 1; page <= currentPage; page++) {
      Map<String, dynamic>? json = await userProvider.getApiRes("$apiUrl$page");

      if (json != null && json.containsKey("results")) {
        for (var result in json["results"]) {
          // 스크랩 게시물인 경우와 아닌 경우를 분기하여 처리합니다.
          if (widget.boardType != BoardType.scraps &&
              result["created_by"]["profile"] != null) {
            newList.add(ArticleListActionModel.fromJson(result));
          } else if (widget.boardType == BoardType.scraps &&
              result.containsKey("parent_article")) {
            newList
                .add(ArticleListActionModel.fromJson(result["parent_article"]));
          }
        }
      }
    }

    // 위젯이 마운트 상태인 경우 상태를 업데이트합니다.
    if (mounted) {
      setState(() {
        postPreviewList.clear();
        postPreviewList.addAll(newList);
        isLoading = false; // 로딩 상태 업데이트
      });
    }
  }

  /// 다음 페이지를 로드하는 함수
  Future<void> _loadNextPage() async {
    var userProvider = context.read<UserProvider>();
    setState(() {
      _isLoadingNextPage = true;
    });

    // api 호출과 Provider 정보 동기화.
    // await Future.delayed(Duration(seconds: 1));
    try {
      currentPage = currentPage + 1;
      Map<String, dynamic>? myMap =
          await userProvider.getApiRes("$apiUrl$currentPage");
      if (mounted) {
        setState(() {
          for (int i = 0; i < (myMap!["results"].length ?? 0); i++) {
            if (myMap["results"][i]["created_by"]["profile"] != null) {
              postPreviewList.add(
                  ArticleListActionModel.fromJson(myMap["results"][i] ?? {}));
            } else if (widget.boardType == BoardType.scraps) {
              // 스크랩 게시물이면
              postPreviewList.add(ArticleListActionModel.fromJson(
                  myMap["results"][i]["parent_article"] ?? {}));
            }
          }
        });
      }
    } catch (error) {
      currentPage = currentPage - 1;
      debugPrint("scrollListener error : $error");
    }
    if (mounted) {
      setState(() {
        _isLoadingNextPage = false;
      });
    }
  }

  /// 스크롤 리스너 함수
  /// 
  /// 스크롤이 끝에 도달하면 추가 데이터를 로드하기 위해 _loadNextPage 함수를 호출합니다.
  void _scrollListener() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        _isLoadingNextPage == false) {
      _loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SvgPicture.asset(
                'assets/icons/left_chevron.svg',
                colorFilter: const ColorFilter.mode(
                    ColorsInfo.newara, BlendMode.srcATop),
                fit: BoxFit.fill,
                width: 35,
                height: 35,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 29),
                child: Text(
                  "게시판",
                  style: TextStyle(
                    color: Color(0xFFED3A3A),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
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
      // snackbar와 floatingActionButton이 충돌을 일으킬 수 있어서
      // 기존에 Column()으로 선언되어있는 floatingActionButton에
      // SizedBox로 크기를 지정함.
      floatingActionButton: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(slideRoute(PostWritePage(
                  previousBoard: widget.boardInfo,
                )));
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
      ),
      body: isLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 18,
                  child: RefreshIndicator.adaptive(
                    color: ColorsInfo.newara,
                    onRefresh: () async {
                      setState((() => isLoading = true));
                      await updateAllBulletinList();
                    },
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
                                  child: PostPreview(
                                      model: postPreviewList[index]),
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
            ),
    );
  }
}
