import 'package:flutter/material.dart';

void showAraSnackBar(BuildContext context, String displayContent) {
  final araSnackBar = SnackBar(
    content: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: const Color(0xFFF0F0F0),
          width: 0.5,
        ),
      ),
      width: 358,
      height: 30,
      child: Text(
        displayContent,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
  );
  ScaffoldMessenger.of(context).showSnackBar(araSnackBar);
}
