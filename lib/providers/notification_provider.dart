import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  int _page = 1;

  int _maxPage = 1;

  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;

  List<NotificationModel> _newNotiList = [];

  bool _isFetching = false;

  String _cookieString = "";

  void updateCookie(String newCookieString) {
    _cookieString = newCookieString;
  }

  void nextPage() {
    if (_page + 1 <= _maxPage) _page += 1;
  }

  void resetPage() {
    _page = 1;
  }

  Future<bool> _fetchNotifications(int maxPage) async {
    if (_cookieString == "") return false;
    _newNotiList.clear();
    var dio = Dio();
    dio.options.headers['Cookie'] = _cookieString;
    try {
      for (int i = 1; i <= maxPage; i++) {
        var response = await dio.get("$newAraDefaultUrl/api/notifications/?page=$i");
        Map<String, dynamic> rawJson = response.data;
        _maxPage = max(_maxPage, rawJson['num_pages']);  // 최대 페이지 갱신
        List<dynamic> notificationsJson = rawJson['results'];
        for (Map<String, dynamic> json in notificationsJson) {
          try {
            var newNoti = NotificationModel.fromJson(json);
            _newNotiList.add(newNoti);
          } catch (error) {
            debugPrint("NotificationModel.fromJson failed id: ${json['id']}");
          }
        }
      }
    } catch (error) {
      debugPrint("GET /api/notifications failed: $error");
      return false;
    }
    return true;
  }

  Future<void> instantNotificationFetch() async {
    if (_isFetching) return;
    _isFetching = true;
    bool fetchRes = await _fetchNotifications(_page);
    if (!fetchRes) {
      _isFetching = false;
      return;
    }
    _notificationList = _newNotiList;
    notifyListeners();
    _isFetching = false;
  }

  void periodicNotificationFetch() {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (_isFetching) return;
      _isFetching = true;
      bool fetchRes = await _fetchNotifications(_page);
      if (!fetchRes) {
        _isFetching = false;
        return;
      }
      _notificationList = _newNotiList;
      notifyListeners();
      debugPrint("Periodic Alarm Fetching Succeed");
      _isFetching = false;
      //debugPrint("num: $_num");
    });
  }
}
