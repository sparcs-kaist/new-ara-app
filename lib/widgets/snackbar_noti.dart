import 'package:flutter/material.dart';

void showAraSnackBar(BuildContext context, Widget displayContent) {
  final araSnackBar = SnackBar(
    content: Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 34, child: displayContent),
    ),
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 12),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: Color(0xFFF0F0F0), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(16))),
  );

  ScaffoldMessenger.of(context).showSnackBar(araSnackBar);
}
