import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/models/article_list_action_model.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/pages/post_view_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';

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

    switch (widget.boardType) {
      case BoardType.free:
        _apiUrl =
            "articles/?parent_board=${widget.boardInfo!.id.toInt()}&page=";
        _hintText = widget.boardInfo!.ko_name + "에서 검색";
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
${_apiUrl}1&main_search__contains=${_searchWord}
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
      // api 호출과 Provider 정보 동기화.
      // await Future.delayed(Duration(seconds: 1));
      Map<String, dynamic>? myMap = await userProvider.getApiRes(
          "$_apiUrl$_currentPage&main_search__contains=$_searchWord");
      if (mounted) {
        setState(() {
          // "is_hidden": true,
          // "why_hidden": [
          // "REPORTED_CONTENT"
          // ]
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
            // Expanded(child: TextField()),
          ],
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: TextField(
                minLines: 1,
                maxLines: 1,
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
                  height: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  prefixIconConstraints:
                      const BoxConstraints(maxHeight: 28, maxWidth: 28),
                  prefixIcon: SizedBox(
                    // 원하는 세로 크기
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      color: Colors.grey,
                      fit: BoxFit.contain,
                    ),
                  ),
                  hintText: _hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFFBBBBBB),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(
                    10.0,
                    10.0,
                    10.0,
                    10.0,
                  ), // 모서리를 둥글게 설정
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostViewPage(
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