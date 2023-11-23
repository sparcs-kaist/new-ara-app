import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/widgets/post_preview.dart';
import 'package:provider/provider.dart';

/// `BulletinSearchPage`는 게시판 게시물에 대한 검색 인터페이스를 표시하는 위젯
/// 상단에 검색 바를 제공하고 검색 결과에 따른 게시물 목록을 표시
class BulletinSearchPage extends StatefulWidget {
  final BoardDetailActionModel? boardInfo;
  final BoardType boardType;

  const BulletinSearchPage(
      {super.key, required this.boardType, required this.boardInfo});

  @override
  State<BulletinSearchPage> createState() => _BulletinSearchPageState();
}

class _BulletinSearchPageState extends State<BulletinSearchPage> {
  List<ArticleListActionModel> postPreviewList = [];
  int _currentPage = 1;
  bool _isLoading = true;
  String _apiUrl = "";
  String _hintText = "";
  String _searchWord = "";
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 게시판 유형에 따라 API URL 및 힌트 텍스트를 다르게 설정
    // 현재는 전체 게시물에서 검색을 하는 것과, 특정 게시판에서 검색을 하는 것만 지원
    switch (widget.boardType) {
      case BoardType.free:
        _apiUrl =
            "articles/?parent_board=${widget.boardInfo!.id.toInt()}&page=";
        _hintText = "${widget.boardInfo!.ko_name}에서 검색";
        break;
      case BoardType.all:
        _apiUrl = "articles/?page=";
        _hintText = "전체 보기에서 검색";
        break;
      default:
        _apiUrl = "articles/recent/?page=";
        break;
    }

    var userProvider = context.read<UserProvider>();
    _scrollController.addListener(_scrollListener);
    refreshPostList(userProvider);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// 사용자가 입력한 검색어를 기반으로 게시물 새로 고침.
  void refreshPostList(UserProvider userProvider) async {
    if (_searchWord == "") {
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          _isLoading = false;
        });
      }
      return;
    }

    Map<String, dynamic>? myMap = await userProvider.getApiRes("""
${_apiUrl}1&main_search__contains=$_searchWord
""");

    if (mounted) {
      setState(() {
        postPreviewList.clear();
        for (int i = 0; i < (myMap?["results"].length ?? 0); i++) {
          try {
            postPreviewList
                .add(ArticleListActionModel.fromJson(myMap!["results"][i]));
          } catch (error) {
            debugPrint(
                "refreshPostList error at $i : $error"); // invalid json 걸러내기
          }
        }
        _isLoading = false;
      });
    }
  }

  /// 사용자가 스크롤을 내렸을 때 추가 게시물을 불러옴
  void _scrollListener() async {
    if (_searchWord == "") {
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          _isLoading = false;
        });
      }
      return;
    }

    var userProvider = context.read<UserProvider>();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage = _currentPage + 1;
      Map<String, dynamic>? myMap = await userProvider.getApiRes(
          "$_apiUrl$_currentPage&main_search__contains=$_searchWord");
      if (mounted) {
        setState(() {
          for (int i = 0; i < (myMap!["results"].length ?? 0); i++) {
            //???/
            if (myMap["results"][i]["created_by"]["profile"] != null) {
              postPreviewList.add(
                  ArticleListActionModel.fromJson(myMap["results"][i] ?? {}));
            }
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(1, 10.5, 4, 10.5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                width: 35,
                height: 35,
                child: SvgPicture.asset(
                  'assets/icons/left_chevron.svg',
                  colorFilter: const ColorFilter.mode(
                      ColorsInfo.newara, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 36,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.bottom,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (String text) {
                            setState(() {
                              _searchWord = text;
                              _isLoading = true;
                            });
                            refreshPostList(context.read<UserProvider>());
                          },
                          style: const TextStyle(
                            //TODO: 커서 크기와 텍스트 베이스라인 교정하기.
                            height: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 14),
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 28, minHeight: 28),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                              child: SizedBox(
                                // 원하는 세로 크기
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Color(0xFFBBBBBB), BlendMode.srcIn),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            hintText: _hintText,
                            hintStyle: const TextStyle(
                              color: Color(0xFFBBBBBB),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF6F6F6),
                            isDense: false,
                            // 모서리를 둥글게 설정
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent, // 테두리 색상 설정
                              ), // 모서리를 둥글게 설정
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.transparent, // 테두리 색상 설정
                              ), // 모서리를 둥글게 설정
                            ),
                          ),
                          cursorColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
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
                              onTap: () {
                                Navigator.of(context).push(slideRoute(
                                    PostViewPage(
                                        id: postPreviewList[index].id)));
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
