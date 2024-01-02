import 'package:dio/dio.dart';

Dio createDioWithConfig() {
  final Dio dio = Dio();

  // 요청 시간 초과 설정 (예: 10초)
  dio.options.connectTimeout = const Duration(seconds: 5); // 밀리초 단위로 설정
  dio.options.receiveTimeout = const Duration(seconds: 3); // 밀리초 단위로 설정

  // 나머지 Dio 설정을 추가할 수 있습니다.

  return dio;
}