import 'package:flutter/material.dart';

import 'package:new_ara_app/dio_info.dart';
import 'package:new_ara_app/models/nauser.dart';
import 'package:new_ara_app/constants/constants.dart';

class UserModel with ChangeNotifier {
  NAUser? _naUser;
  NAUser? get naUser => _naUser;
  bool _hasData = false;
  bool get hasData => _hasData;

  Future<void> getUserInfo() async {
    try {
      final response = await DioInfo().dio.get("${UrlInfo.BASE_URL}/me");
      _naUser = NAUser.fromJson(response.data);
      _hasData = true;
      notifyListeners();
    } catch (exception) {
      debugPrint(
          '*******************************************\n getUserInfo Exception: $exception *******************************************\n');
    }
  }

  void delUserInfo() {
    _naUser = null;
    _hasData = false;
    notifyListeners();
  }
}
