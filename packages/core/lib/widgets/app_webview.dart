import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import '../data/auth/auth_provider.dart';
import '../widgets/app_error_view.dart';
import '../accessibility/app_semantics.dart';
import '../localization/l10n_helper.dart';

/// A platform-neutral web page viewer.
///
/// Displays a single web page with loading progress and error handling.
/// Navigation away from the loaded page is disabled.
class AppWebView extends ConsumerStatefulWidget {
  const AppWebView({super.key, required this.url});

  final String url;

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
    _loadUrl(widget.url);
  }

  @override
  void didUpdateWidget(covariant AppWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _progress.value = 0;
      _hasError.value = false;
      _loadUrl(widget.url);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _hasError.dispose();
    super.dispose();
  }

  void _setupController() {
    _controller = WebViewController()
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
          onWebResourceError: (error) {
            // Ignore minor errors or subresource failures
            if (error.isForMainFrame == true) {
              _hasError.value = true;
            }
          },
          onNavigationRequest: (_) {
            return NavigationDecision.prevent;
          },
        ),
      );
  }

  Future<Map<String, String>> _buildHeaders(Uri uri, String url) async {
    final authDataSource = ref.read(authLocalDataSourceProvider);
    final token = await authDataSource.getToken();

    if (!mounted || url != widget.url) return <String, String>{};

    return AppWebView.buildHeaders(
      requestUri: uri,
      requestUrl: url,
      initialUrl: widget.url,
      token: token,
    );
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
      child: Column(
        children: [
          _buildProgressBar(design),
          Expanded(child: _buildWebViewStack()),
        ],
      ),
    );
  }
}
