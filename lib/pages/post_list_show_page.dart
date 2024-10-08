import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:new_ara_app/pages/post_write_page.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
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
import 'package:new_ara_app/widgets/pop_up_menu_buttons.dart';
import 'package:new_ara_app/utils/with_school.dart';

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

class _PostListShowPageState extends State<PostListShowPage>
    with WidgetsBindingObserver {
  List<ArticleListActionModel> postPreviewList = [];

  /// 현재 선택된 말머리 필터의 인덱스를 나타냄.
  /// 기본값은 전체(= 0)
  int currentFilter = 0;

  /// 말머리 필터가 필요한 지 여부를 나타내는 변수
  /// 학교에게 전합니다 게시판 or BoardDetailActionModel의 topics가 isNotEmpty일 때 true
  late bool isTopicsFilterRequired;

  /// 현재 어디까지 페이지가 로딩됐는 지 기록하는 변수
  int currentPage = 1;
  bool isLoading = true;
  String apiUrl = "";
  String _boardName = "";
  bool _isLoadingNextPage = false;
  bool _isLastItem = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    var userProvider = context.read<UserProvider>();
    // TODO: '학교에게 전합니다' 게시판의 말머리가 생길 경우 조건문 수정해야함.
    isTopicsFilterRequired = (widget.boardInfo != null &&
        (widget.boardInfo!.slug == 'with-school' ||
            widget.boardInfo!.topics.isNotEmpty));
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    // updateAllBulletinList().then(
    //   (value) {
    //     _loadNextPage();
    //   },
    // );
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// initState 직후에는 updateAllBulletinList가 호출되어야 함.
    /// initState 직후에는 apiUrl == ""이므로 이를 통해
    /// didChangeDependencies에서 initState 직후 임을 파악하고 updateAllBulletinList 함수를 호출함.
    String prevApiUrl = apiUrl;

    // 게시판 타입에 따라 API URL과 게시판 이름을 설정
    debugPrint("Current Locale: ${context.locale}");
    switch (widget.boardType) {
      case BoardType.free:
        apiUrl = "articles/?parent_board=${widget.boardInfo!.id.toInt()}&page=";
        _boardName = context.locale == const Locale("ko")
            ? widget.boardInfo!.ko_name
            : widget.boardInfo!.en_name;
        break;
      case BoardType.recent:
        apiUrl = "articles/recent/?page=";
        _boardName = LocaleKeys.postListShowPage_history.tr();
        break;
      case BoardType.top:
        apiUrl = "articles/top/?page=";
        _boardName = LocaleKeys.postListShowPage_topPosts.tr();
        break;
      case BoardType.all:
        apiUrl = "articles/?page=";
        _boardName = LocaleKeys.postListShowPage_allPosts.tr();
        break;
      case BoardType.scraps:
        apiUrl = "scraps/?page=";
        _boardName = LocaleKeys.postListShowPage_bookmarks.tr();
        break;
      default:
        apiUrl = "articles/?page=";
        _boardName = LocaleKeys.postListShowPage_testBoard.tr();
        break;
    }
    // initState 직후에는 updateAllBulletinList 함수를 호출함.
    if (prevApiUrl == "") {
      updateAllBulletinList().then(
        (_) {
          _loadNextPage();
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 백그라운드에서 포그라운드로 전환될 때 게시물 목록을 업데이트합니다.
      updateAllBulletinList();
    }
  }

  /// 게시물 update(게시판의 current페이지까지에 있는 게시물들을 불러옴)
  ///
  /// [pageLimitToReload] : 새로 로딩할 최대 페이지 수.
  /// [currentPage] 값보다 [pageLimitToReload] 값이 큰 지 코딩할 때 주의 바랍니다.
  Future<void> updateAllBulletinList({int? pageLimitToReload}) async {
    debugPrint("updateAllBulletinList called!!!!!!");
    List<ArticleListActionModel> newList = [];
    UserProvider userProvider = context.read<UserProvider>();

    // 모든 페이지를 순회하며 게시물 목록을 업데이트합니다.
    for (int page = 1;
        page <=
            // pageLimitToReload가 null이 아니면(파라미터가 존재하면) currentPage보다 우선시 합니다.
            (pageLimitToReload ?? currentPage);
        page++) {
      var response = await userProvider.getApiRes("$apiUrl$page");
      final Map<String, dynamic>? json = await response?.data;

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

    debugPrint("updateAllBulleinList mounted: $mounted");
    // 위젯이 마운트 상태인 경우 상태를 업데이트합니다.
    if (mounted) {
      setState(() {
        /// 현재 어디까지 로딩됐는 지 기록하는 변수 [currentPage]를 업데이트합니다.
        currentPage = (pageLimitToReload ?? currentPage);
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
      var response = await userProvider.getApiRes("$apiUrl$currentPage");
      final Map<String, dynamic>? myMap = await response?.data;
      _isLastItem = false; //로딩에 성공함 (마지막 페이지가 아님)

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
          postPreviewList.sort((a, b) => b.created_at.compareTo(a.created_at));
        });
      }
    } on TypeError {
      //Last item에 도달함 (_CastError)
      currentPage = currentPage - 1;
      _isLastItem = true;
      debugPrint("post_list_show_page : last item reached");
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

  Widget _buildTopicButton(String text, int index) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                currentFilter == index ? ColorsInfo.newara : Colors.white),
            overlayColor:
                MaterialStateProperty.all(Colors.transparent), // no splash
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                    color: currentFilter == index
                        ? ColorsInfo.newara
                        : const Color(0xFFBBBBBB),
                    width: 1),
              ),
            ),
          ),
          onPressed: () async {
            setState(() => currentFilter = index);
            isLoading = true;

            // _buildTopicButton이 호출될때는 BoardType이 free임이 보장되나
            // 의도치 않은 예외 방지를 위해 조건문 추가함.
            if (widget.boardType == BoardType.free) {
              apiUrl = index == 0
                  ? "articles/?parent_board=${widget.boardInfo!.id.toInt()}&page="
                  : (!isWithSchoolBoard(widget.boardInfo)
                      ? "articles/?parent_board=${widget.boardInfo!.id.toInt()}&parent_topic=${widget.boardInfo!.topics[index - 1].id}&page="
                      : "articles/?parent_board=${widget.boardInfo!.id.toInt()}&communication_article__school_response_status=${WithSchoolStatus.values[index - 1].index}&page=");
            }
            // 리프레쉬시 게시물 목록을 업데이트합니다.
            // 1페이지만 로드하도록 설정하여 최신 게시물을 불러옵니다.
            // 1페이지만 로드하면 태블릿에서 게시물로 화면을 꽉채우지 못하므로 다음 페이지도 로드합니다.
            await updateAllBulletinList(pageLimitToReload: 1).then(
              (value) {
                _loadNextPage();
              },
            );
            isLoading = false;
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16, // PostPreview의 제목과 동일한 폰트 크기
              color: currentFilter == index
                  ? Colors.white
                  : const Color.fromARGB(255, 101, 100, 100),
            ),
          )),
    );
  }

  List<Widget> _buildTopicBoxes(
      BuildContext context, BoardDetailActionModel model) {
    late List<Widget> ret;
    if (model.slug != 'with-school') {
      ret = List<Widget>.generate(model.topics.length, (index) {
        return _buildTopicButton(
            context.locale == const Locale('ko')
                ? model.topics[index].ko_name
                : model.topics[index].en_name,
            index + 1); // total이 첫번째이므로 + 1 씩 크게
      });
    } else {
      ret = [
        _buildTopicButton(
            context.locale == const Locale('ko') ? "달성 전" : "Polling", 1),
        _buildTopicButton(
            context.locale == const Locale('ko') ? "답변 준비중" : "Preparing", 2),
        _buildTopicButton(
            context.locale == const Locale('ko') ? "답변 완료" : "Answered", 3),
      ];
    }
    return <Widget>[
          _buildTopicButton(
              context.locale == const Locale('ko') ? "전체" : "Total", 0)
        ] +
        ret;
  }

  /// articleModel 게시글이 필터링되어야(화면에 보이지 않아야) 하는 경우에 true를 반환.
  /// 아래 ListView.separated에서 사용하기 위해 작성.
  bool isFiltered(BoardDetailActionModel? boardModel,
      ArticleListActionModel articleModel, int filterIdx) {
    // board가 지정되지 않은 경우, '전체'인 경우 필터링이 필요하지 않음.
    if (boardModel == null || filterIdx == 0) return false;

    if (isWithSchoolBoard(boardModel)) {
      return (articleModel.communication_article_status !=
          WithSchoolStatus.values[filterIdx - 1].index);
    } else {
      return (articleModel.parent_topic?.slug !=
          boardModel.topics[filterIdx - 1].slug);
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
              Padding(
                padding: const EdgeInsets.only(left: 29),
                child: Text(
                  LocaleKeys.postListShowPage_boards.tr(),
                  style: const TextStyle(
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
          if (isWithSchoolBoard(widget.boardInfo))
            const WithSchoolPopupMenuButton(),
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
              backgroundColor: ColorsInfo.newara,
              child: SizedBox(
                width: 42,
                height: 42,
                child: SvgPicture.asset(
                  'assets/icons/modify.svg',
                  fit: BoxFit.fill,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn), // 글쓰기 아이콘 색상 변경
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 18,
            child: Column(
              children: [
                // 말머리필터
                if (isTopicsFilterRequired)
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 18,
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // isTopicsFilterRequired가 true이면 boardInfo가 null이 아님이 보장됨.
                        children: _buildTopicBoxes(context, widget.boardInfo!),
                      ),
                    ),
                  ),
                if (isTopicsFilterRequired)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 1,
                    color: const Color(0xFFF0F0F0),
                  ),
                Expanded(
                  child: RefreshIndicator.adaptive(
                    displacement: 0.0,
                    color: ColorsInfo.newara,
                    onRefresh: () async {
                      // refresh 중에는 LoadingIndicator를 사용하지 않으므로 setState()는 제거함.
                      // 로직상 isLoading 변수의 값은 상황에 맞게 변경되도록 함.
                      isLoading = true;
                      // 리프레쉬시 게시물 목록을 업데이트합니다.
                      // 1페이지만 로드하도록 설정하여 최신 게시물을 불러옵니다.
                      // 1페이지만 로드하면 태블릿에서 게시물로 화면을 꽉채우지 못하므로 다음 페이지도 로드합니다.
                      await updateAllBulletinList(pageLimitToReload: 1).then(
                        (value) {
                          _loadNextPage();
                        },
                      );
                      isLoading = false;
                    },
                    child: isLoading
                        ? const LoadingIndicator()
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: postPreviewList.length +
                                (_isLoadingNextPage ? 1 : 0), // 아이템 개수
                            itemBuilder: (BuildContext context, int index) {
                              // 각 아이템을 위한 위젯 생성
                              if (_isLoadingNextPage &&
                                  index == postPreviewList.length) {
                                debugPrint('Next Page Load Request');
                                return SizedBox(
                                  height: 50,
                                  child: Center(
                                      child: currentPage > 10
                                          ? _isLastItem //마지막 페이지 도달 시
                                              ? Text(
                                                  LocaleKeys
                                                      .postListShowPage_lastItem
                                                      .tr(),
                                                  style: const TextStyle(
                                                      color: ColorsInfo.newara),
                                                )
                                              : const LoadingIndicator()
                                          : null),
                                );
                              } else {
                                // 말머리 필터가 '전체'가 아닌 경우 (학교에게 전합니다 게시판은 아래에서 처리)
                                return isFiltered(widget.boardInfo,
                                        postPreviewList[index], currentFilter)
                                    ? Container()
                                    : InkWell(
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                              slideRoute(PostViewPage(
                                                  id: postPreviewList[index]
                                                      .id)));
                                          updateAllBulletinList();
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(11.0),
                                              child: PostPreview(
                                                  model:
                                                      postPreviewList[index]),
                                            ),
                                          ],
                                        ),
                                      );
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              if (!isFiltered(widget.boardInfo,
                                  postPreviewList[index], currentFilter)) {
                                return Container(
                                  height: 1,
                                  color: const Color(0xFFF0F0F0),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
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
