import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_ara_app/constants/colors_info.dart';

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
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(240, 240, 240, 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              highlightColor: Colors.white,
              splashColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                color: ColorsInfo.newara,
                width: 20,
                height: 20,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 20),
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
