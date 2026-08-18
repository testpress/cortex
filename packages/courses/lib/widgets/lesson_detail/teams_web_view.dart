import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:core/core.dart';

class TeamsPermissionHandler {
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

class TeamsWebViewConfig {
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
}

class TeamsAutoJoinHandler {
  late WebViewController _webViewController;
  bool _hasCompletedAutoJoin = false;
  bool _isDisposed = false;

  final Function()? onJoinSuccess;
  final Function()? onJoinTimeout;
  final Function()? onLoadingStart;
  final Function()? onLoadingEnd;
  final Function(Object error, StackTrace stackTrace)? onError;

  TeamsAutoJoinHandler({
    this.onJoinSuccess,
    this.onJoinTimeout,
    this.onLoadingStart,
    this.onLoadingEnd,
    this.onError,
  });

  void attach(WebViewController controller) {
    _webViewController = controller;

    _webViewController.addJavaScriptChannel(
      'TeamsAutoJoin',
      onMessageReceived: (JavaScriptMessage message) {
        _handleJavaScriptMessage(message.message);
      },
    );
  }

  void onPageStarted(String url) {
    // Only show loader if we haven't completed the join flow yet
    if (!_hasCompletedAutoJoin) {
      onLoadingStart?.call();
    }
  }

  void onPageFinished(String url) {
    _hideScrollbars();

    if (!_hasCompletedAutoJoin && _isTeamsJoinGateUrl(url)) {
      _autoJoinTeamsMeetingWeb();
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
      await _webViewController.runJavaScript(script);
    } catch (e, st) {
      onError?.call(e, st);
    }
  }

  bool _isTeamsJoinGateUrl(String? url) {
    if (url == null) return false;

    final normalizedUrl = url.toLowerCase();
    return normalizedUrl.contains('teams.microsoft.com') &&
        (normalizedUrl.contains('launcher') ||
            normalizedUrl.contains('join') ||
            normalizedUrl.contains('pre-join') ||
            normalizedUrl.contains('meetup-join'));
  }

  Future<void> _autoJoinTeamsMeetingWeb() async {
    const String javascript = '''
    (function() {
        var maxRetries = 20;
        var retries = 0;
        
        var checkExist = setInterval(function() {
            retries++;
            console.log('Auto-join attempt: ' + retries + '/' + maxRetries);
            
            // PHASE 0: Check if we bypassed the gate and are already in the lobby
            var lobbyBtn = document.querySelector('[data-tid="prejoin-join-button"]');
            var nameInput = document.querySelector('[data-tid="prejoin-display-name-input"]');
            if ((lobbyBtn && lobbyBtn.offsetParent !== null) || (nameInput && nameInput.offsetParent !== null)) {
                console.log('Lobby detected. Dropping overlay.');
                clearInterval(checkExist);
                window.TeamsAutoJoin.postMessage('onLobbyDetected');
                return;
            }
            
            // PHASE 1: Try data-tid selectors
            var selectors = [
                '[data-tid="joinOnWeb"]',
                '[data-tid="joinBrowserButton"]',
                'button[data-tid*="web"]'
            ];
            for (var j = 0; j < selectors.length; j++) {
                var btn = document.querySelector(selectors[j]);
                if (btn && btn.offsetParent !== null) {
                    btn.click();
                    clearInterval(checkExist);
                    window.TeamsAutoJoin.postMessage('onButtonClicked');
                    return;
                }
            }
            
            // PHASE 2: Text content fallback
            var allButtons = document.querySelectorAll('button');
            for (var i = 0; i < allButtons.length; i++) {
                var text = (allButtons[i].textContent || allButtons[i].innerText || "").toLowerCase();
                if (text.indexOf('continue on this browser') > -1 || 
                    text.indexOf('join on the web') > -1) {
                    allButtons[i].click();
                    clearInterval(checkExist);
                    window.TeamsAutoJoin.postMessage('onButtonClicked');
                    return;
                }
            }
            
            // PHASE 3: Timeout
            if (retries >= maxRetries) {
                console.log('Auto-join timeout after ' + maxRetries + ' attempts');
                clearInterval(checkExist);
                window.TeamsAutoJoin.postMessage('onAutoJoinTimeout');
            }
        }, 500);
    })();
    ''';

    try {
      await _webViewController.runJavaScript(javascript);
    } catch (e, st) {
      onError?.call(e, st);
      onJoinTimeout?.call();
    }
  }

  void _handleJavaScriptMessage(String message) {
    if (_isDisposed) return;

    if (message == 'onButtonClicked') {
      // Gate button clicked. Don't drop loader. Wait for next page to load.
      _hasCompletedAutoJoin = true;
    } else if (message == 'onLobbyDetected') {
      // Already in lobby (bypassed gate). Drop loader immediately.
      _hasCompletedAutoJoin = true;
      onLoadingEnd?.call();
      onJoinSuccess?.call();
    } else if (message == 'onAutoJoinTimeout') {
      onJoinTimeout?.call();
    }
  }

  void dispose() {
    _isDisposed = true;
    _hasCompletedAutoJoin = false;
  }
}

class TeamsVideoConferenceScreen extends StatefulWidget {
  final String joinUrl;
  final String title;

  const TeamsVideoConferenceScreen({
    super.key,
    required this.joinUrl,
    required this.title,
  });

  @override
  State<TeamsVideoConferenceScreen> createState() =>
      _TeamsVideoConferenceScreenState();
}

class _TeamsVideoConferenceScreenState
    extends State<TeamsVideoConferenceScreen> {
  late WebViewController _webViewController;
  late TeamsAutoJoinHandler _autoJoinHandler;
  bool _isLoading = false;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeHandler();
    _checkPermissionsAndLoad();
  }

  void _initializeHandler() {
    _autoJoinHandler = TeamsAutoJoinHandler(
      onLoadingStart: () {
        setState(() => _isLoading = true);
      },
      onLoadingEnd: () {
        setState(() => _isLoading = false);
      },
      onJoinSuccess: () {
        setState(() => _isLoading = false);
      },
      onJoinTimeout: () {
        setState(() => _isLoading = false);
        AppToast.show(
          context,
          message: L10n.of(context).liveStreamJoinFailed,
          isError: true,
        );
      },
      onError: (error, stackTrace) {
        SentryService().captureException(error, stackTrace: stackTrace);
      },
    );
  }

  Future<void> _checkPermissionsAndLoad() async {
    // Note: On Android, permissions are gated by both the OS and the WebView's
    // onPermissionRequest callback. On iOS, permission_handler requests the
    // OS-level permission, and the WebView's onPermissionRequest is essentially
    // a no-op that relies on the OS-level prompt.
    final permissionsGranted =
        await TeamsPermissionHandler.checkAndRequestPermissions();

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
            final uri = Uri.tryParse(request.url);
            // Prevent non-HTTP deep links (e.g. msteams://) from crashing the WebView.
            if (uri != null && !['http', 'https'].contains(uri.scheme)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Ignored Teams background resource error
          },
        ),
      );

    _autoJoinHandler.attach(_webViewController);
    await TeamsWebViewConfig.setupWebViewSettings(_webViewController, context);

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
        top: false, // LessonDetailShell handles top safe area
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
