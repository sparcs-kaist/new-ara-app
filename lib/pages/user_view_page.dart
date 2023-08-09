import 'package:flutter/material.dart';


class UserViewPage extends StatefulWidget {
  final int userID;

  const UserViewPage({super.key, required this.userID});

  @override
  State<UserViewPage> createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'USER_ID: ${widget.userID}',
        ),
      ),
    );
  }
}
