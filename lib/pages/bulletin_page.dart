import 'package:flutter/material.dart';

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
          '게시판',
          style: Theme.of(context).textTheme.headline1,
        ),
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
