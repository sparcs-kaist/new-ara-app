import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final String info_str;
  const TextInfo(this.info_str);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: Text(
        info_str,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(191, 191, 191, 1)),
      ),
    );
  }
}
