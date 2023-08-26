import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/free_bulletin_board_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

const boardsByGroupLength = 5;

class BulletinListPage extends StatefulWidget {
  const BulletinListPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BulletinListPageState();
}

class _BulletinListPageState extends State<BulletinListPage> {
  bool isLoading = true;

  List<List<BoardDetailActionModel>> boardsByGroup =
      List.generate(boardsByGroupLength + 1, (_) => []);
  List<Map<String, dynamic>> textContent = [];
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    refreshBoardList(userProvider);
    context.read<NotificationProvider>().checkIsNotReadExist();
  }

  void refreshBoardList(UserProvider userProvider) async {
    //var boardsByGroup = List<dynamic>.filled(6, List< dynamic >.filled(0, null, growable: true) , growable: true);

    List<dynamic> jsonBoards = await userProvider.getApiRes("boards/") ?? [];
    List<BoardDetailActionModel> boardModels = [];
    for (dynamic jsonBoard in jsonBoards) {
      boardModels.add(BoardDetailActionModel.fromJson(jsonBoard));
    }

    if (mounted) {
      setState(() {
        for (BoardDetailActionModel model in boardModels) {
          boardsByGroup[model.group.id].add(model);
        }
        isLoading = false;
      });
    }
    // debugPrint(myMap.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "appBar.bulletin".tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
      ),
      body: isLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextField(
                          minLines: 1,
                          maxLines: 1,
                          focusNode: _focusNode,
                          onTap: () async {
                            debugPrint("onTap");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BulletinSearchPage(
                                      boardType: BoardType.all,
                                      boardInfo: null)),
                            );

                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          textInputAction: TextInputAction.search,
                          onSubmitted: (String text) {},
                          style: const TextStyle(
                            height: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 28, maxWidth: 28),
                            prefixIcon: SizedBox(
                              // 원하는 세로 크기
                              child: SvgPicture.asset(
                                'assets/icons/search.svg',
                                color: Colors.grey,
                                fit: BoxFit.contain,
                              ),
                            ),
                            hintText: '게시판, 게시글 및 댓글 검색',
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

                        /// ----------- TextField 아래
                        const SizedBox(
                          height: 21,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                FreeBulletinBoardPage(
                                    boardType: BoardType.all,
                                    boardInfo: null)));
                          },
                          child: SizedBox(
                            height: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/menu_1.svg',
                                  height: 32,
                                  width: 32,
                                  color: const Color(0xFFED3A3A),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  '전체보기',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                FreeBulletinBoardPage(
                                    boardType: BoardType.top,
                                    boardInfo: null)));
                          },
                          child: SizedBox(
                            height: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  height: 32,
                                  width: 32,
                                  color: const Color(0xFFED3A3A),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  '인기글',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                FreeBulletinBoardPage(
                                    boardType: BoardType.scraps,
                                    boardInfo: null)));
                          },
                          child: SizedBox(
                            height: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/download_2.svg',
                                  height: 32,
                                  width: 32,
                                  color: const Color(0xFFED3A3A),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  '담아둔 글',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          color: const Color(0xFFF0F0F0),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        BoardExpansionTile(1, "공지", boardsByGroup[1]),
                        BoardExpansionTile(5, "소통", boardsByGroup[5]),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(slideRoute(
                                  FreeBulletinBoardPage(
                                      boardType: BoardType.free,
                                      boardInfo: boardsByGroup[2][0])));
                            },
                            child: SizedBox(
                              height: 48,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/notify.svg',
                                    height: 32,
                                    width: 32,
                                    color: const Color(0xFF333333),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    boardsByGroup[2][0].ko_name,
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        BoardExpansionTile(3, "학생 단체 및 동아리", boardsByGroup[3]),
                        BoardExpansionTile(4, "거래", boardsByGroup[4]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class BoardExpansionTile extends StatelessWidget {
  final int titleNum;
  final String title;
  final List<BoardDetailActionModel> boardsByGroup;
  const BoardExpansionTile(this.titleNum, this.title, this.boardsByGroup,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent, // 액센트 색상을 투명으로 설정
        splashColor: Colors.transparent,
      ),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        child: ExpansionTile(
          // tilePadding: EdgeInsets.zero,
          title: SizedBox(
            height: 39,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 3,
                ),
                SvgPicture.asset(
                  'assets/icons/notify.svg',
                  height: 32,
                  width: 32,
                  color: const Color(0xFF333333),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          children: boardsByGroup.map<Widget>((model) {
            return SizedBox(
              height: 39,
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(slideRoute(
                          FreeBulletinBoardPage(
                              boardType: BoardType.free, boardInfo: model)));
                    },
                    child: Text(
                      model.ko_name,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
