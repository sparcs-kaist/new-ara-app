import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:new_ara_app/constants/colors_info.dart';

class MealWebViewPage extends StatefulWidget {
  const MealWebViewPage({super.key});

  @override
  State<MealWebViewPage> createState() => _MealWebViewPageState();
}

class _MealWebViewPageState extends State<MealWebViewPage>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeWebView();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _initializeWebView() {
    debugPrint('🔥🔥🔥 Initializing WebView...');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('🔥 Page started: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            debugPrint('🔥 Page finished: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('🔥🔥🔥 Message from WebView: ${message.message}');
          if (message.message == 'BackFromMeal' ||
              message.message == 'meal_page_exit') {
            debugPrint('🔥🔥🔥 Closing webview now!');
            _closeWithAnimation();
          }
        },
      )
      ..loadRequest(Uri.parse('https://newara.dev.sparcs.org/web_view/Meal'));
    
    debugPrint('🔥🔥🔥 WebView initialized with JavaScript channel');
  }

  Future<void> _closeWithAnimation() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 웹뷰에서 뒤로 갈 수 있는지 확인
        final canGoBack = await _controller.canGoBack();

        if (canGoBack) {
          // 웹뷰 내부에서 뒤로가기
          await _controller.goBack();
          return false;
        }

        // 더 이상 뒤로 갈 페이지가 없으면 앱 홈화면으로
        await _closeWithAnimation();
        return false;
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorsInfo.newara,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
