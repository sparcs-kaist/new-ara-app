import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user_info'.tr(),
            style: Theme.of(context).textTheme.headline1),
      ),
    );
  }
}
