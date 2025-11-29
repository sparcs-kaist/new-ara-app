import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 학식 웹뷰를 미리 로드하고 캐싱하는 싱글톤 매니저
class MealWebViewManager {
  static final MealWebViewManager _instance = MealWebViewManager._internal();
  factory MealWebViewManager() => _instance;
  MealWebViewManager._internal();

  WebViewController? _controller;
  bool _isInitialized = false;
  bool _isLoading = true;
  final List<VoidCallback> _loadListeners = [];
  // 동적으로 변경 가능한 메시지 핸들러
  void Function(JavaScriptMessage)? _currentMessageHandler;

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  /// 웹뷰 컨트롤러 가져오기
  WebViewController? get controller => _controller;

  /// JavaScript 메시지 핸들러 설정 (동적으로 변경 가능)
  void setMessageHandler(void Function(JavaScriptMessage) handler) {
    _currentMessageHandler = handler;
    debugPrint('🍽️ MealWebView: Message handler updated');
  }

  /// 내부 메시지 라우터 (JavaScript 채널에서 호출)
  void _handleMessage(JavaScriptMessage message) {
    debugPrint(
        '🔥🔥 MealWebView: Received message in router: ${message.message}');
    if (_currentMessageHandler != null) {
      _currentMessageHandler!(message);
    } else {
      debugPrint('⚠️ MealWebView: No handler registered for message');
    }
  }

  /// 웹뷰 미리 로드 (앱 시작 시 호출)
  Future<void> preloadWebView() async {
    if (_isInitialized) {
      debugPrint('🍽️ MealWebView: Already initialized, skipping');
      return;
    }

    debugPrint('🍽️ MealWebView: Starting preload...');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('🍽️ MealWebView: Page started loading: $url');
            _isLoading = true;
          },
          onPageFinished: (String url) {
            debugPrint('🍽️ MealWebView: Page finished loading: $url');
            _isLoading = false;
            _notifyLoadListeners();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('🍽️ MealWebView error: ${error.description}');
          },
        ),
      )
      // JavaScript 채널을 내부 라우터로 등록 (한 번만 등록)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: _handleMessage,
      );

    debugPrint(
        '🍽️ MealWebView: JavaScript channel registered with internal router');

    // 웹뷰 로드 시작
    await _controller!.loadRequest(
      Uri.parse('https://newara.dev.sparcs.org/web_view/Meal'),
    );

    _isInitialized = true;
    debugPrint('🍽️ MealWebView: Preload initialized');
  }

  /// 로드 완료 리스너 추가
  void addLoadListener(VoidCallback listener) {
    _loadListeners.add(listener);
  }

  /// 로드 완료 리스너 제거
  void removeLoadListener(VoidCallback listener) {
    _loadListeners.remove(listener);
  }

  /// 로드 완료 알림
  void _notifyLoadListeners() {
    for (var listener in _loadListeners) {
      listener();
    }
  }

  /// 웹뷰 새로고침
  Future<void> reload() async {
    await _controller?.reload();
  }

  /// 웹뷰 정리 (필요시)
  void dispose() {
    _controller = null;
    _isInitialized = false;
    _isLoading = true;
    _loadListeners.clear();
    _currentMessageHandler = null;
    debugPrint('🍽️ MealWebView: Disposed');
  }
}
