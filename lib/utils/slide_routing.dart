import 'package:flutter/material.dart';

Route slideRoute(Widget dst) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => dst,
    transitionsBuilder: ((context, animation, secondaryAnimation, child) {
      var begin = const Offset(1, 0);
      var end = const Offset(0, 0);
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    }),
  );
}
