import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UserTab extends StatefulWidget {
  final String tabText;
  const UserTab(this.tabText);
  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        widget.tabText.tr(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
