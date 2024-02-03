import 'package:flutter/material.dart';

const Duration _araSnackBarDisplayDuration = Duration(seconds: 4);

/// Ara 디자인에 맞는 SnackBar 위젯을 리턴하는 함수
/// Ara 디자인에 맞게 커스텀되어야 하는 파라미터는 기본값으로 지정되어 있음. 상황에 따라 변경하여 적용도 가능
/// ```
/// ScaffoldMessengar.of(context).showSnackBar(
///     buildAraSnackBar(context, Text('hello world'))
/// );
/// ```
SnackBar buildAraSnackBar(context,
    {Key? key,
    required Widget content,
    Color? backgroundColor = Colors.white,  // ara specific
    double? elevation,
    EdgeInsetsGeometry? margin =
        const EdgeInsets.only(left: 16, right: 16, bottom: 20),  // ara specific
    EdgeInsetsGeometry? padding =
        const EdgeInsets.only(top: 15, bottom: 15, left: 12),  // ara specific
    double? width,
    ShapeBorder? shape = const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFF0F0F0), width: 0.5),  // ara specific
        borderRadius: BorderRadius.all(Radius.circular(16))),
    SnackBarBehavior? behavior = SnackBarBehavior.floating,  // ara specific
    SnackBarAction? action,
    double? actionOverflowThreshold,
    bool? showCloseIcon,
    Color? closeIconColor,
    Duration duration = _araSnackBarDisplayDuration,
    Animation<double>? animation,
    VoidCallback? onVisible,
    DismissDirection dismissDirection = DismissDirection.down,
    Clip clipBehavior = Clip.hardEdge}) {
  return SnackBar(
    key: key,
    content: Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 34, child: content),
    ),
    backgroundColor: backgroundColor,
    elevation: elevation,
    margin: margin,
    padding: padding,
    width: width,
    shape: shape,
    behavior: behavior,
    action: action,
    actionOverflowThreshold: actionOverflowThreshold,
    showCloseIcon: showCloseIcon,
    duration: duration,
    animation: animation,
    onVisible: onVisible,
    dismissDirection: dismissDirection,
    clipBehavior: clipBehavior,
  );
}