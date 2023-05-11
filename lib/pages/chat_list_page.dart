import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/constants/colors_info.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
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
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Text('TBD'),
          ),
        ),
      ),
    );
  }
}
