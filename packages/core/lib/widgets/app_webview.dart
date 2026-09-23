import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import '../data/auth/auth_provider.dart';
import '../data/services/sentry_service.dart';
import '../widgets/app_error_view.dart';
import '../widgets/app_header.dart';
import '../widgets/app_back_button.dart';
import '../accessibility/app_semantics.dart';
import '../localization/l10n_helper.dart';

/// A platform-neutral web page viewer.
///
/// Displays a web page with loading progress and error handling.
class AppWebView extends ConsumerStatefulWidget {
  const AppWebView({
    super.key,
    required this.url,
    this.title,
    this.permissions,
    this.mediaMode = false,
    this.showHeader = false,
  });

  final String url;
  final String? title;
  final List<Permission>? permissions;
  final bool mediaMode;
  final bool showHeader;

  /// Helper to construct headers with auth token for secure requests.
  @visibleForTesting
  static Map<String, String> buildHeaders({
    required Uri requestUri,
    required String requestUrl,
    required String initialUrl,
    required String? token,
  }) {
    final headers = <String, String>{};
    if (requestUri.scheme != 'https') return headers;

    final initialUri = Uri.tryParse(initialUrl);
    if (initialUri == null || requestUri.host != initialUri.host) {
      return headers;
    }

    if (requestUrl != initialUrl) return headers;

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'JWT $token';
    }
    return headers;
  }

  @override
  ConsumerState<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends ConsumerState<AppWebView> {
  late final WebViewController _controller;
  final ValueNotifier<int> _progress = ValueNotifier<int>(0);
  final ValueNotifier<bool> _hasError = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _setupController();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final permissions = widget.permissions;
    if (permissions != null && permissions.isNotEmpty) {
      await permissions.request();
    }

    try {
      final defaultUa = await _controller.getUserAgent() ?? '';
      final appIdentifier = Platform.isAndroid
          ? 'TestpressAndroidApp/WebView flutter-app'
          : 'TestpressIOSApp/WebView flutter-app';
      if (!defaultUa.contains('TestpressAndroidApp') &&
          !defaultUa.contains('TestpressIOSApp')) {
        final newUa = defaultUa.isEmpty
            ? appIdentifier
            : '$defaultUa $appIdentifier';
        await _controller.setUserAgent(newUa);
      }
    } catch (e, stackTrace) {
      ref
          .read(sentryServiceProvider)
          .captureException(
            e,
            stackTrace: stackTrace,
            tags: const {'feature': 'webview_user_agent'},
          );
    }
    if (mounted) {
      _loadUrl(widget.url);
    }
  }

  @override
  void didUpdateWidget(covariant AppWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _progress.value = 0;
      _hasError.value = false;
      _initWebView();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _hasError.dispose();
    super.dispose();
  }

  void _setupController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller =
        WebViewController.fromPlatformCreationParams(
            params,
            onPermissionRequest:
                (WebViewPlatform.instance is WebKitWebViewPlatform ||
                    WebViewPlatform.instance is AndroidWebViewPlatform)
                ? (request) {
                    if (widget.mediaMode) {
                      request.grant();
                    } else {
                      request.deny();
                    }
                  }
                : null,
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (progress) {
                _progress.value = progress;
              },
              onPageStarted: (_) {
                _hasError.value = false;
                _progress.value = 0;
              },
              onPageFinished: (url) async {
                if (widget.mediaMode) {
                  try {
                    await _controller.runJavaScript('''
              document.documentElement.style.margin = '0';
              document.documentElement.style.padding = '0';
              document.body.style.margin = '0';
              document.body.style.padding = '0';
            ''');
                  } catch (_) {}
                }
              },
              onWebResourceError: (error) {
                // Ignore subresource failures or cancelled loads due to redirects/navigation
                if (error.isForMainFrame == true && error.errorCode != -999) {
                  _hasError.value = true;
                }
              },
              onNavigationRequest: (request) {
                final uri = Uri.tryParse(request.url);
                if (uri != null && !['http', 'https'].contains(uri.scheme)) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );
  }

  Future<Map<String, String>> _buildHeaders(Uri uri, String url) async {
    final authDataSource = ref.read(authLocalDataSourceProvider);
    final token = await authDataSource.getToken();

    if (!mounted || url != widget.url) return <String, String>{};

    final headers = AppWebView.buildHeaders(
      requestUri: uri,
      requestUrl: url,
      initialUrl: widget.url,
      token: token,
    );
    if (headers.containsKey('Authorization')) {
      headers['X-Device-Type'] = 'mobile_app';
    }
    return headers;
  }

  Future<void> _loadUrl(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      _hasError.value = true;
      return;
    }

    final headers = await _buildHeaders(uri, url);
    if (!mounted || url != widget.url) return;

    try {
      await _controller.loadRequest(uri, headers: headers);
    } catch (_) {
      if (mounted && url == widget.url) {
        _hasError.value = true;
      }
    }
  }

  Widget _buildProgressBar(DesignConfig design) {
    return ValueListenableBuilder<int>(
      valueListenable: _progress,
      builder: (context, progress, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _hasError,
          builder: (context, hasError, child) {
            if (progress < 100 && !hasError) {
              final double value = progress / 100.0;
              return AppSemantics.progressValue(
                value: value,
                label: L10n.of(context).labelPageLoadProgress,
                child: Container(
                  height: 3,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  color: design.colors.surfaceVariant,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: Container(color: design.colors.primary),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildWebViewStack() {
    return Stack(
      fit: StackFit
          .expand, // Forces tight constraints on the WebView platform view
      children: [
        WebViewWidget(controller: _controller),
        ValueListenableBuilder<bool>(
          valueListenable: _hasError,
          builder: (context, hasError, child) {
            if (hasError) {
              return AppErrorView(
                onRetry: () {
                  _hasError.value = false;
                  _progress.value = 0;
                  _loadUrl(widget.url);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      color: design.colors.canvas,
      child: SafeArea(
        child: Column(
          children: [
            if (widget.showHeader)
              AppHeader(
                title: widget.title ?? '',
                leading: AppBackButton(
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            _buildProgressBar(design),
            Expanded(child: _buildWebViewStack()),
          ],
        ),
      ),
    );
  }
}
