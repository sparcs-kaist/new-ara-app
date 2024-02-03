import 'package:flutter/material.dart';

void showAraSnackBar(BuildContext context, Widget displayContent) {
  final araSnackBar = SnackBar(
    content: Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 34, child: displayContent),
    ),
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
  );
  ScaffoldMessenger.of(context).showSnackBar(araSnackBar);
}
