import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;

  List<NotificationModel> _newNotiList = [];

  bool _isFetching = false;

  String _cookieString = "";

  void updateCookie(String newCookieString) {
    _cookieString = newCookieString;
  }

  Future<bool> _fetchNotifications() async {
    if (_cookieString == "") return false;
    _newNotiList.clear();
    var dio = Dio();
    dio.options.headers['Cookie'] = _cookieString;
    try {
      var response = await dio.get("$newAraDefaultUrl/api/notifications/?page=1");
      Map<String, dynamic> rawJson = response.data;
      List<dynamic> notificationsJson = rawJson['results'];
      for (Map<String, dynamic> json in notificationsJson) {
        try {
          var newNoti = NotificationModel.fromJson(json);
          _newNotiList.add(newNoti);
        } catch (error) {
          debugPrint("NotificationModel.fromJson failed id: ${json['id']}");
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
    bool fetchRes = await _fetchNotifications();
    if (!fetchRes) {
      _isFetching = false;
      return;
    }
    _notificationList = _newNotiList;
    notifyListeners();
    _isFetching = false;
  }
}
