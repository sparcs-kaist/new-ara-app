import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/constants/colors_info.dart';
import 'package:new_ara_app/pages/chat_window_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var chatPreviewList = [];
  // int count=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //totest: 채팅창 하나는 미리 추가해놓은 로직
    chatPreviewList.add(
      Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatWindowPage()),
              );
            },
            child: const SizedBox(
              height: 70,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 3),
                child: ChatPreview(),
              ),
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "appBar.chatting".tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.white,
            splashColor: Colors.white,
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsInfo.newara,
              width: 45,
              height: 45,
            ),
            onPressed: () {
              ///임시로 채팅 메세지 추가되는 로직을 위해 추가해둠.
              setState(() {
                chatPreviewList.insert(
                  0,
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatWindowPage()),
                          );
                        },
                        child: const SizedBox(
                          height: 70,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 3),
                            child: ChatPreview(),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: const Color(0xFFF0F0F0),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.builder(
            itemCount: chatPreviewList.length,
            itemBuilder: (BuildContext context, int index) {
              return chatPreviewList[index];
            },
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

class ChatPreview extends StatefulWidget {
  const ChatPreview({super.key});

  @override
  State<ChatPreview> createState() => _ChatPreviewState();
}

class _ChatPreviewState extends State<ChatPreview> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: Image.asset(
            "assets/icons/anonymous-profile.png",
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Text(
                        "카이스트 익명 밝 123 익명 123 익명 123 익명 123",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "20:22",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFFB1B1B1)),
                    ),
                  ],
                  //attachment_type
                ),
              ),
              SizedBox(
                height: 21,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "족보 구할 수 있을까요~ 족보 주세요 족봉!!!!!!!",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 21, // 원의 지름을 조절하기 위해 너비를 설정합니다.
                      height: 21, // 원의 지름을 조절하기 위해 높이를 설정합니다.
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // 컨테이너를 원 모양으로 만듭니다.
                        color: Color(0xFFED3A3A), // 원의 배경색을 지정합니다.
                      ),
                      child: const Center(
                        child: Text(
                          "3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
