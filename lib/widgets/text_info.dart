import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final String infoStr;
  const TextInfo(this.infoStr, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Text(
        infoStr,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(191, 191, 191, 1)),
      ),
    );
  }
}
