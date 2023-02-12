import 'package:dio/dio.dart';

class DioInfo {
  static DioInfo? _instance;
  factory DioInfo() => _instance ??= DioInfo._internal();

  var _dio = Dio();
  get dio => _dio;

  DioInfo._internal();

  void updateOptions(String cookieStr, String csrftokenStr) {
    try {
      _dio.options
        ..headers['Cookie'] = cookieStr
        ..headers['X-CSRFToken'] = csrftokenStr;
    } catch (exception) {
      print('$exception');
    }
  }
}
