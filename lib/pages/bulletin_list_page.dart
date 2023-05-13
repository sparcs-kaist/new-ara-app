import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class BulletinListPage extends StatefulWidget {
  const BulletinListPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BulletinListPageState();
}

class _BulletinListPageState extends State<BulletinListPage> {
  List<Map<String, dynamic>> textContent = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textContent.add(
      {},
    );
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    minLines: 1,
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String text) {},
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
                  SizedBox(
                    height: 32,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 3,
                        ),
                        SvgPicture.asset('assets/icons/menu.svg'),
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 32,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 3,
                        ),
                        SvgPicture.asset('assets/icons/star.svg'),
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 32,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 3,
                        ),
                        SvgPicture.asset('assets/icons/download.svg'),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '담아놓은 글',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
                  Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent, // 액센트 색상을 투명으로 설정
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
                              SvgPicture.asset('assets/icons/notify.svg'),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '공지',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: <Widget>[
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '포털공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '운영진 공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '외주업체 공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent, // 액센트 색상을 투명으로 설정
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
                              SvgPicture.asset('assets/icons/notify.svg'),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '공지',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: <Widget>[
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '포털공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '운영진 공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 39,
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  '외주업체 공지',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
