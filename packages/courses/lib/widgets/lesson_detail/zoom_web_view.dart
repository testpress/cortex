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

    bool allGranted = true;
    for (var status in statuses.values) {
      if (!status.isGranted) {
        allGranted = false;
        break;
      }
    }

    return allGranted;
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

    // Explicitly reject app-switch schemes or intents
    if (url.startsWith('zoomus:') ||
        url.startsWith('zoommtg:') ||
        url.startsWith('intent:') ||
        url.startsWith('market:')) {
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

    // Block navigation to download/app stores or marketing sales funnels
    final path = uri.path.toLowerCase();
    if (path.startsWith('/download') ||
        path.startsWith('/pricing') ||
        path.startsWith('/signup')) {
      return false;
    }

    return true;
  }
}

class ZoomAutoJoinHandler {
  WebViewController? _webViewController;
  bool _hasCompletedAutoJoin = false;
  bool _isDisposed = false;

  final Function()? onJoinSuccess;
  final Function()? onJoinTimeout;
  final Function()? onLoadingStart;
  final Function()? onLoadingEnd;
  final Function(Object error, StackTrace stackTrace)? onError;

  ZoomAutoJoinHandler({
    this.onJoinSuccess,
    this.onJoinTimeout,
    this.onLoadingStart,
    this.onLoadingEnd,
    this.onError,
  });

  void attach(WebViewController controller) {
    _webViewController = controller;

    _webViewController?.addJavaScriptChannel(
      'ZoomAutoJoin',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message);
      },
    );
  }

  void onPageStarted(String url) {
    if (!_hasCompletedAutoJoin) {
      onLoadingStart?.call();
    }
  }

  void onPageFinished(String url) {
    _hideScrollbars();

    if (!_hasCompletedAutoJoin && isZoomJoinGateUrl(url)) {
      _autoJoinZoomMeetingWeb();
    } else {
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
    if (url == null) return false;

    final normalizedUrl = url.toLowerCase();
    return normalizedUrl.contains('zoom.us') &&
        (normalizedUrl.contains('/j/') ||
            normalizedUrl.contains('/wc/') ||
            normalizedUrl.contains('/join'));
  }

  Future<void> _autoJoinZoomMeetingWeb() async {
    const String javascript = '''
    (function() {
        var maxRetries = 20;
        var retries = 0;

        var checkExist = setInterval(function() {
            retries++;

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
      onJoinTimeout?.call();
    }
  }

  void _handleJavaScriptMessage(String message) {
    if (_isDisposed) return;

    if (message == 'onButtonClicked') {
      _hasCompletedAutoJoin = true;
    } else if (message == 'onMeetingDetected') {
      _hasCompletedAutoJoin = true;
      onLoadingEnd?.call();
      onJoinSuccess?.call();
    } else if (message == 'onAutoJoinTimeout') {
      onJoinTimeout?.call();
    }
  }

  @visibleForTesting
  void simulateJsMessage(String message) => _handleJavaScriptMessage(message);

  void dispose() {
    _isDisposed = true;
    _hasCompletedAutoJoin = false;
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
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeHandler();
    _checkPermissionsAndLoad();
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
          AppToast.show(
            context,
            message: L10n.of(context).liveStreamJoinFailed,
            isError: true,
          );
        }
      },
      onError: (error, stackTrace) {
        SentryService().captureException(error, stackTrace: stackTrace);
      },
    );
  }

  Future<void> _checkPermissionsAndLoad() async {
    final permissionsGranted =
        await ZoomPermissionHandler.checkAndRequestPermissions();

    if (permissionsGranted && mounted) {
      setState(() => _permissionsGranted = true);
      await _setupWebView();
    } else if (mounted) {
      AppToast.show(
        context,
        message: L10n.of(context).teamsPermissionRequired,
        isError: true,
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _setupWebView() async {
    _webViewController = WebViewController(
      onPermissionRequest: (WebViewPermissionRequest request) {
        request.grant();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
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
            // Ignored background resource errors
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

    return LessonDetailShell(
      title: widget.title,
      onBack: () => Navigator.of(context).pop(),
      backgroundColor: design.colors.canvas,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            if (_permissionsGranted)
              WebViewWidget(controller: _webViewController),
            if (_isLoading)
              AppSemantics.container(
                label: L10n.of(context).teamsJoinMeetingLoading,
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
                          L10n.of(context).teamsJoinMeetingLoading,
                          color: design.colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoJoinHandler.dispose();
    super.dispose();
  }
}
