/// Bridge protocol constants — keep in sync with
/// `new-ara-web-v2/src/app/web_view/_bridge/types.ts`.
///
/// Wire format (web → native): JSON string posted via the `FlutterChannel`
/// JS handler:
///   { v: 1, id?: string, type: string, payload?: any }
///
/// Wire format (native → web): a CustomEvent dispatched on `window`:
///   window.dispatchEvent(new CustomEvent('flutter:message', { detail: <envelope> }))
library;

const int kProtocolVersion = 1;

/// JS handler name registered on the InAppWebView. The web side calls
/// `window.FlutterChannel.postMessage(stringifiedEnvelope)`.
const String kJsHandlerName = 'FlutterChannel';

/// Name of the CustomEvent dispatched in the page when native sends a message.
const String kJsEventName = 'flutter:message';

/// Web → Native command types.
class BridgeCommand {
  static const ready = 'ready';
  static const log = 'log';
  static const goBack = 'goBack';
  static const exit = 'exit';
  static const setStatusBar = 'setStatusBar';
  static const setSafeArea = 'setSafeArea';
  static const openExternal = 'openExternal';
  static const share = 'share';
  static const pickImage = 'pickImage';
  static const pickFile = 'pickFile';
  static const requestPermission = 'requestPermission';
  static const getPushToken = 'getPushToken';
  static const subscribeTopic = 'subscribeTopic';
  static const unsubscribeTopic = 'unsubscribeTopic';
  static const setBadgeCount = 'setBadgeCount';
  static const haptic = 'haptic';
  static const clipboardWrite = 'clipboardWrite';
  static const clipboardRead = 'clipboardRead';
  static const setSession = 'setSession';
  static const clearSession = 'clearSession';
  static const reportHeight = 'reportHeight';
  /// Web tells the native shell that the pull-to-refresh refetch is finished.
  static const refreshDone = 'refreshDone';
}

/// Native → Web event types.
class BridgeEvent {
  static const ready = 'bridge:ready';
  static const backPressed = 'back:pressed';
  static const appStateChanged = 'appstate:changed';
  static const networkChanged = 'network:changed';
  static const keyboardChanged = 'keyboard:changed';
  static const pushReceived = 'push:received';
  static const pushOpened = 'push:opened';
  static const deeplinkReceived = 'deeplink:received';
  static const authExpired = 'auth:expired';
  /// User pulled the WebView down past the threshold; web should refetch.
  static const refreshRequested = 'refresh:requested';
}

/// Error codes used in `:error` envelopes.
class BridgeErrorCode {
  static const unsupported = 'unsupported';
  static const denied = 'denied';
  static const cancelled = 'cancelled';
  static const invalidPayload = 'invalid_payload';
  static const unavailable = 'unavailable';
  static const internal = 'internal';
}

class BridgeException implements Exception {
  final String code;
  final String message;
  BridgeException(this.code, this.message);
  @override
  String toString() => 'BridgeException($code): $message';
}
