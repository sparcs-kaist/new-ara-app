// 'notification_provider.dart'
// [NotificationProvider]를 정의함.
// 새로운 알림이 생성되었는지 확인하고 구독 중인 리스너에게 알려주는 기능.
//
// Author: 김상오(alvin)

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:new_ara_app/providers/user_provider.dart';

/// 새로운 알림 여부를 알려주는 ChangeNotifier.
/// 알림 생성 여부가 필요한 다양한 위젯에 활용하기 위해 ChangeNotifier로 구현함.
/// 알림 생성 여부 조회를 위해 [checkIsNotReadExist] 메서드를 제공함.
class NotificationProvider with ChangeNotifier {
  bool _isNotReadExist = false;
  bool get isNotReadExist => _isNotReadExist;

  // ignore: unused_field
  String _cookieString = "";

  /// [checkIsNotReadExist] 속의 dio를 위한 쿠키를 설정해줌.
  void updateCookie(String newCookieString) {
    _cookieString = newCookieString;
  }

  /// _isNotReadExist를 변경하고 구독중인 위젯에 알림.
  /// NotificationPage의 알림 모두 읽기 기능에 사용됨.
  void setIsNotReadExist(bool value) {
    _isNotReadExist = value;
    notifyListeners();
  }

  /// NewAra API로 요청을 보내 알림을 받음.
  /// 받은 알림 별로 읽음 여부를 확인하여 isNotReadExist 변수를 설정함.
  /// 구독 중인 리스너에게 isNotReadExist 결과를 알려줌.
  /// 페이지가 전환될 때마다 전환되는 페이지의 initState에서 호출됨.
  /// UserProvider는 createDioWithHeaders 함수를 쓰기 위해 사용됨.
  Future<void> checkIsNotReadExist(UserProvider userProvider) async {
    bool res = false;

    int curPage = 1;

    /// 다음 페이지가 존재하는 지 나타냄.
    bool hasNext = false;
    // TODO: res = true일 때 do while 문에도 break 걸기 (Resolved)
    do {
      try {
        var response =
            await userProvider.getApiRes("notifications/?page=$curPage");
        final Map<String, dynamic>? jsonList = await response?.data;

        hasNext = jsonList?["next"] == null ? false : true; // 다음 페이지 존재 확인.
        List<dynamic> resultsJson = jsonList?["results"];
        for (var json in resultsJson) {
          if (!(json['is_read'] ?? true)) {
            res = true;
            break;
          }
        }
        if (res) break;
      } catch (error) {
        /* dio.get 과정에서 발생한 에러에 대한 예외처리.
           해당 경우에 새로운 알림이 존재하는 것으로 가정. */
        debugPrint("$error");
        res = true;
        break;
      }
      curPage += 1;
    } while (hasNext);

    _isNotReadExist = res;
    notifyListeners();
  }
}
