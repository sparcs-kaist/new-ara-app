import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:new_ara_app/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences를 이용하여 API 응답 데이터를 로컬 저장소에 저장합니다.
///
/// [key]는 API URL을 의미하며, [data]는 저장할 데이터입니다.
Future<void> cacheApiData(String key, dynamic data) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(data); // 데이터를 JSON 문자열로 인코딩
  await prefs.setString(key, jsonString); // JSON 문자열을 SharedPreferences에 저장
}

/// SharedPreferences를 통해 저장된 API 응답 데이터를 불러옵니다.
///
/// [key]는 불러올 데이터의 API URL을 의미합니다.
///
/// 저장된 데이터가 있다면 JSON으로 디코딩하여 반환하고, 없다면 null을 반환합니다.
Future<dynamic> fetchCachedApiData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString =
      prefs.getString(key); // SharedPreferences에서 JSON 문자열 불러오기
  if (jsonString != null) {
    return jsonDecode(jsonString); // JSON 문자열을 데이터로 디코딩
  }
  return null; // 저장된 데이터가 없을 경우 null 반환
}

/// API 응답을 캐시에서 불러오거나 API 응답을 새로 요청하여 상태를 업데이트하는 함수입니다.
/// API 응답을 새로 요청한다면 캐시에 저장하고, 콜백 함수를 통해 상태를 업데이트합니다.
///
/// [apiUrl]은 요청할 API의 URL입니다.
///
/// [userProvider]는 API 요청을 처리하는 UserProvider 인스턴스입니다.
///
/// [callback]은 데이터 처리를 위한 콜백 함수입니다.
/// 이 콜백 함수는 파라미터 한 개를 무조건 받아야하며 받은 파라미터를 가지고 상태를 업데이트합니다.
Future<void> updateStateWithCachedOrFetchedApiData({
  required String apiUrl,
  required UserProvider userProvider,
  required Function callback,
}) async {
  try {
    // 캐시에서 최근 JSON 데이터를 시도하여 불러옵니다.
    final dynamic recentJson = await fetchCachedApiData(apiUrl);
    if (recentJson != null) {
      // 캐시된 데이터가 있으면 콜백 함수를 통해 상태를 업데이트합니다.
      await callback(recentJson);
    }
    // UserProvider를 통해 API로부터 새로운 데이터를 요청합니다.
    Response? response = await userProvider.getApiRes(apiUrl);

    if (response != null) {
      // 새로운 데이터를 캐시에 저장하고, 콜백 함수를 통해 상태를 업데이트합니다.
      await cacheApiData(apiUrl, response.data);
      await callback(response.data);
    }
  } catch (error) {
    debugPrint("updateStateWithCachedOrFetchedApiData error: $error, apiurl: $apiUrl");
    // 에러 발생 시 적절한 에러 처리 로직을 추가합니다.
  }
}
