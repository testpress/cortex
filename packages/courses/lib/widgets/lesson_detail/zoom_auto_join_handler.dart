import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'zoom_web_view_config.dart';
import 'zoom_scripts.dart';

class ZoomAutoJoinHandler {
  WebViewController? _webViewController;
  bool _hasCompletedAutoJoin = false;
  bool _isDisposed = false;
  Timer? _fallbackTimer;

  final Function()? onJoinSuccess;
  final Function()? onJoinTimeout;
  final Function()? onLoadingStart;
  final Function()? onLoadingEnd;
  final Function()? onPermissionPermanentlyDenied;
  final Function()? onMeetingLeft;
  final Function(Object error, StackTrace stackTrace)? onError;
  final Duration fallbackTimeout;

  ZoomAutoJoinHandler({
    this.onJoinSuccess,
    this.onJoinTimeout,
    this.onLoadingStart,
    this.onLoadingEnd,
    this.onPermissionPermanentlyDenied,
    this.onMeetingLeft,
    this.onError,
    this.fallbackTimeout = const Duration(seconds: 8),
  });

  void attach(WebViewController controller) {
    _webViewController = controller;

    _webViewController?.addJavaScriptChannel(
      'ZoomAutoJoin',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message);
      },
    );

    _webViewController?.addJavaScriptChannel(
      'ZoomPermissionChannel',
      onMessageReceived: (JavaScriptMessage message) {
        if (message.message == 'onPermissionDenied') {
          onPermissionPermanentlyDenied?.call();
        }
      },
    );
  }

  /// Patches window.close and getUserMedia in the WebView.
  /// If Zoom tries to call window.close() upon leaving, it notifies Flutter.
  Future<void> _injectPermissionBridge() async {
    try {
      await _webViewController?.runJavaScript(ZoomScripts.permissionBridge);
    } catch (_) {
      // Safe to ignore if WebView was disposed while navigating away.
    }
  }

  void onPageStarted(String url) {
    if (!_hasCompletedAutoJoin) {
      onLoadingStart?.call();
    }
  }

  void onPageFinished(String url) {
    _hideScrollbars();
    _injectTouchOptimizations();
    _injectPermissionBridge();

    if (!_hasCompletedAutoJoin && isZoomJoinGateUrl(url)) {
      _autoJoinZoomMeetingWeb();
    } else {
      _cancelFallbackTimer();
      onLoadingEnd?.call();
      if (_hasCompletedAutoJoin) {
        onJoinSuccess?.call();
      }
    }
  }

  Future<void> _injectTouchOptimizations() async {
    try {
      await _webViewController?.runJavaScript(ZoomScripts.touchOptimizations);
    } catch (e, st) {
      onError?.call(e, st);
    }
  }

  Future<void> _hideScrollbars() async {
    try {
      await _webViewController?.runJavaScript(ZoomScripts.hideScrollbars);
    } catch (e, st) {
      onError?.call(e, st);
    }
  }

  bool isZoomJoinGateUrl(String? url) {
    if (url == null ||
        !ZoomWebViewConfig.isPermittedZoomUrl(url) ||
        ZoomWebViewConfig.isZoomExitUrl(url)) {
      return false;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path.toLowerCase();
    return path.contains('/j/') ||
        path.contains('/wc/') ||
        path.contains('/join');
  }

  Future<void> _autoJoinZoomMeetingWeb() async {
    try {
      await _webViewController?.runJavaScript(ZoomScripts.autoJoinMeeting);
    } catch (e, st) {
      onError?.call(e, st);
      onLoadingEnd?.call();
    }
  }

  void _startFallbackTimer() {
    _cancelFallbackTimer();
    _fallbackTimer = Timer(fallbackTimeout, () {
      if (!_isDisposed) {
        onLoadingEnd?.call();
      }
    });
  }

  void _cancelFallbackTimer() {
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
  }

  void _handleJavaScriptMessage(String message) {
    if (_isDisposed) return;

    if (message == 'onButtonClicked') {
      _hasCompletedAutoJoin = true;
      _startFallbackTimer();
    } else if (message == 'onMeetingDetected') {
      _hasCompletedAutoJoin = true;
      _cancelFallbackTimer();
      _injectTouchOptimizations();
      onLoadingEnd?.call();
      onJoinSuccess?.call();
    } else if (message == 'onAutoJoinTimeout') {
      _cancelFallbackTimer();
      onJoinTimeout?.call();
    } else if (message == 'onPermissionDenied') {
      onPermissionPermanentlyDenied?.call();
    } else if (message == 'onMeetingLeft') {
      onMeetingLeft?.call();
    }
  }

  @visibleForTesting
  void simulateJsMessage(String message) => _handleJavaScriptMessage(message);

  void reset() {
    _hasCompletedAutoJoin = false;
    _cancelFallbackTimer();
  }

  void dispose() {
    _isDisposed = true;
    _hasCompletedAutoJoin = false;
    _cancelFallbackTimer();
  }
}
