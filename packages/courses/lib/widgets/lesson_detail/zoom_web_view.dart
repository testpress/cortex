import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:core/core.dart';

class ZoomPermissionHandler {
  static Future<bool> checkAndRequestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
    ];

    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }
}

class ZoomWebViewConfig {
  static const String desktopUserAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36";

  static Future<void> setupWebViewSettings(
      WebViewController controller, BuildContext context) async {
    final design = Design.of(context);
    await Future.wait([
      controller.setUserAgent(desktopUserAgent),
      controller.setBackgroundColor(design.colors.canvas),
    ]);

    if (await controller.supportsSetScrollBarsEnabled()) {
      await Future.wait([
        controller.setVerticalScrollBarEnabled(false),
        controller.setHorizontalScrollBarEnabled(false),
      ]);
    }
  }

  static String buildZoomWebClientUrl({
    required String? conferenceId,
    required String? password,
    required String? displayName,
    required String? fallbackUrl,
  }) {
    if (conferenceId != null && conferenceId.trim().isNotEmpty) {
      final sanitizedId = conferenceId.replaceAll(RegExp(r'\s+'), '');
      final uri = Uri.parse('https://app.zoom.us/wc/$sanitizedId/join');
      final params = <String, String>{};
      if (password != null && password.isNotEmpty) {
        params['pwd'] = password;
      }
      if (displayName != null && displayName.isNotEmpty) {
        params['uname'] = displayName;
      }
      return uri.replace(queryParameters: params).toString();
    }
    return fallbackUrl ?? '';
  }

