import 'package:flutter/cupertino.dart';

Route slideRoute(Widget dst) {
  // iOS, Android에서 모두 back swipe 적용
  // TODO: Android에서 back swipe 적용할지 여부 논의 (2023.01.24)
  return CupertinoPageRoute(
    builder: (context) => dst,
  );
  // if (Platform.isIOS) {
  //   return CupertinoPageRoute(
  //     builder: (context) => dst,
  //   );
  // }
  // return PageRouteBuilder(
  //   pageBuilder: (context, animation, secondaryAnimation) => dst,
  //   transitionsBuilder: ((context, animation, secondaryAnimation, child) {
  //     var begin = const Offset(1, 0);
  //     var end = const Offset(0, 0);
  //     var curve = Curves.ease;

  //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //     var offsetAnimation = animation.drive(tween);
  //     return SlideTransition(
  //       position: offsetAnimation,
  //       child: child,
  //     );
  //   }),
  // );
}
