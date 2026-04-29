import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bridge_protocol.dart';

/// Owns the WebView ↔ native message channel.
///
/// Each `InAppWebView` registers `FlutterChannel` and forwards `postMessage`
/// payloads here via [handleMessage]. We dispatch to the right handler and
/// (if the message had an `id`) post a `:result` / `:error` envelope back
/// using `evaluateJavascript`.
class BridgeController with WidgetsBindingObserver {
  BridgeController({required this.getWebView, this.getPullToRefresh});

  /// Lazily resolves the current InAppWebViewController. We don't hold a
  /// strong ref because the controller can change across hot reloads.
  final InAppWebViewController? Function() getWebView;

  /// Lazily resolves the current PullToRefreshController, if the shell
  /// installed one. Used so the `refreshDone` command from web can call
  /// `endRefreshing()` and dismiss the native spinner.
  final PullToRefreshController? Function()? getPullToRefresh;

  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  // ---------------------------------------------------------------------------
  // Web → Native
  // ---------------------------------------------------------------------------

  /// Called from the InAppWebView JS handler.
  Future<void> handleMessage(List<dynamic> args) async {
    if (args.isEmpty) return;
    final raw = args.first;
    if (raw is! String) {
      _logWarn('FlutterChannel: non-string payload ignored: $raw');
      return;
    }

    // Legacy strings: 'PostWritePageExit', 'meal_page_exit', a height string, etc.
    Map<String, dynamic> env;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        _logInfo('FlutterChannel(legacy): $raw');
        _handleLegacy(raw);
        return;
      }
      env = decoded;
    } catch (_) {
      _logInfo('FlutterChannel(legacy): $raw');
      _handleLegacy(raw);
      return;
    }

    if (env['v'] != kProtocolVersion) {
      _logWarn('Unsupported protocol version: ${env['v']}');
      return;
    }

    final id = env['id'] as String?;
    final type = env['type'] as String?;
    final payload = env['payload'];
    if (type == null) return;

    try {
      final result = await _dispatch(type, payload);
      if (id != null) {
        await _postBack(<String, dynamic>{
          'v': kProtocolVersion,
          'id': id,
          'type': '$type:result',
          if (result != null) 'payload': result,
        });
      }
    } on BridgeException catch (e) {
      if (id != null) {
        await _postBack(<String, dynamic>{
          'v': kProtocolVersion,
          'id': id,
          'type': '$type:error',
          'error': {'code': e.code, 'message': e.message},
        });
      }
    } catch (e, st) {
      _logWarn('bridge.$type threw: $e\n$st');
      if (id != null) {
        await _postBack(<String, dynamic>{
          'v': kProtocolVersion,
          'id': id,
          'type': '$type:error',
          'error': {
            'code': BridgeErrorCode.internal,
            'message': e.toString(),
          },
        });
      }
    }
  }

  void _handleLegacy(String raw) {
    // Best-effort routing for the existing string-only messages.
    if (raw == 'PostWritePageExit' || raw == 'meal_page_exit') {
      // In the new single-shell world there is no native page to pop; the web
      // owns navigation. We only emit a hint.
      _logInfo('legacy exit message: $raw');
      return;
    }
    final n = num.tryParse(raw);
    if (n != null) {
      // Treat as legacy HeightChannel report. No-op for now.
      return;
    }
  }

  Future<dynamic> _dispatch(String type, dynamic payload) async {
    switch (type) {
      case BridgeCommand.ready:
        await _emitReady(route: (payload as Map?)?['route'] as String?);
        return null;
      case BridgeCommand.log:
        final p = (payload as Map?) ?? const {};
        debugPrint('[web] ${p['level']}: ${p['message']}');
        return null;
      case BridgeCommand.goBack:
      case BridgeCommand.exit:
        // The shell owns the back stack; we let the web drive history.
        await _maybePopOrExit();
        return null;
      case BridgeCommand.openExternal:
        final url = (payload as Map?)?['url'] as String?;
        if (url == null) {
          throw BridgeException(BridgeErrorCode.invalidPayload, 'url required');
        }
        final ok = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        if (!ok) {
          throw BridgeException(BridgeErrorCode.unavailable, 'cannot open url');
        }
        return null;
      case BridgeCommand.haptic:
        final kind = (payload as Map?)?['kind'] as String?;
        switch (kind) {
          case 'light':
            await HapticFeedback.lightImpact();
            break;
          case 'medium':
            await HapticFeedback.mediumImpact();
            break;
          case 'heavy':
            await HapticFeedback.heavyImpact();
            break;
          case 'selection':
          default:
            await HapticFeedback.selectionClick();
        }
        return null;
      case BridgeCommand.clipboardWrite:
        final text = (payload as Map?)?['text'] as String?;
        if (text == null) {
          throw BridgeException(BridgeErrorCode.invalidPayload, 'text required');
        }
        await Clipboard.setData(ClipboardData(text: text));
        return null;
      case BridgeCommand.clipboardRead:
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        return {'text': data?.text ?? ''};
      case BridgeCommand.share:
        // OS share is wired up later via share_plus; surface as unsupported for now.
        throw BridgeException(BridgeErrorCode.unsupported, 'share not yet wired');
      case BridgeCommand.pickImage:
      case BridgeCommand.pickFile:
        // The web's <input type=file> picker is good enough for v1; native
        // picker delegation can be added later without changing the protocol.
        throw BridgeException(BridgeErrorCode.unsupported, 'use HTML <input type="file">');
      case BridgeCommand.requestPermission:
        // Camera / photos prompts are triggered by the OS when the WebView
        // file picker is invoked. Notifications permission requires the
        // push integration to be active; respond as denied/unsupported.
        return {
          'granted': false,
          'status': 'denied',
        };
      case BridgeCommand.getPushToken:
        // Stubbed until firebase_messaging is set up. Web should treat a null
        // token as "push not available yet".
        return {'token': null, 'platform': Platform.isIOS ? 'apns' : 'fcm'};
      case BridgeCommand.subscribeTopic:
      case BridgeCommand.unsubscribeTopic:
      case BridgeCommand.setBadgeCount:
        return null;
      case BridgeCommand.setSession:
      case BridgeCommand.clearSession:
        // Cookies live in the WebView cookie jar; we don't mirror them yet.
        return null;
      case BridgeCommand.setStatusBar:
      case BridgeCommand.setSafeArea:
      case BridgeCommand.reportHeight:
        return null;
      case BridgeCommand.refreshDone:
        getPullToRefresh?.call()?.endRefreshing();
        return null;
      default:
        throw BridgeException(BridgeErrorCode.unsupported, 'unknown command: $type');
    }
  }

  Future<void> _maybePopOrExit() async {
    final wv = getWebView();
    if (wv == null) return;
    if (await wv.canGoBack()) {
      await wv.goBack();
    } else {
      await SystemNavigator.pop();
    }
  }

  // ---------------------------------------------------------------------------
  // Native → Web
  // ---------------------------------------------------------------------------

  Future<void> emit(String type, [Map<String, dynamic>? payload]) async {
    await _postBack(<String, dynamic>{
      'v': kProtocolVersion,
      'type': type,
      if (payload != null) 'payload': payload,
    });
  }

  Future<void> _postBack(Map<String, dynamic> envelope) async {
    final wv = getWebView();
    if (wv == null) return;
    final json = jsonEncode(envelope);
    // The CustomEvent constructor signature differs between platforms; this
    // form is the safest cross-browser shape and works in WKWebView and
    // modern Android WebView.
    final js = '''
      (function(d){
        try {
          var detail = d;
          window.dispatchEvent(new CustomEvent('$kJsEventName', { detail: detail }));
        } catch (e) { console.warn('[bridge] dispatch failed', e); }
      })($json);
    ''';
    try {
      await wv.evaluateJavascript(source: js);
    } catch (e) {
      _logWarn('evaluateJavascript failed: $e');
    }
  }

  Future<void> _emitReady({String? route}) async {
    String appVersion = '0.0.0';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {}

    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    final padding = view?.padding;
    final dpr = view?.devicePixelRatio ?? 1.0;
    EdgeInsets safe = EdgeInsets.zero;
    if (padding != null) {
      safe = EdgeInsets.fromLTRB(
        padding.left / dpr,
        padding.top / dpr,
        padding.right / dpr,
        padding.bottom / dpr,
      );
    }

    final locale = PlatformDispatcher.instance.locale;

    await emit(BridgeEvent.ready, {
      'platform': Platform.isIOS ? 'ios' : 'android',
      'osVersion': Platform.operatingSystemVersion,
      'appVersion': appVersion,
      'locale': locale.toLanguageTag(),
      'safeArea': {
        'top': safe.top,
        'bottom': safe.bottom,
        'left': safe.left,
        'right': safe.right,
      },
    });
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final mapped = switch (state) {
      AppLifecycleState.resumed => 'foreground',
      AppLifecycleState.paused || AppLifecycleState.hidden => 'background',
      AppLifecycleState.inactive || AppLifecycleState.detached => 'inactive',
    };
    emit(BridgeEvent.appStateChanged, {'state': mapped});
  }

  // ---------------------------------------------------------------------------
  // Logging
  // ---------------------------------------------------------------------------

  void _logInfo(Object o) => debugPrint('[bridge] $o');
  void _logWarn(Object o) => debugPrint('[bridge][WARN] $o');
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
