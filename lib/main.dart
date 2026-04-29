import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:new_ara_app/bridge/bridge_controller.dart';
import 'package:new_ara_app/bridge/bridge_protocol.dart';
import 'package:new_ara_app/constants/url_info.dart';

/// Entry point for the WebView-shell build of Ara.
///
/// The native side is intentionally tiny: load a single InAppWebView pointing
/// at `$newAraDefaultUrl/web_view/Main`, register the `FlutterChannel`
/// handler, and forward lifecycle/back events through the bridge. Everything
/// else lives in the Next.js app.
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  const String environment =
      String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: '.env.$environment');

  newAraDefaultUrl = dotenv.env['NEW_ARA_DEFAULT_URL']!;
  newAraAuthority = dotenv.env['NEW_ARA_AUTHORITY']!;
  sparcsSSODefaultUrl = dotenv.env['SPARCS_SSO_DEFAULT_URL']!;

  runApp(const AraWebShell());
}

class AraWebShell extends StatelessWidget {
  const AraWebShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ara',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const _WebShell(),
    );
  }
}

class _WebShell extends StatefulWidget {
  const _WebShell();

  @override
  State<_WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<_WebShell> {
  InAppWebViewController? _controller;
  late final BridgeController _bridge;
  late final PullToRefreshController _pullToRefresh;
  bool _firstFrameDone = false;

  @override
  void initState() {
    super.initState();
    _pullToRefresh = PullToRefreshController(
      // iOS-style spinner — a brand-red ring matching the rest of the UI.
      // The native side owns the *visual* of pull-to-refresh; the web
      // listens for `refresh:requested` and answers with `refreshDone`.
      settings: PullToRefreshSettings(
        color: const Color(0xFFED3A3A),
      ),
      onRefresh: () async {
        await _bridge.emit(BridgeEvent.refreshRequested);
      },
    );
    _bridge = BridgeController(
      getWebView: () => _controller,
      getPullToRefresh: () => _pullToRefresh,
    )..start();
  }

  @override
  void dispose() {
    _bridge.dispose();
    super.dispose();
  }

  Uri get _entryUri => Uri.parse('$newAraDefaultUrl/web_view/Main');

  InAppWebViewSettings get _settings => InAppWebViewSettings(
        // Cookies persist in the platform cookie store; nothing else to do.
        sharedCookiesEnabled: true,
        thirdPartyCookiesEnabled: true,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: false,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        useShouldOverrideUrlLoading: true,
        transparentBackground: false,
        // iOS: get rid of the "Done" accessory bar above the keyboard.
        disableInputAccessoryView: true,
        // Android keyboard handling: let the page's visualViewport drive layout.
        useHybridComposition: true,
        supportZoom: false,
        // We control the user-agent so the web can detect "in app".
        applicationNameForUserAgent: 'AraNative/1.0',
        // iOS edge-swipe back gesture — Flutter's CupertinoPageRoute had
        // it natively; without it the WebView feels "non-iOS".
        allowsBackForwardNavigationGestures: true,
      );

  Future<NavigationActionPolicy?> _onShouldOverride(
    InAppWebViewController controller,
    NavigationAction action,
  ) async {
    final url = action.request.url;
    if (url == null) return NavigationActionPolicy.ALLOW;

    final scheme = url.scheme;
    final isHttp = scheme == 'http' || scheme == 'https';
    final isOurHost = url.host == _entryUri.host;

    // 1. Tel / mail / market: hand off to the OS.
    if (!isHttp) {
      await _openExternal(url);
      return NavigationActionPolicy.CANCEL;
    }

    // 2. Off-domain http(s) navigations open in the system browser. SSO is
    //    in-flow (sparcs.org) so we whitelist a couple of hosts.
    final whitelist = <String>{
      _entryUri.host,
      Uri.tryParse(sparcsSSODefaultUrl)?.host ?? '',
      'sso.sparcs.org',
      'sso.kaist.ac.kr',
    }..removeWhere((s) => s.isEmpty);
    if (!isOurHost && !whitelist.contains(url.host)) {
      // Only redirect main-frame navigations the user explicitly triggered.
      if (action.isForMainFrame == true && action.navigationType != NavigationType.OTHER) {
        await _openExternal(url);
        return NavigationActionPolicy.CANCEL;
      }
    }

    return NavigationActionPolicy.ALLOW;
  }

  Future<void> _openExternal(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('openExternal failed: $e');
    }
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
    controller.addJavaScriptHandler(
      handlerName: kJsHandlerName,
      callback: (args) async {
        await _bridge.handleMessage(args);
      },
    );
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? url) {
    if (!_firstFrameDone) {
      _firstFrameDone = true;
      FlutterNativeSplash.remove();
    }
  }

  Future<bool> _onWillPop() async {
    final wv = _controller;
    if (wv == null) return true;
    if (await wv.canGoBack()) {
      await wv.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await _onWillPop();
        if (shouldExit && mounted) {
          // Last screen in the stack: actually exit the app on Android.
          if (Platform.isAndroid) {
            await SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // We let the WebView fill the whole screen; the web layout reads
        // safe-area insets via the bridge handshake and applies them itself.
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(_entryUri)),
          initialSettings: _settings,
          pullToRefreshController: _pullToRefresh,
          onWebViewCreated: _onWebViewCreated,
          shouldOverrideUrlLoading: _onShouldOverride,
          onLoadStop: _onLoadStop,
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          onConsoleMessage: (controller, msg) {
            debugPrint('[webview] ${msg.messageLevel}: ${msg.message}');
          },
        ),
      ),
    );
  }
}
