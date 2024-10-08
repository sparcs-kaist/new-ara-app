import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_ara_app/constants/url_info.dart';
import 'package:new_ara_app/models/user_profile_model.dart';
import 'package:new_ara_app/translations/locale_keys.g.dart';
import 'package:new_ara_app/utils/create_dio_with_config.dart';
import 'package:new_ara_app/utils/global_key.dart';
import 'package:new_ara_app/widgets/snackbar_noti.dart';
import 'package:path/path.dart';
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

  bool internetConnected = true; //인터넷 연결 여부 표시

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

  String getCsrftokenToString() {
    debugPrint(_loginCookie.toString());
    //Android 웹뷰 기준, ara dev 서버의 sso에서는 csrfoken을 주지 않지만, api 요청 시 사용하지 않으므로 ""를 반환한다.
    try {
      String csrfToken =
          _loginCookie.firstWhere((cookie) => cookie.name == 'csrftoken').value;
      return csrfToken;
    } catch (e) {
      debugPrint("getCsrftokenToString failed with error: $e");
    }
    return "";
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
  /// get 요청과 non-get 요청에 따라 다른 헤더 설정이 필요할 것을 대비하여 분리하여 설계하였음.
  Dio createDioWithHeadersForGet() {
    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = getCookiesToString();
    return dio;
  }

  Dio createDioWithHeadersForNonget() {
    Dio dio = createDioWithConfig();
    dio.options.headers['Cookie'] = getCookiesToString();
    dio.options.headers['X-Csrftoken'] = getCsrftokenToString();
    return dio;
  }

  /// get, post, patch, put 등 wrapper의
  /// error handling 방식을 통일합니다.
  void dioErrorHandling(DioException e) {
    late String errorMessage;
    if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = "DioException: Connection Time Out";
    } else if (e.type == DioExceptionType.sendTimeout) {
      errorMessage = "DioException: Send Time Out";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage = "DioException: Receive Time Out";
    } else if (e.type == DioExceptionType.badCertificate) {
      errorMessage = "DioException: Bad Certificate";
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = "DioException: Bad Response";
    } else if (e.type == DioExceptionType.cancel) {
      errorMessage = "DioException: Cancel";
    } else if (e.type == DioExceptionType.connectionError) {
      //와이파이 연결에 문제가 발생할 때 connectionError가 throw됨.
      errorMessage = "DioException: Connection Error";

      //이에 따라 인터넷 에러를 표시하는 snackBar 추가
      if (internetConnected) {
        // 첫 실행이라면
        internetConnected = false; // 이후 snackBar 생성하지 않음.
        showInternetErrorBySnackBar(LocaleKeys.userProvider_internetError.tr());
      }
    } else if (e.type == DioExceptionType.unknown) {
      errorMessage = "DioException: Unknown: ${e.message}";
    } else {
      // 이 case는 이론상 없어야 함. 추후 DioExceptionType이 dio package 버전에 따라 변경되었을 때를 대비해 넣어둠.
      errorMessage = "DioExceptionType enum에 정의되어있지 않은 오류 발생";
    }
    debugPrint(errorMessage);
    if (e.response != null) {
      //debugPrint("${e.response!.data}");
      debugPrint("${e.response!.headers}");
      debugPrint("${e.response!.requestOptions}");
    }
    // request의 setting, sending에서 문제 발생
    // requestOption, message를 출력.
    else {
      debugPrint("${e.requestOptions}");
      debugPrint("${e.message}");
    }
  }

  /// 지정된 API URL로 GET 요청을 전송하고 응답의 data를 반환합니다.
  ///
  /// 실패 시 null을 return하고, 오류 메시지를 debugPrint합니다.
  //
  /// path는 API 주소입니다.
  ///
  /// 사용 예시: await getApiRes('unregister', queryParameters:queryParameters);
  Future<Response<T>?> getApiRes<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var toUrl = "$newAraDefaultUrl/api/$path";
    Dio dio = createDioWithHeadersForGet();
    try {
      final response = await dio.get<T>(
        toUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      //인터넷 오류 snackBar 모두 지우기
      if (!internetConnected) snackBarKey.currentState?.clearSnackBars();

      internetConnected = true;

      return response;
    } on DioException catch (e) {
      debugPrint("Error occured in fetching : $toUrl");
      dioErrorHandling(e);
      return null;
    } catch (e) {
      debugPrint("오류 발생: ${e.toString()}");
      debugPrint("Error occured in fetching : $toUrl");
      return null;
      //throw Exception("Non-DioException occurred: ${e.toString()}");
    }
  }

  /// path에 주어진 경로와 data, queryParameters를 이용해 POST 요청을 보냄.
  /// 성공하면 Response 객체를 반환.
  /// 실패하면 내부에서 exception handling한 이후 null을 반환.
  Future<Response<T>?> postApiRes<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    String toUrl = "$newAraDefaultUrl/api/$path";
    Dio dio = createDioWithHeadersForNonget();
    try {
      final response = await dio.post<T>(toUrl,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      if (!internetConnected) snackBarKey.currentState?.clearSnackBars();
      internetConnected = true;

      return response;
    } on DioException catch (e) {
      debugPrint("Error occured in fetching : $toUrl");
      dioErrorHandling(e);
      return null;
    } catch (e) {
      debugPrint("오류 발생: ${e.toString()}");
      return null;
    }
  }

  /// path에 주어진 경로와 data, queryParameters를 이용해 PUT 요청을 보냄.
  /// 성공하면 Response 객체를 반환.
  /// 실패하면 내부에서 exception handling한 이후 null을 반환.
  Future<Response<T>?> putApiRes<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    String toUrl = "$newAraDefaultUrl/api/$path";
    Dio dio = createDioWithHeadersForNonget();
    try {
      final response = await dio.put<T>(toUrl,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      if (!internetConnected) snackBarKey.currentState?.clearSnackBars();
      internetConnected = true;

      return response;
    } on DioException catch (e) {
      debugPrint("Error occured in fetching : $toUrl");
      dioErrorHandling(e);
      return null;
    } catch (e) {
      debugPrint("오류 발생: ${e.toString()}");
      return null;
    }
  }

  /// path에 주어진 경로와 data, queryParameters를 이용해 PATCH 요청을 보냄.
  /// 성공하면 Response 객체를 반환.
  /// 실패하면 내부에서 exception handling한 이후 null을 반환.
  Future<Response<T>?> patchApiRes<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    String toUrl = "$newAraDefaultUrl/api/$path";
    Dio dio = createDioWithHeadersForNonget();
    try {
      final response = await dio.patch<T>(toUrl,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      if (!internetConnected) snackBarKey.currentState?.clearSnackBars();
      internetConnected = true;

      return response;
    } on DioException catch (e) {
      debugPrint("Error occured in fetching : $toUrl");
      dioErrorHandling(e);
      return null;
    } catch (e) {
      debugPrint("오류 발생: ${e.toString()}");
      return null;
    }
  }

  /// path에 주어진 경로와 data, queryParameters를 이용해 DELETE 요청을 보냄.
  /// 성공하면 Response 객체를 반환.
  /// 실패하면 내부에서 exception handling한 이후 null을 반환.
  Future<Response<T>?> delApiRes<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    String toUrl = "$newAraDefaultUrl/api/$path";
    Dio dio = createDioWithHeadersForNonget();
    try {
      final response = await dio.delete<T>(
        toUrl,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (!internetConnected) snackBarKey.currentState?.clearSnackBars();
      internetConnected = true;

      return response;
    } on DioException catch (e) {
      debugPrint("Error occured in fetching : $toUrl");
      dioErrorHandling(e);
      return null;
    } catch (e) {
      debugPrint("오류 발생: ${e.toString()}");
      return null;
    }
  }
}
