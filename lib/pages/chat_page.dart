import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_ara_app/constants/colors.dart';

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
          "chatting".tr(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
