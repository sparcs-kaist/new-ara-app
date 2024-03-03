import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/models/board_group_model.dart';
import 'package:new_ara_app/pages/bulletin_search_page.dart';
import 'package:new_ara_app/utils/cache_function.dart';
import 'package:provider/provider.dart';

import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/post_list_show_page.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgets/loading_indicator.dart';
import 'package:new_ara_app/models/board_detail_action_model.dart';
import 'package:new_ara_app/utils/slide_routing.dart';
import 'package:new_ara_app/providers/notification_provider.dart';

const boardsByGroupLength = 5;

/// `BulletinListPage`는 사용자가 이 페이지에서 다양한 게시판을 탐색하고 선택함..
class BulletinListPage extends StatefulWidget {
  const BulletinListPage({super.key});
  @override
  State<StatefulWidget> createState() => _BulletinListPageState();
}

class _BulletinListPageState extends State<BulletinListPage> {
  /// 데이터 로딩 상태
  bool isLoading = true;

  /// 게시판 그룹 별로 게시판 목록 저장하는 변수. 게시판 그룹은 1부터 시작하도록 초기화.
  List<List<BoardDetailActionModel>> boardsByGroup =
      List.generate(boardsByGroupLength + 1, (_) => []);
  List<BoardGroupModel> boardModels = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    refreshBoardList(userProvider);
    context.read<NotificationProvider>().checkIsNotReadExist(userProvider);
  }

  /// 게시판 목록을 새로고침하는 함수
  /// API를 호출하여 게시판 데이터를 가져온 후, 상태를 업데이트.
  void refreshBoardList(UserProvider userProvider) async {
    updateStateWithCachedOrFetchedApiData(
      apiUrl: "boards/", // API URL을 지정합니다. 이 예에서는 "boards/"를 대상으로 합니다.
      userProvider: userProvider, // API 요청을 담당할 userProvider 인스턴스를 전달합니다.
      // API 요청이 성공적으로 완료되었을 때 실행될 콜백 함수입니다.
      callback: (response) {
        // 현재 위젯이 마운트된 상태인지 확인합니다. 이는 setState를 안전하게 호출하기 위함입니다.
        if (mounted) {
          // 위젯의 상태를 업데이트합니다.
          setState(() {
            // 게시판 그룹 별로 게시판 목록을 저장하는 변수를 초기화합니다.
            boardsByGroup = List.generate(boardsByGroupLength + 1, (_) => []);
            // BoardDetailActionModel 객체를 저장할 리스트를 초기화합니다.
            List<BoardDetailActionModel> boardModels = [];
            // API 응답으로 받은 데이터를 반복하여 처리합니다.
            for (dynamic jsonBoard in response) {
              boardModels.add(BoardDetailActionModel.fromJson(
                  jsonBoard)); // JSON 데이터를 BoardDetailActionModel 객체로 변환하여 리스트에 추가합니다.
            }
            // 변환된 모델 객체들을 반복 처리합니다.
            for (BoardDetailActionModel model in boardModels) {
              // 각 모델을 해당하는 그룹 ID에 따라 분류하여 저장합니다.
              boardsByGroup[model.group.id].add(model);
            }
            // 데이터 로딩 상태를 false로 설정하여 로딩이 완료되었음을 나타냅니다.
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "board_list_page.게시판".tr(),
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
                        SizedBox(
                          height: 40,
                          child: TextField(
                            minLines: 1,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            focusNode: _focusNode,
                            onTap: () async {
                              // TODO: 검색 창 누를 때 실행되는 함수로 나중에 별로도 빼기
                              Navigator.of(context).push(slideRoute(
                                  const BulletinSearchPage(
                                      boardType: BoardType.all,
                                      boardInfo: null)));

                              FocusScope.of(context).requestFocus(FocusNode());
                            },

                            textInputAction: TextInputAction.search,
                            onSubmitted: (String text) {},
                            // style: const TextStyle(
                            //   height: 2,
                            //   fontSize: 16,
                            //   fontWeight: FontWeight.w500,
                            // ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF6F6F6),
                              isCollapsed: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.fromLTRB(
                                100.0,
                                10.0,
                                0,
                                10.0,
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                  maxHeight: 28, maxWidth: 36),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(6, 0, 2, 0),
                                child: SizedBox(
                                  // 원하는 세로 크기
                                  child: SvgPicture.asset(
                                    'assets/icons/search.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.grey, BlendMode.srcIn),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              hintText: 'board_list_page.게시판, 게시글 및 댓글 검색'.tr(),
                              hintStyle: const TextStyle(
                                color: Color(0xFFBBBBBB),
                                fontSize: 16,
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
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10.0),
                              //   borderSide: const BorderSide(
                              //     color: Colors.transparent, // 테두리 색상 설정
                              //   ), // 모서리를 둥글게 설정
                              // ),
                            ),
                            cursorColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        InkWell(
                          /// 전체 보기 클릭 시
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                const PostListShowPage(
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
                                  colorFilter: const ColorFilter.mode(
                                      Color(0xFFED3A3A), BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "board_list_page.전체보기".tr(),
                                  style: const TextStyle(
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
                          /// 인기글 클릭 시
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                const PostListShowPage(
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
                                  colorFilter: const ColorFilter.mode(
                                      Color(0xFFED3A3A), BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'board_list_page.인기글'.tr(),
                                  style: const TextStyle(
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
                          /// 스크랩 클릭 시
                          onTap: () {
                            Navigator.of(context).push(slideRoute(
                                const PostListShowPage(
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
                                  colorFilter: const ColorFilter.mode(
                                      Color(0xFFED3A3A), BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'board_list_page.담아둔 글'.tr(),
                                  style: const TextStyle(
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

                        BoardExpansionTile(1, boardsByGroup[1]),

                        /// 자유 게시판은 별도의 하위 목록이 없기에 따로 처리
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(slideRoute(
                                  PostListShowPage(
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
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFF333333), BlendMode.srcIn),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    context.locale == const Locale("ko")
                                        ? boardsByGroup[2][0].ko_name
                                        : boardsByGroup[2][0].en_name,
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        BoardExpansionTile(3, boardsByGroup[3]),
                        BoardExpansionTile(4, boardsByGroup[4]),
                        BoardExpansionTile(5, boardsByGroup[5]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// `BoardExpansionTile`는 게시판 그룹을 나타내는 확장 가능한 타일 위젯.
///
/// 이 위젯은 주어진 게시판 그룹의 제목과 해당 그룹에 속한 게시판 목록을 표시.
/// 사용자는 이 타일을 통해 원하는 게시판으로 이동 가능.
class BoardExpansionTile extends StatelessWidget {
  // TODO: titleNum이 필요한 이유 알기
  final int titleNum;
  final List<BoardDetailActionModel> boardsByGroup;

  /// [titleNum]은 게시판 그룹의 번호, [title]은 게시판 그룹의 제목,
  /// [boardsByGroup]은 해당 그룹에 속한 게시판 목록.
  const BoardExpansionTile(this.titleNum, this.boardsByGroup, {super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // 액센트 색상을 투명으로 설정
        splashColor: Colors.transparent,
      ),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        child: ExpansionTile(
          iconColor: Colors.black,
          collapsedIconColor: ColorsInfo.newara,
          initiallyExpanded: true,
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
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF333333), BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  context.locale == const Locale("ko")
                      ? boardsByGroup[0].group.ko_name
                      : boardsByGroup[0].group.en_name,
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
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(slideRoute(PostListShowPage(
                      boardType: BoardType.free, boardInfo: model)));
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      context.locale == const Locale("ko")
                          ? model.ko_name
                          : model.en_name,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
