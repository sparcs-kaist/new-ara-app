import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:new_ara_app/widgetclasses/loading_indicator.dart';
import 'package:new_ara_app/widgetclasses/post_preview.dart';
import 'package:provider/provider.dart';

class FreeBulletinBoardPage extends StatefulWidget {
  const FreeBulletinBoardPage({Key? key}) : super(key: key);

  @override
  State<FreeBulletinBoardPage> createState() => _FreeBulletinBoardPageState();
}

class _FreeBulletinBoardPageState extends State<FreeBulletinBoardPage> {
  List<Map<String, dynamic>> postPreviewList = [];
  int currentPage=1;

  Map<String, dynamic> testJson = {
    "id": 5689,
    "is_hidden": false,
    "why_hidden": [],
    "can_override_hidden": null,
    "parent_topic": null,
    "parent_board": {
      "id": 7,
      "created_at": "2020-09-01T16:37:47.576955+09:00",
      "updated_at": "2022-06-03T00:46:41.140645+09:00",
      "deleted_at": "0001-01-01T08:28:00+08:28",
      "slug": "talk",
      "ko_name": "자유게시판",
      "en_name": "Talk",
      "ko_description": "자유게시판",
      "en_description": "Talk",
      "read_access_mask": 222,
      "write_access_mask": 218,
      "comment_access_mask": 254,
      "is_readonly": false,
      "is_hidden": false,
      "name_type": 0,
      "is_school_communication": false,
      "group_id": 2,
      "banner_image":
          "https://sparcs-newara-dev.s3.amazonaws.com/board_banner_images/smalltalk-board-banner.jpg",
      "ko_banner_description": "",
      "en_banner_description": "",
      "banner_url": ""
    },
    "title": "123",
    "created_by": {
      "id": 857,
      "username": "abcbaa3c-d929-4092-af43-cdb9fabfca0d",
      "profile": {
        "picture":
            "https://sparcs-newara-dev.s3.amazonaws.com/user_profiles/pictures/AF9AA945-6AC2-4C53-9D27-F1B1A3EF707B.jpeg",
        "nickname": "열렬한 알파카",
        "user": 857,
        "is_official": false,
        "is_school_admin": false
      },
      "is_blocked": false
    },
    "read_status": "N",
    "attachment_type": "NONE",
    "communication_article_status": null,
    "days_left": null,
    "created_at": "2023-05-11T23:17:31.450816+09:00",
    "updated_at": "2023-05-12T11:48:24.620083+09:00",
    "deleted_at": "0001-01-01T08:28:00+08:28",
    "name_type": 0,
    "is_content_sexual": false,
    "is_content_social": false,
    "hit_count": 2,
    "comment_count": 0,
    "report_count": 0,
    "positive_vote_count": 0,
    "negative_vote_count": 0,
    "commented_at": null,
    "url": null,
    "content_updated_at": null,
    "hidden_at": null
  };
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var userProvider = context.read<UserProvider>();
    _scrollController.addListener(_scrollListener);
    refreshDailyBest(userProvider);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void refreshDailyBest(UserProvider userProvider) async {
    //example
    //프로바이더에 있는 정보 사용.
    var myMap = userProvider.getApiRes("articles/?parent_board=7&page=1");

    // api 호출과 Provider 정보 동기화.
    await userProvider.synApiRes(
        "articles/?parent_board=7&page=1", "articles/?parent_board=7&page=1");
    // await Future.delayed(Duration(seconds: 1));
    myMap = userProvider.getApiRes("articles/?parent_board=7&page=1");
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
      var myMap = userProvider.getApiRes("articles/?parent_board=7&page=$currentPage");

      // api 호출과 Provider 정보 동기화.
      await userProvider.synApiRes(
          "articles/?parent_board=7&page=$currentPage", "articles/?parent_board=7&page=$currentPage");
      // await Future.delayed(Duration(seconds: 1));
      myMap = userProvider.getApiRes("articles/?parent_board=7&page=$currentPage");
      if (mounted) {
        setState(() {
          // "is_hidden": true,
          // "why_hidden": [
          // "REPORTED_CONTENT"
          // ]
          for(int i=0 ; i< (myMap?["results"].length ?? 0 ); i++) {
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
        leading: IconButton(
          color: ColorsInfo.newara,
          icon: SvgPicture.asset('assets/icons/chevron-left.svg',
              color: ColorsInfo.newara, width: 10.7, height: 18.99),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const SizedBox(
          child: Text(
            '자유 게시판',
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
      body: isLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: postPreviewList.length, // 아이템 개수
                    itemBuilder: (BuildContext context, int index) {
                      // 각 아이템을 위한 위젯 생성
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
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
