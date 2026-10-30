import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:core/core.dart';
import 'zoom_web_view_config.dart';
import 'zoom_auto_join_handler.dart';
import 'zoom_permission_handler.dart';

class ZoomVideoConferenceScreen extends StatefulWidget {
  final String joinUrl;
  final String title;
  final VoidCallback? onMeetingExit;

  const ZoomVideoConferenceScreen({
    super.key,
    required this.joinUrl,
    required this.title,
    this.onMeetingExit,
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
  bool _hasPopped = false;

  void _handleMeetingExit() {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    if (widget.onMeetingExit != null) {
      widget.onMeetingExit!();
    } else {
      Navigator.of(context).pop();
    }
  }

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
      onMeetingLeft: () {
        _handleMeetingExit();
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
        _handleMeetingExit();
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
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (ZoomWebViewConfig.isZoomExitUrl(url)) {
              _handleMeetingExit();
              return;
            }
            if (_hasError && mounted) {
              setState(() => _hasError = false);
            }
            _autoJoinHandler.onPageStarted(url);
          },
          onPageFinished: (String url) {
            if (ZoomWebViewConfig.isZoomExitUrl(url)) {
              _handleMeetingExit();
              return;
            }
            _autoJoinHandler.onPageFinished(url);
          },
          onUrlChange: (UrlChange change) {
            if (ZoomWebViewConfig.isZoomExitUrl(change.url)) {
              _handleMeetingExit();
            }
          },
          onNavigationRequest: (request) {
            if (ZoomWebViewConfig.isZoomExitUrl(request.url)) {
              _handleMeetingExit();
              return NavigationDecision.prevent;
            }
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
      onBack: () => _handleMeetingExit(),
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
