import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/board_type.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';


class FreeBulletinBoardPage extends StatefulWidget {
  final Map<String,dynamic>? boardInfo;
  final BoardType boardType;
  const FreeBulletinBoardPage({super.key, required this.boardType , required this.boardInfo});

  @override
  State<FreeBulletinBoardPage> createState() => _FreeBulletinBoardPageState();
}

class _FreeBulletinBoardPageState extends State<FreeBulletinBoardPage> {
  List<Map<String, dynamic>> postPreviewList = [];
  int currentPage=1;
  bool isLoading = true;
  String apiUrl = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.boardType == BoardType.free) {
      apiUrl = "articles/?parent_board=${this.widget.boardInfo!["id"]}&page=";
    }
    else if(widget.boardType == BoardType.recent){
      apiUrl = "articles/recent/?page=";
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
    //example
    //프로바이더에 있는 정보 사용.
    // api 호출과 Provider 정보 동기화.

    //https://newara.dev.sparcs.org/api/articles/recent/?page=1
    //                                  articles/?parent_board=${this.widget.boardInfo["id"]}&page=1
    await userProvider.synApiRes(
        "${apiUrl}1");
    // await Future.delayed(Duration(seconds: 1));
    var myMap = userProvider.getApiRes("${apiUrl}1");
    if (mounted) {
      setState(() {
        postPreviewList.clear();
        for(int i=0 ; i< (myMap?["results"].length ?? 0 ); i++) {
          postPreviewList.add(myMap?["results"][i] ?? {});
        }
        isLoading = false;
      });
    }
  }
  void _scrollListener() async{
    var userProvider = context.read<UserProvider>();
   if (_scrollController.position.pixels  == _scrollController.position.maxScrollExtent ) {
      currentPage=currentPage+1;
      // api 호출과 Provider 정보 동기화.
      await userProvider.synApiRes(
          "$apiUrl$currentPage");
      // await Future.delayed(Duration(seconds: 1));
      var myMap = userProvider.getApiRes("$apiUrl$currentPage");
      if (mounted) {
        setState(() {
          // "is_hidden": true,
          // "why_hidden": [
          // "REPORTED_CONTENT"
          // ]
          for(int i=0 ; i< (myMap?["results"].length ?? 0 ); i++) {

            //???/
            if(myMap["results"][i]["created_by"]["profile"]!=null && myMap["results"][i]["is_hidden"]==false) {
              postPreviewList.add(myMap?["results"][i] ?? {});
            }
          }
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  child: SvgPicture.asset('assets/icons/chevron-left.svg',
                    color: ColorsInfo.newara,
                    fit: BoxFit.fill,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Text("게시판",style: TextStyle(
              color: Color(0xFFED3A3A),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),),
          ],
        ),
        title: SizedBox(
          child: Text(
            this.widget.boardInfo?["ko_name"] ?? "실시간 인기글",
            style: TextStyle(
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
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // FloatingActionButton을 누를 때 실행될 동작을 정의합니다.
              debugPrint('FloatingActionButton pressed');
            },
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 42,
              height: 42,
              child: SvgPicture.asset(
                'assets/icons/modify.svg',
                fit: BoxFit.fill,
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
                      return postPreviewList[index]["is_hidden"]? Container() : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: PostPreview(json: postPreviewList[index]),
                          ),
                          Container(
                            height: 1,
                            color: const Color(0xFFF0F0F0),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
