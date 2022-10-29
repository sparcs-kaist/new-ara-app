import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "appBar.chatting".tr(),
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined,
                color: ColorsInfo.newara, size: 28),
            onPressed: () {}, // 추후에 검색 기능 추가 필요
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Text('TBD'),
          ),
        ),
      ),
    );
  }
}
