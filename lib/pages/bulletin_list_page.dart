import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class BulletinListPage extends StatefulWidget {
  const BulletinListPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BulletinListPageState();
}

class _BulletinListPageState extends State<BulletinListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "appBar.bulletin".tr(),
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
            child: Text('TBㅇD'),
          ),
        ),
      ),
    );
  }
}
