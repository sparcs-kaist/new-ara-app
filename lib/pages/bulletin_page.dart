import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:new_ara_app/constants/colors_info.dart';

class BulletinPage extends StatefulWidget {
  const BulletinPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'appBar.bulletin'.tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ColorsInfo.newara,
          ),
        ),
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
