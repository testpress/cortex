import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';

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
    this.semanticLabel,
  });

  /// The iframe embed source URL (e.g. YouTube, Vimeo, or LMS embed link).
  final String src;

  /// Aspect ratio of the iframe container. Defaults to 16:9.
  final double aspectRatio;

  /// Optional border radius. Defaults to [DesignConfig.radius.md].
  final BorderRadius? borderRadius;

  /// Optional background placeholder color.
  final Color? backgroundColor;

  /// Optional accessibility semantic label. Defaults to 'Embedded video player'.
  final String? semanticLabel;

  /// Normalizes protocol-relative or bare URLs to full HTTPS URLs.
  @visibleForTesting
  static String normalizeUrl(String rawUrl) {
    var url = rawUrl.trim();
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  @override
  State<AppIframeView> createState() => _AppIframeViewState();
}

class _AppIframeViewState extends State<AppIframeView> {
  late final WebViewController _controller;

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

            // Only allow the base origin, initial embed page, or embed player URLs.
            // Blocks wandering to external sites, youtube.com/watch, channels, or suggested videos.
            final url = request.url;
            final isBaseOrigin = url.startsWith('https://www.testpress.in');
            final isEmbedUrl =
                uri.path.contains('/embed/') ||
                uri.path.contains('/video/') ||
                url == AppIframeView.normalizeUrl(widget.src);

            if (isBaseOrigin || isEmbedUrl) {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      );
  }

  void _loadIframe() {
    final normalized = AppIframeView.normalizeUrl(widget.src);
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
      src="$normalized"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      allowfullscreen>
    </iframe>
  </body>
</html>
''';
    _controller.loadHtmlString(html, baseUrl: 'https://www.testpress.in');
  }

  @override
  void didUpdateWidget(covariant AppIframeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src) {
      _loadIframe();
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(design.radius.md);
    final effectiveBg = widget.backgroundColor ?? design.colors.surfaceVariant;

    return AppSemantics.container(
      label: widget.semanticLabel ?? 'Embedded video player',
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: ClipRRect(
          borderRadius: effectiveRadius,
          child: Container(
            color: effectiveBg,
            child: WebViewWidget(controller: _controller),
          ),
        ),
      ),
    );
  }
}
