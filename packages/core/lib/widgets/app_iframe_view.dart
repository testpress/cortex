import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../design/design_provider.dart';
import '../data/config/app_config.dart';
import 'app_loading_indicator.dart';

/// A platform-neutral inline iframe embed view.
///
/// Encapsulates an isolated [WebViewWidget] inside an aspect-ratio container
/// with rounded corners and HTTPS origin configuration
/// to avoid cross-origin / Error 153 issues with video embeds (such as YouTube).
class AppIframeView extends StatefulWidget {
  const AppIframeView({
    super.key,
    required this.src,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.backgroundColor,
    this.baseUrl,
  });

  /// The iframe embed source URL (e.g. YouTube embed link).
  final String src;

  /// Aspect ratio of the iframe container. Defaults to 16:9.
  final double aspectRatio;

  /// Optional border radius. Defaults to [DesignConfig.radius.md].
  final BorderRadius? borderRadius;

  /// Optional background placeholder color.
  final Color? backgroundColor;

  final String? baseUrl;

  /// Normalizes protocol-relative or bare URLs to full HTTPS URLs.
  ///
  /// Rejects non-http(s) schemes (e.g. `javascript:`, `data:`) by returning an empty string.
  /// Validates with [Uri.tryParse] and re-serializes to ensure a well-formed URL.
  static String normalizeUrl(String rawUrl) {
    var url = rawUrl.trim();
    if (url.isEmpty) return '';

    if (url.startsWith('//')) {
      url = 'https:$url';
    } else {
      final schemeMatch = RegExp(
        r'^([a-zA-Z][a-zA-Z0-9+\-.]*):',
      ).firstMatch(url);
      if (schemeMatch != null) {
        final scheme = schemeMatch.group(1)!.toLowerCase();
        if (scheme != 'http' && scheme != 'https') {
          return '';
        }
      } else {
        url = 'https://$url';
      }
    }

    final parsed = Uri.tryParse(url);
    if (parsed == null ||
        !parsed.hasScheme ||
        (parsed.scheme != 'http' && parsed.scheme != 'https')) {
      return '';
    }

    return parsed.toString();
  }

  /// Checks whether [rawUrl] is a supported YouTube embed URL.
  ///
  /// Rejects non-HTTP(S) schemes, non-YouTube hosts, and paths that do not
  /// start with `/embed/`.
  static bool isSupportedUrl(String rawUrl) {
    final normalized = normalizeUrl(rawUrl);
    if (normalized.isEmpty) return false;
    final uri = Uri.tryParse(normalized);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    final isYouTube =
        host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com');
    if (!isYouTube) return false;
    return uri.path.startsWith('/embed/');
  }

  static String _escapeHtmlAttribute(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }

  @override
  State<AppIframeView> createState() => _AppIframeViewState();
}

class _AppIframeViewState extends State<AppIframeView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupController();
    _loadIframe();
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

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted && !_isLoading) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (_) {
            if (mounted && _isLoading) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (_) {
            if (mounted && _isLoading) {
              setState(() => _isLoading = false);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) {
              return NavigationDecision.prevent;
            }

            // Prevent non-http/https schemes (such as intent:// or market://)
            // from crashing the WebView with net::ERR_UNKNOWN_URL_SCHEME.
            if (uri.scheme != 'http' && uri.scheme != 'https') {
              return NavigationDecision.prevent;
            }

            final requestHost = uri.host.toLowerCase();
            if (requestHost.isEmpty) {
              return NavigationDecision.prevent;
            }

            // 1. Allow tenant base origin (exact host match)
            final effectiveBase = _effectiveBaseUrl;
            if (effectiveBase != null) {
              final baseUri = Uri.tryParse(effectiveBase);
              final baseHost = baseUri?.host.toLowerCase();
              final isBaseOrigin =
                  baseHost != null &&
                  baseHost.isNotEmpty &&
                  requestHost == baseHost;

              if (isBaseOrigin) {
                return NavigationDecision.navigate;
              }
            }

            // 2. Only YouTube embed provider is permitted (/embed/ path)
            if (AppIframeView.isSupportedUrl(request.url)) {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      );
  }

  String? get _effectiveBaseUrl {
    final custom = widget.baseUrl?.trim();
    if (custom != null && custom.isNotEmpty) {
      final normalized = AppIframeView.normalizeUrl(custom);
      if (normalized.isNotEmpty) return normalized;
    }
    final configUrl = AppConfig.apiBaseUrl.trim();
    if (configUrl.isNotEmpty) {
      final normalized = AppIframeView.normalizeUrl(configUrl);
      if (normalized.isNotEmpty) return normalized;
    }
    return null;
  }

  void _loadIframe() {
    final normalized = AppIframeView.normalizeUrl(widget.src);
    if (normalized.isEmpty) {
      if (_isLoading) {
        if (mounted) {
          setState(() => _isLoading = false);
        } else {
          _isLoading = false;
        }
      }
      _controller.loadHtmlString('<!DOCTYPE html><html><body></body></html>');
      return;
    }

    final escapedSrc = AppIframeView._escapeHtmlAttribute(normalized);
    final html =
        '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <style>
      * { box-sizing: border-box; }
      html, body {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        overflow: hidden;
        background-color: transparent;
      }
      iframe {
        width: 100%;
        height: 100%;
        border: 0;
      }
    </style>
  </head>
  <body>
    <iframe
      src="$escapedSrc"
      frameborder="0"
      allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen>
    </iframe>
  </body>
</html>
''';
    _controller.loadHtmlString(html, baseUrl: _effectiveBaseUrl);
  }

  @override
  void didUpdateWidget(covariant AppIframeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src || oldWidget.baseUrl != widget.baseUrl) {
      setState(() => _isLoading = true);
      _loadIframe();
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(design.radius.md);
    final effectiveBg = widget.backgroundColor ?? design.colors.surfaceVariant;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: Container(
          color: effectiveBg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              WebViewWidget(
                controller: _controller,
                gestureRecognizers:
                    const <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        EagerGestureRecognizer.new,
                      ),
                    },
              ),
              if (_isLoading) const Center(child: AppLoadingIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
