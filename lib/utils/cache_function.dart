import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///SharedPreferences를 이용해 데이터 저장( 키: api url, 값: api response)
Future<void> saveApiDataToCache(String key, dynamic data) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(data);
  await prefs.setString(key, jsonString);
}

///SharedPreferences를 이용해 데이터 불러오기( 키: api url, 값: api response)
Future<dynamic> loadApiDataFromCache(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(key);
  if (jsonString != null) {
    return jsonDecode(jsonString);
  }
  return null;
}

Future<void> getApiResCacheSetState(
    {required String apiUrl,
    required UserProvider userProvider,
    required Function callback}) async {
  try {
    final dynamic recentJson = await loadApiDataFromCache(apiUrl);
    if (recentJson != null) {
      await callback(recentJson);
    }
    final dynamic response = await userProvider.getApiRes(apiUrl);
    if (response != null) {
      await saveApiDataToCache(apiUrl, response);
      await callback(response);
    }
  } catch (error) {
    debugPrint("_getApiResCacheSetstate error: $error");
    // 적절한 에러 처리 로직 추가
  }
}
