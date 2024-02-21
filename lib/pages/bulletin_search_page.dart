import 'dart:async';

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
  final List<ArticleListActionModel> postPreviewList = [];
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingNextPage = false;
  String _apiUrl = "";
  String _hintText = "";
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEdtingController = TextEditingController();

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
      case BoardType.recent:
        _apiUrl = "articles/recent/?page=";
        _hintText = "최근 본 글에서 검색";
        break;
      case BoardType.top:
        _apiUrl = "articles/top/?page=";
        _hintText = "실시간 인기글에서 검색";
        break;
      case BoardType.scraps:
        _apiUrl = "scraps/?page=";
        _hintText = "담아둔 글에서 검색";
        break;
      default:
        _apiUrl = "articles/recent/?page=";
        _hintText = "검색";
        break;
    }

    UserProvider userProvider = context.read<UserProvider>();
    // 위젯이 빌드된 후에 포커스를 줍니다.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
    _scrollController.addListener(_scrollListener);
    refreshPostList("");
  }

  @override
  void dispose() {
    // FocusNode를 정리합니다.
    _focusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// 사용자가 입력한 검색어를 기반으로 게시물 새로 고침.
  void refreshPostList(String targetWord) async {
    if (targetWord == "") {
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          _isLoading = false;
        });
      }
      return;
    }
    final UserProvider userProvider = context.read<UserProvider>();
    final Map<String, dynamic>? myMap = await userProvider
        .getApiRes("${_apiUrl}1&main_search__contains=$targetWord");
    if (mounted && targetWord == _textEdtingController.text) {
      setState(() {
        postPreviewList.clear();
        for (int i = 0; i < (myMap?["results"].length ?? 0); i++) {
          try {
            postPreviewList
                .add(ArticleListActionModel.fromJson(myMap!["results"][i]));
            //     debugPrint("refreshPostList : postPreviewList[$i] : ${_temp[i].title}");
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
    //스크롤 시 포커스 해제
    FocusScope.of(context).unfocus();
    if (_textEdtingController.text == "") {
      if (mounted) {
        setState(() {
          postPreviewList.clear();
          _isLoading = false;
        });
      }
      return;
    }

    try {
      if (mounted) {
        setState(() {
          _isLoadingNextPage = true;
        });
      }
      UserProvider userProvider = context.read<UserProvider>();
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _currentPage = _currentPage + 1;
        //TODO: 더 이상 불러올 게시물이 없을 때의 처리
        Map<String, dynamic>? myMap = await userProvider.getApiRes(
            "$_apiUrl$_currentPage&main_search__contains=${_textEdtingController.text}");
        if (mounted) {
          setState(() {
            for (int i = 0; i < (myMap!["results"].length ?? 0); i++) {
              //???/
              if (myMap["results"][i]["created_by"]["profile"] != null) {
                postPreviewList.add(
                    ArticleListActionModel.fromJson(myMap["results"][i] ?? {}));
              }
            }
          });
          setState(() {
            _isLoading = false;
            _isLoadingNextPage = false;
          });
        }
      }
    } catch (error) {
      _currentPage = _currentPage - 1;
      setState(() {
        _isLoading = false;
        _isLoadingNextPage = false;
      });
      debugPrint("scrollListener error : $error");
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.search,
                          controller: _textEdtingController,
                          onSubmitted: (String text) {
                            setState(() {
                              _isLoading = true;
                            });
                            refreshPostList(text);
                          },
                          onChanged: (String text) {
                            _debouncer.run(() {
                              debugPrint(
                                  "bulletin_search_page: onChanged(${DateTime.now().toString()}) : $text");
                              refreshPostList(text);
                            });
                          },
                          style: const TextStyle(
                            //height * fontSize = line height(커서 크기)
                            height: 18 / 14,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            isDense: true,
                            filled: true,
                            fillColor: const Color(0xFFF6F6F6),
                            // richtext를 밑으로 내리고 싶으면 contentPadding의 B를 줄일것
                            contentPadding:
                                const EdgeInsets.fromLTRB(100, 10, 10, 9),
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 24, maxWidth: 31),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(6.0, 0, 1, 0),
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
                              height: null,
                              fontWeight: FontWeight.w500,
                            ),

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
                  child: Column(
                    children: [
                      // 검색어가 없을 때와 검색 결과가 없을 때의 처리
                      if (_textEdtingController.text == "" &&
                          postPreviewList.isEmpty)
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/information.svg',
                                  width: 30,
                                  height: 30,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFBBBBBB),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const Text(
                                  '검색어를 입력해주세요.',
                                  style: TextStyle(
                                    color: Color(0xFFBBBBBB),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      // 검색어가 있는데 검색 결과가 없을 때의 처리
                      if (_textEdtingController.text != "" &&
                          postPreviewList.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/information.svg',
                                  width: 50,
                                  height: 50,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFBBBBBB),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const Text(
                                  '검색 결과가 없습니다.',
                                  style: TextStyle(
                                    color: Color(0xFFBBBBBB),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (postPreviewList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: postPreviewList.length +
                                (_isLoadingNextPage ? 1 : 0), // 아이템 개수
                            itemBuilder: (BuildContext context, int index) {
                              if (_isLoadingNextPage &&
                                  index == postPreviewList.length) {
                                return const SizedBox(
                                  height: 63,
                                  child: Center(
                                    child: LoadingIndicator(),
                                  ),
                                );
                              }
                              return InkWell(
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
                                ),
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

/// 디바운싱 기능을 구현한 클래스
///
/// 검색창에 글씨 입력과 같이 빠르게 연속되는 이벤트들 사이에서 중복 반응을 방지하기 위해 사용되었음
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

final _debouncer = Debouncer(milliseconds: 5);
