import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Duration _araSnackBarDisplayDuration = Duration(milliseconds: 2500);

/// Ara 디자인에 맞는 SnackBar 위젯을 리턴하는 함수
/// Ara 디자인에 맞게 커스텀되어야 하는 파라미터는 기본값으로 지정되어 있음. 상황에 따라 변경하여 적용도 가능.
/// Overflow를 방지하기 위해 Flexible 활용하여 작성하는 것 추천.
/// 또한 여러 스낵바가 queued 되는 것을 방지하기 위해 기본 showSnackBar 대신 [hideOldsAndShowAraSnackBar] 사용 추천.
/// ```
/// hideOldsAndShowAraSnackBar(buildAraSnackBar(context,
///                       content: Row(
///                         children: [
///                           SvgPicture.asset(
///                             'assets/icons/information.svg',
///                             colorFilter: const ColorFilter.mode(
///                                 Colors.red, BlendMode.srcIn),
///                             width: 32,
///                             height: 32,
///                           ),
///                           const SizedBox(width: 8),
///                           const Flexible(
///                             child: Text(
///                               "본인 게시글이나 댓글에는 좋아요를 누를 수 없습니다!",
///                               overflow: TextOverflow.visible,
///                               style: TextStyle(
///                                 color: Colors.black,
///                                 fontWeight: FontWeight.w400,
///                                 fontSize: 15,
///                               ),
///                             ),
///                           ),
///                         ],
///                       )));
/// ```
SnackBar buildAraSnackBar(context,
    {Key? key,
    required Widget content,
    Color? backgroundColor = Colors.white, // ara specific
    double? elevation,
    EdgeInsetsGeometry? margin =
        const EdgeInsets.only(left: 16, right: 16, bottom: 20), // ara specific
    EdgeInsetsGeometry? padding =
        const EdgeInsets.only(top: 15, bottom: 15, left: 12), // ara specific
    double? width,
    ShapeBorder? shape = const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFF0F0F0), width: 0.5), // ara specific
        borderRadius: BorderRadius.all(Radius.circular(16))),
    SnackBarBehavior? behavior = SnackBarBehavior.floating, // ara specific
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

/// 기존에 존재하는 스낵바로 인해 새로 호출한 스낵바가 queued되었다가 나중에 표시되는 현상을 방지하기 위해 사용.
/// 새로운 스낵바 표시 전에 기존의 스낵바를 모두 숨김처리함.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> hideOldsAndShowAraSnackBar(context, SnackBar araSnackBar) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(araSnackBar);
}

/// information.svg와 함께 동일한 위젯 구성을 가진 SnackBar가 자주 사용되어
/// infoText만 전달하면 반복적으로 생성이 가능하도록 함수화함.
void showInfoBySnackBar(BuildContext context, String infoText) {
  // 이전에 존재하던 스낵바 제거
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(buildAraSnackBar(context,
      content: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/information.svg',
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              infoText,
              // 오버플로우 나면 다음줄로 넘어가도록 하기 위해
              overflow: TextOverflow.visible,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ],
      )));
}
