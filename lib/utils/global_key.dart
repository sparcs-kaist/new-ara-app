import 'package:flutter/material.dart';

/// snackBar를 생성할 때, buildContext를 참조할 필요가 없도록
/// globalKey를 설정합니다.
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();
