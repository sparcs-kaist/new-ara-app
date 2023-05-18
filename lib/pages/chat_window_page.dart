import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class ChatWindowPage extends StatefulWidget {
  const ChatWindowPage({Key? key}) : super(key: key);

  @override
  State<ChatWindowPage> createState() => _ChatWindowPageState();
}

class _ChatWindowPageState extends State<ChatWindowPage> {
  var chatBubbleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i <= 3; i++) {
      chatBubbleList.add(const OtherChatBubble());
    }
    for (int i = 0; i <= 3; i++) {
      chatBubbleList.add(const MyChatBubble());
    }
    chatBubbleList.add(const TimeChatBubble());
    for (int i = 0; i <= 3; i++) {
      chatBubbleList.add(const MyChatBubble());
    }
    chatBubbleList.add(const TimeChatBubble());
    chatBubbleList.add(const TimeChatBubble());
    for (int i = 0; i <= 3; i++) {
      chatBubbleList.add(const OtherChatBubble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          ],
        ),
        title: const SizedBox(
          child: Text(
            '뉴아라 관리자',
            style: TextStyle(
              color: ColorsInfo.newara,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 14, 0),
                child: ListView.builder(
                  reverse: true,
                  itemCount: chatBubbleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    double bottomPadding = 0, topPadding = 0;
                    if (index == 0) {
                      bottomPadding = 17;
                    } else if (index >= 1) {
                      if (chatBubbleList[index - 1].runtimeType ==
                          chatBubbleList[index].runtimeType) {
                        bottomPadding = 5;
                      } else if (chatBubbleList[index - 1].runtimeType ==
                              TimeChatBubble ||
                          chatBubbleList[index].runtimeType == TimeChatBubble) {
                        bottomPadding = 30;
                      } else {
                        bottomPadding = 15;
                      }
                    }
                    if (index == chatBubbleList.length - 1) {
                      topPadding = 17;
                    }

                    return Padding(
                      padding:
                          EdgeInsets.fromLTRB(0, topPadding, 14, bottomPadding),
                      child: chatBubbleList[index],
                    );
                  },
                ),
              ),
            ),
            const DefaultInputArea(),
          ],
        ),
      ),
    );
  }
}

class DefaultInputArea extends StatefulWidget {
  const DefaultInputArea({
    super.key,
  });

  @override
  State<DefaultInputArea> createState() => _DefaultInputAreaState();
}

class _DefaultInputAreaState extends State<DefaultInputArea> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFF0F0F0),
        ),
        Container(
          constraints: const BoxConstraints(
            minHeight: 50.0, // 원하는 최소 높이 설정
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset('assets/icons/add-1.svg'),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),

                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 10.0, 10.0), // 모서리를 둥글게 설정
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
                  width: 7,
                ),
                SvgPicture.asset('assets/icons/send.svg'),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MyChatBubble extends StatelessWidget {
  const MyChatBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "10:40",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB1B1B1)),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFF7070), // 컨테이너 배경색
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0), // 좌상단 둥근 모서리 반지름
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(3.0), // 좌하단 둥근 모서리 반지름
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                child: Text(
                  "겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지끝",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtherChatBubble extends StatefulWidget {
  const OtherChatBubble({Key? key}) : super(key: key);

  @override
  State<OtherChatBubble> createState() => _OtherChatBubbleState();
}

class _OtherChatBubbleState extends State<OtherChatBubble> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle, // 컨테이너 배경색
              border: Border.all(
                color: const Color(0xFFD9D9D9), // 테두리 색상
                width: 1.0,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // 컨테이너 배경색
                      border: Border.all(
                        color: const Color(0xFFD9D9D9), // 테두리 색상
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(3),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                      child: Text(
                        "겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지1겁나긴 메세지끝",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "10:40",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB1B1B1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeChatBubble extends StatefulWidget {
  const TimeChatBubble({Key? key}) : super(key: key);

  @override
  State<TimeChatBubble> createState() => _TimeChatBubbleState();
}

class _TimeChatBubbleState extends State<TimeChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 컨테이너 배경색
          border: Border.all(
            color: const Color(0xFFFFADAD), // 테두리 색상
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        height: 24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "2022년 11월 24일",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFADAD),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
