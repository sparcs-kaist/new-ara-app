import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/nauser_model.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

//Provider.of<UserProvider>(context, listen: false).increment()
class UserProvider with ChangeNotifier {
  NAUserModel? _naUser; // api/me 했을 때 받는 유저의 정보
  bool _hasData = false; // api/me 했을 때 유저의 정보가 있는가?
  List<Cookie> _loginCookie = [];
  final Map<String, dynamic> _apiRes = {};

  NAUserModel? get naUser => _naUser;
  bool get hasData => _hasData;
  dynamic get apiRes => _apiRes;



  void setHasData(bool tf) {
    _hasData = tf;
    notifyListeners();
  }

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

  String getCookiesToString() {
    String cookieString = _loginCookie
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
    return cookieString;
  }

  Future<void> setCookiesFromUrl(url) async {
    //웹뷰에서 쿠키 가져와서 프로바이더에 저장하는 메소드.
    _loginCookie = await WebviewCookieManager().getCookies(url);
    return;
  }

  Future<bool> apiMeUserInfo(
      {String initCookieString = "", String message = ""}) async {
    //쿠키를 기반으로 api/me 해서 namodel 갱신하는 메소드
    //initCookieString 이 없으면 현재 프로바이더의 쿠키로 한다.

    dynamic cookieString = "ㅁ";
    String apiUrl = '$newAraDefaultUrl/api/me';

    if (initCookieString == "") {
      // 쿠키를 문자열로 변환하여 HTTP 요청의 헤더에 추가
      cookieString = _loginCookie
          .map((cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');
      // API 요청을 보낼 URL
    } else {
      cookieString = initCookieString;
    }
    // HTTP 요청을 위한 헤더 및 쿠키 추가
    Map<String, String> headers = {
      'Cookie': cookieString, // 쿠키 추가
    };

    // HTTP GET 요청 보내기
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // 요청이 성공적으로 처리됨
      //_naUser 모델에 요청값 입력.
      Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));

      _naUser = NAUserModel.fromJson(responseData);
      // 유저 정보 출력
      debugPrint("user_provider.dart($message) : $responseData");
      //유저 정보를 사용하는 곳에서 재 실행!
      notifyListeners();
      return true;
    } else {
      //401 Unauthorized
      // 요청이 실패함 -> 유저가 로그아웃 된 상태 또는 인터넷 오류.
      debugPrint(
          'api/me request failed with status code: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> synApiRes(String mapKey, {String? initCookieString,File? multipartFile}) async {
    //initCookieString 이 없으면 현재 프로바이더의 쿠키로 한다.

    String cookieString = "";
    //  String apiUrl = 'https://newara.dev.sparcs.org/api/me';
    var apiUrl = "$newAraDefaultUrl/api/$mapKey";
    if (initCookieString == null) {
      // 쿠키를 문자열로 변환하여 HTTP 요청의 헤더에 추가

      cookieString = _loginCookie
          .map((cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');
    } else {
      cookieString = initCookieString;
    }
    // HTTP 요청을 위한 헤더 및 쿠키 추가
    Map<String, String> headers = {
      'Cookie': cookieString, // 쿠키 추가
    };

    // HTTP GET 요청 보내기
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // 요청이 성공적으로 처리됨
      var responseData =
          jsonDecode(utf8.decode(response.bodyBytes));

      _apiRes[mapKey] = responseData;
     // debugPrint("user_provider.dart responseData: $responseData");

      //getApiRes 하는 곳에서 재 실행!
      notifyListeners();
      return true;
    } else {
      // 요청이 실패함
      debugPrint(
          '$apiUrl request failed with status code: ${response.statusCode}');
      return false;
    }
  }

  dynamic getApiRes(String mapKey) {
    if (_apiRes.containsKey(mapKey)) {
      return apiRes[mapKey];
    } else {
      return null;
    }
  }
}
