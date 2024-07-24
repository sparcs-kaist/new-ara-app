import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/colors_info.dart';

const scrollDownLength = 30; //refresh를 위한 최소 픽셀
const displacementLength = 0.0; //위로부터의 default offset

/// Custom으로 scrollDownLength를 설정할 수 있는 위젯으로, RefreshIndicator.adaptive를 대체합니다.
///
/// !주의!
/// AlwaysScrollableScrollPhysics에
/// 'parent: BouncingScrollPhysics()'를 추가해야만 (iOS에서는 default) 안드로이드에서도 작동합니다.
///
/// [globalKey]는 페이지별 _refreshIndicatorKey 입니다.
/// ex) final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
///
/// [child]에는 기존의 child 중 RefreshIndicator.adaptive 이하 부분이 동일하게 들어갑니다.
///
/// [onRefresh]는 호출 후 method를 정의합니다.
NotificationListener<ScrollNotification> customRefreshIndicator(
    {required GlobalKey<RefreshIndicatorState> globalKey,
    required Widget child,
    double displacement = displacementLength,
    double edgeOffset = 0.0,
    required RefreshCallback onRefresh,
    Color? color = ColorsInfo.newara,
    Color? backgroundColor,
    ScrollNotificationPredicate notificationPredicate =
        defaultScrollNotificationPredicate,
    String? semanticsLabel,
    String? semanticsValue,
    double strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    RefreshIndicatorTriggerMode triggerMode =
        RefreshIndicatorTriggerMode.onEdge}) {
  //NotificationListener로 scroll 업데이트를 감지
  return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        //Custom trigger distance = - scrollDownLength
        if (notification is ScrollUpdateNotification &&
            notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels <= -1 * scrollDownLength) {
          //globalKey [refreshIndicatorKey]를 업데이트
          globalKey.currentState?.show();
        }
        return false;
      },
      child: RefreshIndicator.adaptive(
        key: globalKey,
        displacement: displacement,
        edgeOffset: edgeOffset,
        onRefresh: onRefresh,
        color: color,
        backgroundColor: backgroundColor,
        notificationPredicate: notificationPredicate,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        strokeWidth: strokeWidth,
        triggerMode: triggerMode, //globalKey에 따라 업데이트
        child: child,
        //Android에서도 작동하기 위해서 BouncingScrollPhysics() 필요
        /*
        예시:

        SingleChildScrollView(
            
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: child),

        */
      ));
}
