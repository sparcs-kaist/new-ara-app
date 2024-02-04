import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/user_profile_model.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

/// `UserProvider`는 사용자 정보 및 연관된 API 로직을 관리하는 클래스입니다.
class UserProvider with ChangeNotifier {
  UserProfileModel? _naUser; // 사용자 정보 모델
  bool _hasData = false; // 사용자 정보 유무 플래그
  List<Cookie> _loginCookie = []; // 로그인 시 사용되는 쿠키
  // TODO: _apiRes가 필요한 이유 알아내기
  final Map<String, dynamic> _apiRes = {}; // API 응답 저장 맵
  bool _isWebViewLoaded = false;

  bool get isContentLoaded => _isWebViewLoaded;
  UserProfileModel? get naUser => _naUser;
  bool get hasData => _hasData;
  dynamic get apiRes => _apiRes;

  /// `_hasData`의 값을 설정하고 UI를 업데이트합니다.
  void setHasData(bool tf) {
    _hasData = tf;
    notifyListeners();
  }

  void setIsContentLoaded(bool tf, {bool quiet = false}) {
    _isWebViewLoaded = tf;
    if (!quiet) notifyListeners();
  }

  /// 문자열 쿠키를 Cookie 객체 리스트로 변환합니다.
  void setCookieToList(String cookieString) {
    _loginCookie.clear();
    List<String> tempCookieList = cookieString.split('; ');
    for (String cookie in tempCookieList) {
      List<String> cookieParts = cookie.split('=');
      String name = cookieParts[0];
      String value = cookieParts[1];
      _loginCookie.add(Cookie(name, value));
    }
  }

  /// 현재 저장된 쿠키 리스트를 문자열로 반환합니다.
  String getCookiesToString() {
    String cookieString = _loginCookie
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    return cookieString;
  }

  /// 지정된 URL의 웹뷰에서 쿠키를 가져와 저장합니다.
  Future<void> setCookiesFromUrl(url) async {
    _loginCookie = await WebviewCookieManager().getCookies(url);
    return;
  }

  /// /api/me 엔드포인트를 호출하여 사용자 정보를 갱신합니다.
  /// 실패 시 false, 성공 시 true 반환합니다.
  Future<bool> apiMeUserInfo({
    String initCookieString = "",
    String message = "",
  }) async {
    String cookieString = "ㅁ";
    String apiUrl = '$newAraDefaultUrl/api/me';

    if (initCookieString.isEmpty) {
      cookieString = _loginCookie
          .map((cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');
    } else {
      cookieString = initCookieString;
    }

    var dio = Dio();
    dio.options.headers['Cookie'] = cookieString;

    try {
      var response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        _naUser = UserProfileModel.fromJson(responseData);
        debugPrint("user_provider.dart($message) : $responseData");
        notifyListeners();
        return true;
      } else {
        debugPrint(
            'api/me request failed with status code: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unknown error: $e');
      return false;
    }
  }

  /// 주어진 쿠키 설정으로 Dio 객체를 초기화하고 반환합니다.
  Dio myDio({String? initCookieString}) {
    String cookieString = initCookieString ?? getCookiesToString();

    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = cookieString;

    return dio;
  }

  /// 지정된 API URL로 GET 요청을 전송하고 응답의 data를 반환합니다.
  /// 실패 시 null을 반환합니다.
  /// sendText는 개발자가 디버깅을 위한 문자열입니다.
  Future<dynamic> getApiRes(String apiUrl,
      {String? initCookieString, String? sendText}) async {
    String cookieString = initCookieString ?? getCookiesToString();
    var totUrl = "$newAraDefaultUrl/api/$apiUrl";

    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = cookieString;

    late dynamic response;
    try {
      response = await dio.get(totUrl);
      debugPrint("GET $totUrl success: ${response.data.toString()}");
      debugPrint("$sendText");
    } on DioException catch (e) {
      debugPrint("getApiRes failed with DioException: $e");
      // 서버에서 response를 보냈지만 invalid한 statusCode일 때
      if (e.response != null) {
        debugPrint("${e.response!.data}");
        debugPrint("${e.response!.headers}");
        debugPrint("${e.response!.requestOptions}");
      }
      // request의 setting, sending에서 문제 발생
      // requestOption, message를 출력.
      else {
        debugPrint("${e.requestOptions}");
        debugPrint("${e.message}");
      }
      return null;
    } catch (e) {
      debugPrint("_fetchUser failed with error: $e");
      return null;
    }
    return response.data;
  }

  Future<dynamic> postApiRes(String apiUrl,
      {dynamic payload, String? initCookieString}) async {
    String cookieString = initCookieString ?? getCookiesToString();
    String totUrl = "$newAraDefaultUrl/api/$apiUrl";

    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = cookieString;

    late dynamic response;
    try {
      response = await dio.post(totUrl, data: payload);
    } catch (error) {
      debugPrint("POST /api/$apiUrl failed with error: $error");
    }
    return response;
  }

  Future<dynamic> delApiRes(String apiUrl,
      {dynamic payload, String? initCookieString}) async {
    String cookieString = initCookieString ?? getCookiesToString();
    String totUrl = "$newAraDefaultUrl/api/$apiUrl";

    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = cookieString;

    late dynamic response;
    try {
      response = await dio.delete(totUrl, data: payload);
    } catch (error) {
      debugPrint("DELETE /api/$apiUrl failed with error: $error");
    }
    return response;
  }

  Future<dynamic> patchApiRes(String apiUrl,
      {dynamic payload, String? initCookieString}) async {
    String cookieString = initCookieString ?? getCookiesToString();
    String totUrl = "$newAraDefaultUrl/api/$apiUrl";

    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = cookieString;

    late dynamic response;
    try {
      response = await dio.patch(totUrl, data: payload);
    } catch (error) {
      debugPrint("PATCH /api/$apiUrl failed with error: $error");
    }
    return response;
  }
}