  /// Restricts top-level navigation exclusively to legitimate Zoom meeting endpoints.
  /// Prevents external redirection to the Play Store, App Store, or non-meeting pages.
  static bool isPermittedZoomUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Only allow standard web protocols
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return false;
    }

    final host = uri.host.toLowerCase();
    final isZoomHost = host == 'zoom.us' ||
        host.endsWith('.zoom.us') ||
        host == 'zoomgov.com' ||
        host.endsWith('.zoomgov.com');

    if (!isZoomHost) {
      return false;
    }

    // Only allow meeting-related paths. Everything else on zoom.us
    // (privacy policy, terms, legal, marketing, etc.) is blocked.
    final path = uri.path.toLowerCase();
    final isMeetingPath = path.startsWith('/j/') ||
        path.startsWith('/wc/') ||
        path.startsWith('/join') ||
        path.startsWith('/s/');

    return isMeetingPath;
  }
}

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
  final Function(Object error, StackTrace stackTrace)? onError;
  final Duration fallbackTimeout;

  ZoomAutoJoinHandler({
    this.onJoinSuccess,
    this.onJoinTimeout,
    this.onLoadingStart,
    this.onLoadingEnd,
    this.onPermissionPermanentlyDenied,
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

  /// Patches getUserMedia in the WebView so that any NotAllowedError
  /// (permanent OS permission denial) is forwarded to Flutter.
  Future<void> _injectPermissionBridge() async {
    const script = '''
      (function() {
        if (window.__tpGumPatched) return;
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) return;
        window.__tpGumPatched = true;

        var _origGetUserMedia = navigator.mediaDevices.getUserMedia.bind(navigator.mediaDevices);
        navigator.mediaDevices.getUserMedia = function(constraints) {
          return _origGetUserMedia(constraints).catch(function(err) {
            if (err.name === 'NotAllowedError' && window.ZoomPermissionChannel) {
              window.ZoomPermissionChannel.postMessage('onPermissionDenied');
            }
            return Promise.reject(err);
          });
        };
      })();
    ''';
    try {
      await _webViewController?.runJavaScript(script);
    } catch (_) {}
  }

  void onPageStarted(String url) {
    if (!_hasCompletedAutoJoin) {
      onLoadingStart?.call();
    }
  }

  void onPageFinished(String url) {
    _hideScrollbars();
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

  Future<void> _hideScrollbars() async {
    const script = '''
      (function () {
        try {
          var style = document.getElementById('tp-hide-scrollbars');
          if (!style) {
            style = document.createElement('style');
            style.id = 'tp-hide-scrollbars';
            style.innerHTML = '*::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; background: transparent !important; } * { scrollbar-width: none !important; -ms-overflow-style: none !important; }';
            document.head.appendChild(style);
          }
        } catch (e) {}
      })();
    ''';

    try {
      await _webViewController?.runJavaScript(script);
    } catch (e, st) {
      onError?.call(e, st);
    }
  }

  bool isZoomJoinGateUrl(String? url) {
    if (url == null || !ZoomWebViewConfig.isPermittedZoomUrl(url)) {
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
    const String javascript = '''
    (function() {
        var maxRetries = 20;
        var retries = 0;

        var checkExist = setInterval(function() {
            retries++;

            // GUARD: If the Zoom app-launch dialog is showing (user clicked "Join with app"),
            // do not auto-click anything — clicking "Join from browser" here causes a stutter loop.
            var allBtns = document.querySelectorAll('button');
            for (var i = 0; i < allBtns.length; i++) {
                var t = (allBtns[i].textContent || allBtns[i].innerText || '').toLowerCase();
                if (t.indexOf('zoom workplace app') > -1) {
                    clearInterval(checkExist);
                    return;
                }
            }

            // PHASE 0: Check if meeting room is active (video grid or controls loaded)
            var meetingApp = document.querySelector('#meeting-app') ||
                             document.querySelector('.meeting-app') ||
                             document.querySelector('.footer-button__button');
            if (meetingApp && meetingApp.offsetParent !== null) {
                clearInterval(checkExist);
                if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onMeetingDetected');
                return;
            }

            // PHASE 1: Join from your browser link on launcher page
            var joinBrowserLink = document.querySelector('a[href*="/wc/"]');
            if (joinBrowserLink && joinBrowserLink.offsetParent !== null) {
                joinBrowserLink.click();
                clearInterval(checkExist);
                if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onButtonClicked');
                return;
            }

            // PHASE 2: Join Audio / Computer Audio popup
            var joinAudioBtn = document.querySelector('button.join-audio-by-computer') ||
                               document.querySelector('[aria-label*="Join Audio"]') ||
                               document.querySelector('button[title*="Join Audio"]');
            if (joinAudioBtn && joinAudioBtn.offsetParent !== null) {
                joinAudioBtn.click();
                clearInterval(checkExist);
                if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onMeetingDetected');
                return;
            }

            // PHASE 3: Fallback button text
            var allButtons = document.querySelectorAll('button');
            for (var i = 0; i < allButtons.length; i++) {
                var text = (allButtons[i].textContent || allButtons[i].innerText || "").toLowerCase();
                if (text.indexOf('join from your browser') > -1 ||
                    text.indexOf('join by computer') > -1) {
                    allButtons[i].click();
                    clearInterval(checkExist);
                    if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onButtonClicked');
                    return;
                }
            }

            if (retries >= maxRetries) {
                clearInterval(checkExist);
                if (window.ZoomAutoJoin) window.ZoomAutoJoin.postMessage('onAutoJoinTimeout');
            }
        }, 500);
    })();
    ''';

    try {
      await _webViewController?.runJavaScript(javascript);
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
      onLoadingEnd?.call();
      onJoinSuccess?.call();
    } else if (message == 'onAutoJoinTimeout') {
      _cancelFallbackTimer();
      onJoinTimeout?.call();
    } else if (message == 'onPermissionDenied') {
      onPermissionPermanentlyDenied?.call();
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

class ZoomVideoConferenceScreen extends StatefulWidget {
  final String joinUrl;
  final String title;

  const ZoomVideoConferenceScreen({
    super.key,
    required this.joinUrl,
    required this.title,
  });

  @override
  State<ZoomVideoConferenceScreen> createState() =>
      _ZoomVideoConferenceScreenState();
}

class _ZoomVideoConferenceScreenState extends State<ZoomVideoConferenceScreen> {
  late WebViewController _webViewController;
  late ZoomAutoJoinHandler _autoJoinHandler;
  bool _isLoading = false;
  bool _isWebViewReady = false;
  bool _isShowingPermissionDialog = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeHandler();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndLoad();
    });
  }

  void _initializeHandler() {
    _autoJoinHandler = ZoomAutoJoinHandler(
      onLoadingStart: () {
        if (mounted) setState(() => _isLoading = true);
      },
      onLoadingEnd: () {
        if (mounted) setState(() => _isLoading = false);
      },
      onJoinSuccess: () {
        if (mounted) setState(() => _isLoading = false);
      },
      onJoinTimeout: () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      },
      onPermissionPermanentlyDenied: () {
        if (mounted) _showPermissionSettingsDialog();
      },
      onError: (error, stackTrace) {
        SentryService().captureException(error, stackTrace: stackTrace);
      },
    );
  }

  Future<void> _showPermissionSettingsDialog() async {
    if (_isShowingPermissionDialog || !mounted) return;

    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;
    final isPermanentlyDenied =
        cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied;

    if (!mounted) return;

    if (isPermanentlyDenied) {
      _isShowingPermissionDialog = true;
      try {
        final l10n = L10n.of(context);
        final confirmed = await showConfirmationDialog(
          context,
          title: l10n.zoomPermissionDialogTitle,
          content: l10n.zoomPermissionDialogContent,
          confirmText: l10n.openSettings,
          cancelText: l10n.notNow,
        );

        if (confirmed) {
          await openAppSettings();
        }
      } finally {
        _isShowingPermissionDialog = false;
      }
    } else {
      AppToast.show(
        context,
        message: L10n.of(context).zoomPermissionRequired,
        isError: true,
      );
    }
  }

  Future<void> _checkPermissionsAndLoad() async {
    final permissionsGranted =
        await ZoomPermissionHandler.checkAndRequestPermissions();

    if (!mounted) return;

    if (permissionsGranted) {
      await _setupWebView();
      if (!mounted) return;
      setState(() => _isWebViewReady = true);
    } else {
      await _showPermissionSettingsDialog();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _setupWebView() async {
    _webViewController = WebViewController(
      onPermissionRequest: (WebViewPermissionRequest request) async {
        final currentUrl = await _webViewController.currentUrl();
        final urlToCheck = (currentUrl != null && currentUrl.isNotEmpty)
            ? currentUrl
            : widget.joinUrl;
        final isPermittedHost =
            ZoomWebViewConfig.isPermittedZoomUrl(urlToCheck);

        final isAllowedResourceType = request.types.isNotEmpty &&
            request.types.every((type) =>
                type == WebViewPermissionResourceType.camera ||
                type == WebViewPermissionResourceType.microphone);

        if (isPermittedHost && isAllowedResourceType) {
          await request.grant();
        } else {
          await request.deny();
        }
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (_hasError && mounted) {
              setState(() => _hasError = false);
            }
            _autoJoinHandler.onPageStarted(url);
          },
          onPageFinished: (String url) {
            _autoJoinHandler.onPageFinished(url);
          },
          onNavigationRequest: (request) {
            if (ZoomWebViewConfig.isPermittedZoomUrl(request.url)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame == true && error.errorCode != -999) {
              SentryService().captureException(
                'Zoom WebView main frame load failure: ${error.description} (code: ${error.errorCode})',
                stackTrace: StackTrace.current,
              );
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
            }
          },
        ),
      );

    _autoJoinHandler.attach(_webViewController);
    await ZoomWebViewConfig.setupWebViewSettings(_webViewController, context);

    _webViewController.loadRequest(Uri.parse(widget.joinUrl));
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    Widget bodyContent;
    if (_hasError) {
      bodyContent = Center(
        child: AppErrorView(
          onRetry: () {
            _autoJoinHandler.reset();
            setState(() {
              _hasError = false;
              _isLoading = true;
            });
            _webViewController.loadRequest(Uri.parse(widget.joinUrl));
          },
        ),
      );
    } else {
      bodyContent = Stack(
        children: [
          if (_isWebViewReady) WebViewWidget(controller: _webViewController),
          if (_isLoading)
            AppSemantics.container(
              label: L10n.of(context).zoomJoinMeetingLoading,
              child: Container(
                color: design.colors.canvas,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppLoadingIndicator(
                        color: design.colors.primary,
                      ),
                      SizedBox(height: design.spacing.sm),
                      AppText.label(
                        L10n.of(context).zoomJoinMeetingLoading,
                        color: design.colors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return LessonDetailShell(
      title: widget.title,
      onBack: () => Navigator.of(context).pop(),
      backgroundColor: design.colors.canvas,
      child: SafeArea(
        top: false,
        child: bodyContent,
      ),
    );
  }

  @override
  void dispose() {
    _autoJoinHandler.dispose();
    super.dispose();
  }
}
