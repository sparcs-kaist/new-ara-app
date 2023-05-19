import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_ara_app/models/nauser_model.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';


//Provider.of<UserProvider>(context, listen: false).increment()
class UserProvider with ChangeNotifier {
  NAUser? _naUser;  // api/me 했을 때 받는 유저의 정보
  bool _hasData = false; // api/me 했을 때 유저의 정보가 있는가?
  List<Cookie> cookies=[];

  NAUser? get naUser => _naUser;
  bool get hasData => _hasData;

  void setHasData(bool tf) {
    _hasData=tf;
    notifyListeners();
  }
  Future<void> getCookies(url) async{
    cookies = await WebviewCookieManager().getCookies(url);
  }
  Future<void> apiMeUserInfo() async{
    //쿠키를 기반으로 api/me 해서 namodel 갱신하는 메소드

    // 쿠키를 문자열로 변환하여 HTTP 요청의 헤더에 추가
    String cookieString = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    debugPrint("cookieString $cookieString");
    // API 요청을 보낼 URL
    String apiUrl = 'https://newara.dev.sparcs.org/api/me';

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
      Map<String, dynamic> responseData =  jsonDecode(utf8.decode(response.bodyBytes));
      _naUser=NAUser.fromJson(responseData);
      // 유저 정보 출력
      //유저 정보를 사용하는 곳에서 재 실행!
      notifyListeners();
    } else {
      // 요청이 실패함 -> 유저가 로그아웃 된 상태 또는 인터넷 오류.
      print('api/me request failed with status code: ${response.statusCode}');
    }
  }

  void delUserInfo() {
    _naUser = null;
    _hasData = false;
    notifyListeners();
  }
}
