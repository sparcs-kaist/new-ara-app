import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/colors_info.dart';

const scrollDownLength = 30.0; // refresh를 위한 최소 픽셀
const displacementLength = 0.0; // 위로부터의 default displacement
const offsetLength = 5.0; // 위/아래의 default offset
const indicatorRadius = 15.0; // 원의 default radius

/// Custom으로 scrollDownLength를 설정할 수 있는 위젯으로, [RefreshIndicator.adaptive]를 대체합니다.
///
/// !주의!
/// [AlwaysScrollableScrollPhysics]에
/// 'parent: [BouncingScrollPhysics]'를 추가해야만 (iOS에서는 default) 안드로이드에서도 작동합니다.
///
/// [child]에는 기존의 child 중 [RefreshIndicator.adaptive] 이하 부분이 동일하게 들어갑니다.
///
/// [onRefresh]는 호출 후 method를 정의합니다.
class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final double triggerDistance;
  final double displacement;
  final double edgeOffset;
  final Color? color;
  final Color? backgroundColor;
  final double radius;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = scrollDownLength, // Pull Down의 최소 길이
    this.displacement = displacementLength,
    this.edgeOffset = offsetLength,
    this.color = ColorsInfo.newara,
    this.backgroundColor, // CupertinoActivityIndicator()에서는 사용되지 않음
    this.radius = indicatorRadius,
  });

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

// 애니메이션을 위한 state
class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _positionController;
  late AnimationController _scaleController;

  bool _isRefreshing = false; // Refresh 중복 방지용
  bool _isDragging = false; // drag 감지
  double _dragOffset = 0.0; // drag 좌표

  @override
  void initState() {
    super.initState();

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NotificationListener로 scroll 업데이트를 감지
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          widget.child,
          if (_isDragging || _isRefreshing) _buildRefreshIndicator(),
        ],
      ),
    );
  }

  // 실제 LoadingIndicator build 과정
  Widget _buildRefreshIndicator() {
    return Positioned(
      top: widget.displacement * _positionController.value,
      left: 0,
      right: 0,
      child: SizeTransition(
        axisAlignment: -1.0, // 중복 애니메이션 방지
        sizeFactor: _scaleController,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: widget.edgeOffset),
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(
            // 편의상 iOS, Android 통일 (maybe TODO)
            color: widget.color,
            radius: widget.radius,
          ),
        ),
      ),
    );
  }

  // ScrollNotification을 Listen하여 처리
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    // Scroll 시작
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0) {
      setState(() {
        _isDragging = true;
        _dragOffset = 0.0;
        _scaleController.value = 0.0;
      });
      return false;
    }

    // drag를 계속 한다면
    if (notification is ScrollUpdateNotification && _isDragging) {
      if (notification.metrics.extentBefore > 0.0) return false;
      if (notification.scrollDelta == null) return false;

      setState(() {
        // Offset을 scrollDelta만큼 변형
        _dragOffset -= notification.scrollDelta!;
        if (_dragOffset > widget.triggerDistance) {
          _startRefresh();
        } else if (_dragOffset > 0) {
          _positionController.value = _dragOffset / widget.triggerDistance;
          _scaleController.value = _positionController.value;
        }
      });
      return false;
    }

    // scroll 범위를 벗어났다면
    if (notification is OverscrollNotification && _isDragging) {
      setState(() {
        _dragOffset += notification.overscroll.abs() / 2;
        if (_dragOffset > widget.triggerDistance) {
          _startRefresh();
        } else if (_dragOffset > 0) {
          _positionController.value = _dragOffset / widget.triggerDistance;
          _scaleController.value = _positionController.value;
        }
      });
      return false;
    }

    // scroll이 끝났다면
    if (notification is ScrollEndNotification && _isDragging) {
      setState(() {
        _isDragging = false;
        // Refresh가 끝났다면 원위치로 복귀
        if (!_isRefreshing) _reset();
      });
      return false;
    }

    return false;
  }

  // onRefresh() 실행 (_isRefreshing으로 중복 방지)
  void _startRefresh() {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });

    _positionController.animateTo(1.0,
        duration: const Duration(milliseconds: 200));
    _scaleController.animateTo(1.0,
        duration: const Duration(milliseconds: 200));

    widget.onRefresh().whenComplete(() {
      setState(() {
        _isRefreshing = false;
      });
      _reset();
    });
  }

  // 리셋(다시 맨 위로 복귀)
  void _reset() {
    _dragOffset = 0.0;
    _positionController.animateTo(0.0,
        duration: const Duration(milliseconds: 200));
    _scaleController.animateTo(0.0,
        duration: const Duration(milliseconds: 200));
  }
}
//Android에서도 작동하기 위해서 BouncingScrollPhysics() 필요
/*
예시:
SingleChildScrollView(
  physics: const AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics()),
  child: child),
*/